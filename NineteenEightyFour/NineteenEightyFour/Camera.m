#import "Camera.h"


@implementation Camera

@synthesize position;
@synthesize radius;
@synthesize isSpotting;
@synthesize isHacked;

- (CLLocationCoordinate2D)coordinate
{
    return position.coordinate;
}

+ (Camera *)cameraWithPosition:(CLLocationCoordinate2D)cameraPosition andRadius:(CLLocationDistance)cameraRadius
{
    return [[[Camera alloc] initWithPosition:cameraPosition andRadius:cameraRadius] autorelease];
}

- (Camera *)initWithPosition:(CLLocationCoordinate2D)cameraPosition andRadius:(CLLocationDistance)cameraRadius
{
    self = [super init];
    if (self) {
        self.position = [[[CLLocation alloc] initWithLatitude:cameraPosition.latitude longitude:cameraPosition.longitude] autorelease];
        self.radius = cameraRadius;
        self.isSpotting = NO;
        self.isHacked = NO;
    }
    return self;
    
}

- (void)dealloc {
    self.position = nil;
    [super dealloc];
}

- (BOOL)seesPoint:(CLLocationCoordinate2D)point
{
    CLLocation *pointLocation = [[[CLLocation alloc] initWithLatitude:point.latitude longitude:point.longitude] autorelease];

    CLLocationDistance distance = [position distanceFromLocation:pointLocation];
    
    return distance < radius;
}

@end
