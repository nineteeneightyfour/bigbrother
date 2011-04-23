#import "Camera.h"

@interface GameViewController : UIViewController<CLLocationManagerDelegate, MKMapViewDelegate> {
    CLLocationManager *locationManager;
    CLLocationCoordinate2D lastPosition;
}

@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) Camera *camera;

- (void)createCamera;

@end
