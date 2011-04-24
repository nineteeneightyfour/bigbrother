#import "CameraOverlayView.h"
#import "CameraOverlay.h"
#import "Camera.h"

@implementation CameraOverlayView

- (id)initWithOverlay:(id <MKOverlay>)overlay
{
    self = [super initWithOverlay:overlay];
    if (self) {
        oeil = [[UIImage imageNamed:@"oeil"] retain];
    }
    return self;
}

- (void)dealloc
{
    [oeil release], oeil = nil;
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
        MKMapRect cameraMapRect = MKMapRectMake(mapCentre.x - mapRadius, mapCentre.y - mapRadius, 2 * mapRadius, 2 * mapRadius);
        
        if(! MKMapRectIntersectsRect(mapRect, cameraMapRect)) {
            continue;
        }
        
        CGRect cameraCGRect = [self rectForMapRect:cameraMapRect];

        if (camera.isActive) {
            CGContextSetRGBFillColor(context, 1,0,0,0.6);
        } else {
            CGContextSetRGBFillColor(context, 1,1,1,0.6);
        }
        CGContextFillEllipseInRect(context, cameraCGRect);
        
        CGPoint oeilPoint = [self pointForMapPoint:mapCentre];
        CGSize oeilSize = oeil.size;
        CGRect oeilRect = CGRectMake(oeilPoint.x - oeilSize.width, oeilPoint.y - oeilSize.height, oeilSize.width * 2, oeilSize.height * 2);
        CGContextDrawImage(context, oeilRect, oeil.CGImage);
    }
}

@end
