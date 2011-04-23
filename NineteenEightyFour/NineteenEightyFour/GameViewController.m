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
@synthesize camera;

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

#if !TARGET_IPHONE_SIMULATOR
    // CLLocationManager permet la gestion de la position géographique de l'utilisateur
	locationManager=[[CLLocationManager alloc] init];
	[locationManager setDelegate:self];
	[locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
	[locationManager startUpdatingLocation];
#endif
    
    [self createCamera];

#if TARGET_IPHONE_SIMULATOR
    [self playerMovedTo:CLLocationCoordinate2DMake(48.870462, 2.342624)];
#endif

}

- (void)createCamera
{
    CLLocationCoordinate2D cameraPosition = CLLocationCoordinate2DMake(48.870562, 2.342624);
    CLLocationDistance cameraRadius = 30.0;
    self.camera = [Camera cameraWithPosition:cameraPosition andRadius:cameraRadius];
    
    MKCircle *circle = [MKCircle circleWithCenterCoordinate:self.camera.position.coordinate radius:self.camera.radius];
    [mapView addOverlay:circle];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    CLLocationCoordinate2D coordinate = newLocation.coordinate;
    [self playerMovedTo:coordinate];
}

- (void)playerMovedTo:(CLLocationCoordinate2D)coordinate
{
    MKCoordinateRegion region;
	region.center = coordinate;
	region.span.latitudeDelta = .001;
	region.span.longitudeDelta = .001;
	[mapView setRegion:region animated:TRUE];
    
    lastPosition = coordinate;
    id<MKOverlay> theOverlay = [[mapView overlays] objectAtIndex:0];
    MKCircleView *theOverlayView = (MKCircleView *)[mapView viewForOverlay:theOverlay];
    if ([camera seesPoint:lastPosition]) {
        theOverlayView.fillColor = [UIColor colorWithRed:1.0 green:0.0 blue:0 alpha:0.2];
    } else {
        theOverlayView.fillColor = [UIColor clearColor];
    }
    [theOverlayView setNeedsDisplay];

}
- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay
{
    MKCircleView *circleView = [[[MKCircleView alloc ] initWithCircle:overlay] autorelease];
    circleView.strokeColor = [UIColor redColor];
    circleView.lineWidth = 3.0;
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
