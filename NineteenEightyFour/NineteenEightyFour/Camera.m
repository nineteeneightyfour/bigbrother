#import "Camera.h"


@implementation Camera

@synthesize position;


+ (Camera *)cameraWithPosition:(CLLocationCoordinate2D)cameraPosition andRadius:(CLLocationDistance)cameraRadius
{
    return [[[Camera alloc] initWithPosition:cameraPosition andRadius:cameraRadius] autorelease];
}

- (Camera *)initWithPosition:(CLLocationCoordinate2D)cameraPosition andRadius:(CLLocationDistance)cameraRadius
{
    self = [super init];
    if (self) {
        self.position = cameraPosition;
    }
    return self;
    
}

- (BOOL)seesPoint:(CLLocationCoordinate2D)point
{
    return point.latitude == position.latitude && point.longitude == position.longitude;
}

@end
