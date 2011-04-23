#import "Camera.h"

@interface GameViewController : UIViewController<CLLocationManagerDelegate, MKMapViewDelegate> {
    CLLocationManager *locationManager;
    CLLocationCoordinate2D lastPosition;
    NSTimer* timer;
    NSMutableArray *cameras;
}

@property (nonatomic, retain) IBOutlet MKMapView *mapView;

- (void)createCameras;
- (void)playerMovedTo:(CLLocationCoordinate2D)coordinate;
- (void)tick;
- (void)addCameraWithPosition:(CLLocationCoordinate2D)cameraPosition andRadius:(CLLocationDistance)cameraRadius;

@end
