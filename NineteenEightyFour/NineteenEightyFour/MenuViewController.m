#import "MenuViewController.h"
#import "GameViewController.h"

@implementation MenuViewController

@synthesize movieHolder;
@synthesize moviePlayer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (IBAction)startGame
{
    GameViewController *gameController = [[[GameViewController alloc] initWithNibName:@"GameViewController" bundle:nil] autorelease];

    [self.moviePlayer stop];

    self.view.window.rootViewController = gameController;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSString *movpath = [[NSBundle mainBundle] pathForResource:@"intro" ofType:@"m4v"];
    
    self.moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL: [NSURL fileURLWithPath:movpath]];
    
    [self.moviePlayer.view setFrame: self.movieHolder.bounds];
    [self.movieHolder addSubview: self.moviePlayer.view];
    
    self.moviePlayer.controlStyle = MPMovieControlStyleNone;
    [self.moviePlayer prepareToPlay];
    [self.moviePlayer play];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.movieHolder = nil;
    self.moviePlayer = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
