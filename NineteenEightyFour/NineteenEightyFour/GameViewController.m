//
//  GameViewController.m
//  NineteenEightyFour
//
//  Created by Stéphane Hanser on 23/04/11.
//  Copyright 2011 Jonathan Perret. All rights reserved.
//

#import "GameViewController.h"


@implementation GameViewController

@synthesize mapView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
    // go to North America
    MKCoordinateRegion newRegion;
    newRegion.center.latitude = 37.37;
    newRegion.center.longitude = -96.24;
    newRegion.span.latitudeDelta = 28.49;
    newRegion.span.longitudeDelta = 31.025;
    
    [self.mapView setRegion:newRegion animated:NO];
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
