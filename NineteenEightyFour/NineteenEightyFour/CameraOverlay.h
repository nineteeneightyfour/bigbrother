@interface CameraOverlay : NSObject <MKOverlay> {
}

@property (nonatomic, retain) NSArray *cameras;

- (id)initWithCameras:(NSArray*)cameras;

@end
