#import "Camera.h"

@interface GameViewController : UIViewController<CLLocationManagerDelegate, MKMapViewDelegate> {
    CLLocationManager *locationManager;
    CLLocationCoordinate2D lastPosition;
    NSTimer* timer;
}

@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) Camera *camera;

- (void)createCamera;
- (void)playerMovedTo:(CLLocationCoordinate2D)coordinate;
- (void)tick;

@end
