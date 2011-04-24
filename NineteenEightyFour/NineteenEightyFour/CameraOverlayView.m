#import "CameraOverlayView.h"
#import "CameraOverlay.h"
#import "Camera.h"

@implementation CameraOverlayView

- (id)initWithOverlay:(id <MKOverlay>)overlay
{
    self = [super initWithOverlay:overlay];
    if (self) {
        oeil = [[UIImage imageNamed:@"oeil"] retain];
        oeil_out = [[UIImage imageNamed:@"oeil_out"] retain];
        player = [[UIImage imageNamed:@"player"] retain];
    }
    return self;
}

- (void)dealloc
{
    [oeil release], oeil = nil;
    [oeil_out release], oeil_out = nil;
    [player release], player = nil;
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

        if (camera.isHacked) {
            CGContextSetRGBFillColor(context, 0,1,0,0.3);
        } else if (camera.isSpotting) {
            CGContextSetRGBFillColor(context, 1,0,0,0.6);
        } else {
            CGContextSetRGBFillColor(context, 1,1,1,0.6);
        }
        CGContextFillEllipseInRect(context, cameraCGRect);
        
        CGPoint oeilPoint = [self pointForMapPoint:mapCentre];
        UIImage *oeilImage = camera.isHacked?oeil_out:oeil;
        CGSize oeilSize = oeilImage.size;
        CGRect oeilRect = CGRectMake(oeilPoint.x - oeilSize.width, oeilPoint.y - oeilSize.height,
                                     oeilSize.width * 2, oeilSize.height * 2);
        CGContextDrawImage(context, oeilRect, oeilImage.CGImage);
    }
    
    // dessine le joueur
    MKMapPoint playerCentre = MKMapPointForCoordinate(cameraOverlay.playerPosition);
    CGPoint playerPoint = [self pointForMapPoint:playerCentre];

    CGSize playerSize = player.size;
    CGRect playerRect = CGRectMake(playerPoint.x - playerSize.width, playerPoint.y - playerSize.height, playerSize.width * 2, playerSize.height * 2);
CGContextDrawImage(context, playerRect, player.CGImage);

}

@end
