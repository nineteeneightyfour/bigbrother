
@interface Camera : NSObject {
    
}
@property (nonatomic) CLLocationCoordinate2D position;
@property (nonatomic) CLLocationDistance radius;

+ (Camera *)cameraWithPosition:(CLLocationCoordinate2D)cameraPosition andRadius:(CLLocationDistance)cameraRadius;

- (Camera *)initWithPosition:(CLLocationCoordinate2D)cameraPosition andRadius:(CLLocationDistance)cameraRadius;

- (BOOL)seesPoint:(CLLocationCoordinate2D)point;

@end
