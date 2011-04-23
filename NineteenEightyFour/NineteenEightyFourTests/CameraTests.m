#import "Camera.h"

@interface CameraTests : SenTestCase {
    
}
@end

@implementation CameraTests

- (void)testACameraCanTellWhetherItSeesAPoint {
    CLLocationCoordinate2D cameraPosition = CLLocationCoordinate2DMake(48.870562, 2.342624);
    CLLocationDistance cameraRadius = 30.0;
    Camera *camera = [Camera cameraWithPosition:cameraPosition andRadius:cameraRadius];
    
    STAssertTrue([camera seesPoint:cameraPosition], nil);
}

@end
