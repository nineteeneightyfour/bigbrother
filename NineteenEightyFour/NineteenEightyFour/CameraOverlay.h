@interface CameraOverlay : NSObject <MKOverlay> {
}

@property (nonatomic, retain) NSArray *cameras;
@property (nonatomic) CLLocationCoordinate2D playerPosition;


- (id)initWithCameras:(NSArray*)cameras;

@end
