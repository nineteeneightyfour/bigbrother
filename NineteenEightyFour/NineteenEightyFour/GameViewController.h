#import "Camera.h"

@interface GameViewController : UIViewController<CLLocationManagerDelegate, MKMapViewDelegate> {
    CLLocationManager *locationManager;
    CLLocationCoordinate2D lastPosition;
    NSTimer* timer;
    NSMutableArray *cameras;
}

@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain)	AVAudioPlayer			*appGameLoopSoundPlayer;
@property (nonatomic, retain)	AVAudioPlayer			*spottedLoopSoundPlayer;

- (void)createCameras;
- (void)playerMovedTo:(CLLocationCoordinate2D)coordinate;
- (void)tick;
- (void)addCameraWithPosition:(CLLocationCoordinate2D)cameraPosition andRadius:(CLLocationDistance)cameraRadius;

- (AVAudioPlayer*)makeAudioPlayer:(NSString*)path ofType:(NSString*)type withVolume:(float) volume;


@end
