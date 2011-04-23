#import "Camera.h"


@implementation Camera

+ (Camera *)cameraWithPosition:(CLLocationCoordinate2D)cameraPosition andRadius:(CLLocationDistance)cameraRadius
{
    return [[[Camera alloc] init] autorelease];
}

- (BOOL)seesPoint:(CLLocationCoordinate2D)point
{
    return YES;
}

@end
