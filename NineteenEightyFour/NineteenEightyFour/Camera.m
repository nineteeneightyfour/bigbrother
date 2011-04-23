#import "Camera.h"


@implementation Camera

@synthesize position;
@synthesize radius;


+ (Camera *)cameraWithPosition:(CLLocationCoordinate2D)cameraPosition andRadius:(CLLocationDistance)cameraRadius
{
    return [[[Camera alloc] initWithPosition:cameraPosition andRadius:cameraRadius] autorelease];
}

- (Camera *)initWithPosition:(CLLocationCoordinate2D)cameraPosition andRadius:(CLLocationDistance)cameraRadius
{
    self = [super init];
    if (self) {
        self.position = cameraPosition;
        self.radius = cameraRadius;
    }
    return self;
    
}

- (BOOL)seesPoint:(CLLocationCoordinate2D)point
{
    CLLocation *pointLocation = [[CLLocation alloc] initWithLatitude:point.latitude longitude:point.longitude];

    CLLocation *positionLocation = [[CLLocation alloc] initWithLatitude:position.latitude longitude:position.longitude];

    CLLocationDistance distance = [positionLocation distanceFromLocation:pointLocation];
    
    return distance < radius;
}

@end
