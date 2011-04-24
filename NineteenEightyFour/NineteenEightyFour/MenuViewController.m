#import "MenuViewController.h"
#import "GameViewController.h"

@implementation MenuViewController

@synthesize appSoundPlayer;

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

    [self presentModalViewController:gameController animated:YES];
    
    [appSoundPlayer release], appSoundPlayer = nil;
    [self playSound:@"son_game" ofType:@"wav"];
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self playSound:@"intro" ofType:@"wav"];
}

- (void)playSound:(NSString*)path ofType:(NSString*)type
{
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource: path ofType: type];
    NSURL *soundFileURL = [[[NSURL alloc] initFileURLWithPath: soundFilePath] autorelease];
	self.appSoundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL: soundFileURL error: nil];;
    [self.appSoundPlayer release];
    [appSoundPlayer setVolume: 1.0];
    [appSoundPlayer setNumberOfLoops: -1];
    [appSoundPlayer play];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
