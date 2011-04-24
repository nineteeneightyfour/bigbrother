#import "Camera.h"

@interface GameViewController : UIViewController<CLLocationManagerDelegate, MKMapViewDelegate> {
    CLLocationManager *locationManager;
    CLLocationCoordinate2D lastPosition;
    NSTimer* timer;
    NSMutableArray *cameras;
    Camera *spottingCamera;
}

@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) IBOutlet UIImageView *vignette;
@property (nonatomic, retain) IBOutlet UIView *hackSwitch;
@property (nonatomic, retain)	AVAudioPlayer			*appGameLoopSoundPlayer;
@property (nonatomic, retain)	AVAudioPlayer			*spottedLoopSoundPlayer;
@property (nonatomic, retain)	MPMoviePlayerViewController *moviePlayerController;

- (void)createCameras;
- (void)playerMovedTo:(CLLocationCoordinate2D)coordinate;
- (void)tick;
- (void)addCameraWithPosition:(CLLocationCoordinate2D)cameraPosition andRadius:(CLLocationDistance)cameraRadius;

- (AVAudioPlayer*)makeAudioPlayer:(NSString*)path ofType:(NSString*)type withVolume:(float) volume;
- (void)moveVolumeForPlay:(AVAudioPlayer*)player Toward:(float)volume;

- (IBAction)startHack;

@end
