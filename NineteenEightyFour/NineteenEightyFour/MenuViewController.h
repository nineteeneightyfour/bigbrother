
@interface MenuViewController : UIViewController {
}

@property (nonatomic, retain) IBOutlet UIView *movieHolder;
@property (nonatomic, retain)	MPMoviePlayerController *moviePlayer;

- (IBAction)startGame;

@end
