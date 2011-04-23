#import "CameraOverlayView.h"
#import "CameraOverlay.h"
#import "Camera.h"

@implementation CameraOverlayView

- (id)initWithOverlay:(id <MKOverlay>)overlay
{
    self = [super initWithOverlay:overlay];
    if (self) {
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)drawMapRect:(MKMapRect)mapRect zoomScale:(MKZoomScale)zoomScale inContext:(CGContextRef)context
{
    CameraOverlay *cameraOverlay = (CameraOverlay *)self.overlay;
    
    NSArray *cameras = cameraOverlay.cameras;
    
    CGContextClearRect(context, [self rectForMapRect:mapRect]);
    
    for (Camera *camera in cameras) {
        CLLocationCoordinate2D centre = camera.coordinate;
        
        double f = MKMapPointsPerMeterAtLatitude(centre.latitude);
        double mapRadius = f * camera.radius;
                
        MKMapPoint mapCentre = MKMapPointForCoordinate(centre);
        MKMapRect circleMapRect = MKMapRectMake(mapCentre.x - mapRadius, mapCentre.y - mapRadius, 2 * mapRadius, 2 * mapRadius);
        
        CGRect cameraCGRect = [self rectForMapRect:circleMapRect];

        if (camera.isActive) {
            CGContextSetRGBFillColor(context, 1,0,0,0.6);
        } else {
            CGContextSetRGBFillColor(context, 1,1,1,0.6);
        }
        
        CGContextFillEllipseInRect(context, cameraCGRect);
    }
}

@end
