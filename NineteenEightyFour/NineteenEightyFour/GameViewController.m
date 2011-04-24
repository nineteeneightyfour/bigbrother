#import "GameViewController.h"
#import "CameraOverlayView.h"
#import "CameraOverlay.h"

const CLLocationDegrees kLatitudeDelta = .002;


@implementation GameViewController

@synthesize mapView;
@synthesize appGameLoopSoundPlayer;
@synthesize spottedLoopSoundPlayer;

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

    self.appGameLoopSoundPlayer = [self makeAudioPlayer:@"son_game" ofType:@"wav"];
    self.spottedLoopSoundPlayer = [self makeAudioPlayer:@"son_alerte" ofType:@"wav"];
    [appGameLoopSoundPlayer play];


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
    CLLocationDistance cameraRadius = 35.0;

    for (int i=0; i<2; i++) {
        CLLocationCoordinate2D cameraPosition = CLLocationCoordinate2DMake(48.870058+i*0.0008, 2.342756);
        [self addCameraWithPosition:cameraPosition andRadius:cameraRadius];
    }

    CameraOverlay *overlay = [[[CameraOverlay alloc] initWithCameras:cameras] autorelease];
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
    
    BOOL isSpotted = false;
    for (Camera *camera in cameras) {
        camera.isActive = [camera seesPoint:lastPosition];
        if (camera.isActive) {
            isSpotted = YES;
        }
    }
    
    if (isSpotted) {
        [self.appGameLoopSoundPlayer stop];
        [self.spottedLoopSoundPlayer play];
    } else {
        [self.appGameLoopSoundPlayer play];
        [self.spottedLoopSoundPlayer stop];
    }

    id<MKOverlay> theOverlay = [[mapView overlays] objectAtIndex:0];
    CameraOverlayView *theOverlayView = (CameraOverlayView *)[mapView viewForOverlay:theOverlay];
    [theOverlayView setNeedsDisplayInMapRect:MKMapRectWorld];
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

- (AVAudioPlayer*)makeAudioPlayer:(NSString*)path ofType:(NSString*)type
{
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource: path ofType: type];
    NSURL *soundFileURL = [[[NSURL alloc] initFileURLWithPath: soundFilePath] autorelease];
	AVAudioPlayer *audioPLayer = [[[AVAudioPlayer alloc] initWithContentsOfURL: soundFileURL error: nil] autorelease];
    [audioPLayer setVolume: 1.0];
    [audioPLayer setNumberOfLoops: -1];
    return audioPLayer;
}

@end
