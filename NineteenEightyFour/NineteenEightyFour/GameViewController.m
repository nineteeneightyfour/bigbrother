#import "GameViewController.h"
#import "CameraOverlayView.h"
#import "CameraOverlay.h"

const CLLocationDegrees kLatitudeDelta = .0034;


@implementation GameViewController

@synthesize mapView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

#if !TARGET_IPHONE_SIMULATOR
    // CLLocationManager permet la gestion de la position géographique de l'utilisateur
	locationManager=[[CLLocationManager alloc] init];
	[locationManager setDelegate:self];
	[locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
	[locationManager startUpdatingLocation];
#endif
    
    cameras = [[NSMutableArray array] retain];
    
    [self createCameras];

#if TARGET_IPHONE_SIMULATOR
    [self playerMovedTo:CLLocationCoordinate2DMake(48.870262, 2.342624)];
    timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(tick) userInfo:nil repeats:YES];
#endif

}

- (void)tick
{
    [self playerMovedTo:CLLocationCoordinate2DMake(lastPosition.latitude + 0.000001, lastPosition.longitude)];
}

- (void)createCameras
{
    CLLocationDistance cameraRadius = 30.0;

    for (int i=0; i<2; i++) {
        CLLocationCoordinate2D cameraPosition = CLLocationCoordinate2DMake(48.870062+i*0.0005, 2.342624);
        [self addCameraWithPosition:cameraPosition andRadius:cameraRadius];
    }

    CameraOverlay *overlay = [[CameraOverlay alloc] initWithCameras:cameras];
    [mapView addOverlay:overlay];
}

- (void)addCameraWithPosition:(CLLocationCoordinate2D)cameraPosition andRadius:(CLLocationDistance)cameraRadius
{
    Camera *camera = [Camera cameraWithPosition:cameraPosition andRadius:cameraRadius];
    
    [cameras addObject:camera];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    CLLocationCoordinate2D coordinate = newLocation.coordinate;
    [self playerMovedTo:coordinate];
}

- (void)playerMovedTo:(CLLocationCoordinate2D)coordinate
{
    MKCoordinateRegion region;
	region.center = coordinate;
	region.span.latitudeDelta = kLatitudeDelta;
	region.span.longitudeDelta = kLatitudeDelta;
	[mapView setRegion:region animated:TRUE];
    
    lastPosition = coordinate;
    
    for (Camera *camera in cameras) {
        camera.isActive = [camera seesPoint:lastPosition];
    }

    id<MKOverlay> theOverlay = [[mapView overlays] objectAtIndex:0];
    CameraOverlayView *theOverlayView = (CameraOverlayView *)[mapView viewForOverlay:theOverlay];
    [theOverlayView setNeedsDisplay];
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay
{
    return [[[CameraOverlayView alloc ] initWithOverlay:overlay] autorelease];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [locationManager release], locationManager = nil;
    [cameras release], cameras = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
