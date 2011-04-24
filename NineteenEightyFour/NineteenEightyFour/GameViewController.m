#import "GameViewController.h"
#import "CameraOverlayView.h"
#import "CameraOverlay.h"
#import "KMLParser.h"

const CLLocationDegrees kLatitudeDelta = .002;


@implementation GameViewController

@synthesize mapView;
@synthesize vignette;
@synthesize appGameLoopSoundPlayer;
@synthesize spottedLoopSoundPlayer;
@synthesize hackSwitch;
@synthesize moviePlayerController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        spottingCamera = nil;
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

    self.appGameLoopSoundPlayer = [self makeAudioPlayer:@"son_game" ofType:@"wav" withVolume:1.0];
    self.spottedLoopSoundPlayer = [self makeAudioPlayer:@"son_alerte" ofType:@"wav" withVolume:0.0];

    NSString *movpath = [[NSBundle mainBundle] pathForResource:@"hack" ofType:@"m4v"];
    
    self.moviePlayerController = [[MPMoviePlayerViewController alloc] initWithContentURL: [NSURL fileURLWithPath:movpath]];
    
    self.moviePlayerController.moviePlayer.shouldAutoplay = NO;
    
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
#endif
    NSLog(@"starting timer...");
    timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(tick) userInfo:nil repeats:YES];


}

- (void)tick
{
#if TARGET_IPHONE_SIMULATOR
    double newLat = lastPosition.latitude + 0.000005;
    double newLong = lastPosition.longitude;
    NSLog(@"moving to (%f,%f)", newLat, newLong);
   [self playerMovedTo:CLLocationCoordinate2DMake(newLat, newLong)];
#endif
    
    MKCoordinateRegion region;
	region.center = lastPosition;
	region.span.latitudeDelta = kLatitudeDelta;
	region.span.longitudeDelta = kLatitudeDelta;
	[mapView setRegion:region animated:NO];
    
    BOOL isSpotted = false;
    for (Camera *camera in cameras) {
        if (camera.isHacked) {
            continue;
        }
        camera.isSpotting = [camera seesPoint:lastPosition];
        if (camera.isSpotting) {
            isSpotted = YES;
            spottingCamera = camera;
        }
    }
    
    if (isSpotted) {
        [self moveVolumeForPlay:spottedLoopSoundPlayer Toward:1.0];
        [self moveVolumeForPlay:appGameLoopSoundPlayer Toward:0.0];
    } else {
        [self moveVolumeForPlay:appGameLoopSoundPlayer Toward:1.0];
        [self moveVolumeForPlay:spottedLoopSoundPlayer Toward:0.0];
    }
    
    if (isSpotted) {
        self.vignette.image = [UIImage imageNamed:@"vignette_rouge"];
        self.hackSwitch.hidden = NO;
    } else {
        self.vignette.image = [UIImage imageNamed:@"vignette"];
        self.hackSwitch.hidden = YES;
    }
    
    id<MKOverlay> theOverlay = [[mapView overlays] objectAtIndex:0];
    CameraOverlayView *theOverlayView = (CameraOverlayView *)[mapView viewForOverlay:theOverlay];
    [theOverlayView setNeedsDisplayInMapRect:MKMapRectWorld];

}

- (void)createCameras
{
    CLLocationDistance cameraRadius = 35.0;

    NSString *path = [[NSBundle mainBundle] pathForResource:@"cameras" ofType:@"kml"];
    KMLParser *kml = [KMLParser parseKMLAtPath:path];

    NSArray *annotations = [kml points];

    for (id<MKAnnotation> point in annotations) {
        CLLocationCoordinate2D cameraPosition = [point coordinate];
        if (cameraPosition.latitude < 40) continue;
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
    [self playerMovedTo: newLocation.coordinate];
}

- (void)playerMovedTo:(CLLocationCoordinate2D)coordinate
{
    lastPosition = coordinate;
}

- (void)moveVolumeForPlay:(AVAudioPlayer*)player Toward:(float)volume
{
    float actualVolume = [player volume];
    [player setVolume:(9*actualVolume + volume)/10];
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

- (AVAudioPlayer*)makeAudioPlayer:(NSString*)path ofType:(NSString*)type withVolume:(float) volume
{
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource: path ofType: type];
    NSURL *soundFileURL = [[[NSURL alloc] initFileURLWithPath: soundFilePath] autorelease];
	AVAudioPlayer *audioPLayer = [[[AVAudioPlayer alloc] initWithContentsOfURL: soundFileURL error: nil] autorelease];
    [audioPLayer setVolume: volume];
    [audioPLayer setNumberOfLoops: -1];
    [audioPLayer play];
    return audioPLayer;
}

- (IBAction)startHack
{
    MPMoviePlayerController *moviePlayer = self.moviePlayerController.moviePlayer;
    
    moviePlayer.controlStyle = MPMovieControlStyleNone;

    [self presentMoviePlayerViewControllerAnimated:self.moviePlayerController];
    
    spottingCamera.isHacked = YES;
}

@end
