#import "Camera.h"

@interface CameraTests : SenTestCase {
    
}
@end

@implementation CameraTests

- (void)testTheCameraCanSeeItsPosition
{
    CLLocationCoordinate2D cameraPosition = CLLocationCoordinate2DMake(1, 2);
    CLLocationDistance cameraRadius = 0.1;
    Camera *camera = [Camera cameraWithPosition:cameraPosition andRadius:cameraRadius];
    
    STAssertTrue([camera seesPoint:cameraPosition], nil);
    
    STAssertFalse([camera seesPoint:CLLocationCoordinate2DMake(0, 0)], nil);

    STAssertFalse([camera seesPoint:CLLocationCoordinate2DMake(1, 0)], nil);
}

- (void)testTheCameraCanSeeWithinItsRadius
{
    CLLocationCoordinate2D cameraPosition = CLLocationCoordinate2DMake(1, 2);
    CLLocationDistance cameraRadius = 100000.0;
    Camera *camera = [Camera cameraWithPosition:cameraPosition andRadius:cameraRadius];
    
    CLLocationCoordinate2D pointWithinTheRadius = CLLocationCoordinate2DMake(1.00000001, 2);
    STAssertTrue([camera seesPoint:pointWithinTheRadius], nil);
    
}

@end
