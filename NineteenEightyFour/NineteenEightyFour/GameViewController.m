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

    // CLLocationManager permet la gestion de la position géographique de l'utilisateur
	locationManager=[[CLLocationManager alloc] init];
	[locationManager setDelegate:self];
	[locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
	[locationManager startUpdatingLocation];
    
    [self createCamera];
}

- (void)createCamera
{
    CLLocationCoordinate2D cameraPosition = CLLocationCoordinate2DMake(48.870844, 2.341831);
    CLLocationDistance cameraRadius = 50.0;
    MKCircle *circle = [MKCircle circleWithCenterCoordinate:cameraPosition radius:cameraRadius];
    [mapView addOverlay:circle];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
	MKCoordinateRegion region;
	region.center = newLocation.coordinate;
	region.span.latitudeDelta = .001;
	region.span.longitudeDelta = .001;
	[mapView setRegion:region animated:TRUE];
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay
{
    MKCircleView *circleView = [[[MKCircleView alloc ] initWithCircle:overlay] autorelease];
    circleView.strokeColor = [UIColor redColor];
    circleView.lineWidth = 3.0;
    circleView.fillColor = [UIColor colorWithRed:1.0 green:0 blue:0 alpha:0.2];
    return circleView;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [locationManager release], locationManager = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
