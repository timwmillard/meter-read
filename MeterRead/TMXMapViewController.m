//
//  TMXMapViewController.m
//  MeterRead
//
//  Created by Tim Millard on 7/06/13.
//  Copyright (c) 2013 Timix Technology. All rights reserved.
//

#import "TMXMapViewController.h"

@interface TMXMapViewController ()

@end

@implementation TMXMapViewController

@synthesize servicePoint = _servicePoint;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.mapView.delegate = self;
    
    self.title = self.servicePoint.name;
    
    [self loadLocation];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self loadLocation];
}

- (void)loadLocation
{
    if (self.servicePoint.latitude && self.servicePoint.longitude) {
        
        
        CLLocationCoordinate2D location;
        location.latitude = self.servicePoint.latitude.doubleValue;
        location.longitude = self.servicePoint.longitude.doubleValue;
        
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location, 8000, 8000);
        [self.mapView setRegion:region animated:YES];
        
        // Add an annotation
        MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
        point.coordinate = location;
        point.title = self.servicePoint.name;
        point.subtitle = self.servicePoint.type;
        
        [self.mapView addAnnotation:point];
        
        [self.mapView selectAnnotation:point animated:NO];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
