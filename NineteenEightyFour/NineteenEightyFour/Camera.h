
@interface Camera : NSObject {
    
}

+ (Camera *)cameraWithPosition:(CLLocationCoordinate2D)cameraPosition andRadius:(CLLocationDistance)cameraRadius;

- (BOOL)seesPoint:(CLLocationCoordinate2D)point;

@end
