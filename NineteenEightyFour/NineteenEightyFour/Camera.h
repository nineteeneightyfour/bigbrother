
@interface Camera : NSObject {
    
}
@property (nonatomic, retain) CLLocation* position;
@property (nonatomic) CLLocationDistance radius;

+ (Camera *)cameraWithPosition:(CLLocationCoordinate2D)cameraPosition andRadius:(CLLocationDistance)cameraRadius;

- (Camera *)initWithPosition:(CLLocationCoordinate2D)cameraPosition andRadius:(CLLocationDistance)cameraRadius;

- (BOOL)seesPoint:(CLLocationCoordinate2D)point;

@end
