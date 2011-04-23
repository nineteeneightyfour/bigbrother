#import "CameraOverlay.h"

@implementation CameraOverlay

@synthesize cameras;

- (id)initWithCameras:(NSArray*)cameras_
{
    self = [super init];
    if (self) {
        self.cameras = cameras_;
    }
    return self;
}

- (void)dealloc {
    self.cameras = nil;
    [super dealloc];
}

- (MKMapRect)boundingMapRect
{
    return MKMapRectWorld;
}

- (CLLocationCoordinate2D)coordinate
{
    return CLLocationCoordinate2DMake(0, 0);
}

@end
