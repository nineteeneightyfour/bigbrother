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
        self.position = [[CLLocation alloc] initWithLatitude:cameraPosition.latitude longitude:cameraPosition.longitude];
        self.radius = cameraRadius;
    }
    return self;
    
}

- (BOOL)seesPoint:(CLLocationCoordinate2D)point
{
    CLLocation *pointLocation = [[CLLocation alloc] initWithLatitude:point.latitude longitude:point.longitude];

    CLLocationDistance distance = [position distanceFromLocation:pointLocation];
    
    return distance < radius;
}

@end
