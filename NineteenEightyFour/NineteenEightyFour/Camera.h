
@interface Camera : NSObject {
    
}
@property (nonatomic, retain) CLLocation* position;
@property (nonatomic) CLLocationDistance radius;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic) BOOL isSpotting;

+ (Camera *)cameraWithPosition:(CLLocationCoordinate2D)cameraPosition andRadius:(CLLocationDistance)cameraRadius;

- (Camera *)initWithPosition:(CLLocationCoordinate2D)cameraPosition andRadius:(CLLocationDistance)cameraRadius;

- (BOOL)seesPoint:(CLLocationCoordinate2D)point;

@end
