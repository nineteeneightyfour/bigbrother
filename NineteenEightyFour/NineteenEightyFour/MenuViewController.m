#import "MenuViewController.h"
#import "GameViewController.h"
#import <AVFoundation/AVFoundation.h>

@implementation MenuViewController

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
    
/*    UIWindow *window = [self.view window];
    
    window.rootViewController = gameController;*/
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
    NSLog(@"isPrepareOK");
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource: @"intro" ofType: @"wav"];
    NSURL *soundFileURL = [[[NSURL alloc] initFileURLWithPath: soundFilePath] autorelease];
    AVAudioPlayer *appSoundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL: soundFileURL error: nil];
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
