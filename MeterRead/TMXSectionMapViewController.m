//
//  TMXSectionMapViewController.m
//  MeterRead
//
//  Created by Tim Millard on 11/06/13.
//  Copyright (c) 2013 Timix Technology. All rights reserved.
//

#import "TMXSectionMapViewController.h"
#import "TMXDetailsViewController.h"

#import "TMXAppDelegate.h"

typedef enum {
    TMXZoomFullExtent,
    TMXZoomCurrentLocation
} TMXZoomType;

@interface TMXSectionMapViewController ()

@end

@implementation TMXSectionMapViewController
{
     MKCoordinateRegion _fullExtentRegion;
    TMXZoomType _zoomState;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.mapView.delegate = self;
    
    [self loadLocations];
    
    [self zoomFullExtent];
}

- (void)viewWillAppear:(BOOL)animated
{
    // Perform Refresh each time viewAppears.
    // This could be optimised.
    //[self.mapView removeAnnotations:self.mapView.annotations];
    //[self loadLocations];

    
    [super viewWillAppear:animated];
}

- (void)loadLocations
{
    double minLatitude = 360;
    double maxLatitude = -360;
    double minLongitude = 360;
    double maxLongitude = -360;
    double spanLatitude = 0;
    double spanLongitude = 0;

    for (ServicePoint *servicePoint in self.fetchedResultsController.fetchedObjects) {
        if (servicePoint.validLocation) {
            CLLocationCoordinate2D location;
            location.latitude = servicePoint.latitude.doubleValue;
            location.longitude = servicePoint.longitude.doubleValue;
            
            // Add an annotation
            TMXServicePointAnnotation *point = [[TMXServicePointAnnotation alloc] init];
            point.servicePoint = servicePoint;
            
            [self.mapView addAnnotation:point];
            
            // Min Max Latitude
            if (location.latitude<minLatitude)
                minLatitude = location.latitude;
            if (location.latitude>maxLatitude)
                maxLatitude = location.latitude;
            // Min Max Longitude
            if (location.longitude<minLongitude)
                minLongitude = location.longitude;
            if (location.longitude>maxLongitude)
                maxLongitude = location.longitude;
        }
    }
    
    spanLatitude = maxLatitude - minLatitude;
    spanLongitude = maxLongitude - minLongitude;
    
    if (spanLatitude<0)
        spanLatitude = 0;
    if (spanLongitude<0)
        spanLongitude = 0;
    
    CLLocationCoordinate2D center;
    center.latitude = minLatitude + spanLatitude / 2;
    center.longitude = minLongitude + spanLongitude / 2;
    
    MKCoordinateSpan span;
    span.latitudeDelta = spanLatitude * 1.3;
    span.longitudeDelta = spanLongitude * 1.3;
    
    // check for sane span values
    if (span.latitudeDelta <= 0.0f || span.longitudeDelta <= 0.0f) {
        span.latitudeDelta = 1.0f;
        span.longitudeDelta = 1.0f;
    }
    // check for sane center values
    if (center.latitude > 90.0f || center.latitude < -90.0f ||
        center.longitude > 360.0f || center.longitude < -180.0f
        ) {
        // Take me to Tokyo.
        center.latitude = 35.4f;
        center.longitude = 139.4f;
    }
    
    //MKCoordinateRegion region;
    //region.center = center;
    //region.span = span;
    //[self.mapView setRegion:region animated:YES];
    
    _fullExtentRegion.center = center;
    _fullExtentRegion.span = span;

}

- (void)zoomFullExtent
{
    [self.mapView setRegion:_fullExtentRegion animated:YES];
}

-(void)zoomCurrentLocation
{
    CLLocationManager *lm = [[CLLocationManager alloc] init];
    //lm.delegate = self;
    lm.desiredAccuracy = kCLLocationAccuracyBest;
    lm.distanceFilter = kCLDistanceFilterNone;
    [lm startUpdatingLocation];
    
    CLLocation *location = [lm location];
    
    CLLocationCoordinate2D coord;
    coord = [location coordinate];
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coord, 400, 400);
    [self.mapView setRegion:region animated:YES];

    [self.mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
     
}

- (IBAction)changeZoomState:(id)sender
{
    if (_zoomState == TMXZoomFullExtent) {
        _zoomState = TMXZoomCurrentLocation;
        [self zoomCurrentLocation];
    } else {
        _zoomState = TMXZoomFullExtent;
        [self zoomFullExtent];
    }
}

- (IBAction)zoomToCurrentLocation:(id)sender
{
    [self zoomCurrentLocation];
}

- (IBAction)zoomToSectionOverview:(id)sender
{
    [self zoomFullExtent];
}

- (IBAction)segmentSwitch:(id)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;
    
    if (selectedSegment == 0) {
        self.mapView.mapType = MKMapTypeStandard;
    } else if (selectedSegment == 1) {
        self.mapView.mapType = MKMapTypeHybrid;
    } else {
        self.mapView.mapType = MKMapTypeSatellite;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    if ([self isViewLoaded] && [self.view window] == nil) {
        self.view = nil;
        self.mapView = nil;
        self.fetchedResultsController = nil;
        //  self.subView = nil;
        //  self.subViewFromNib = nil;
    }
    //self.someDataCanBeRecreatedEasily = nil;
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetailsFromMap"]) {
        TMXDetailsViewController *controller = [segue destinationViewController];
        controller.servicePoint = self.servicePoint;
    }
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    
    TMXServicePointAnnotation *annotation = [view annotation];
    
    self.servicePoint = annotation.servicePoint;
    
    [self performSegueWithIdentifier:@"showDetailsFromMap" sender:self];
    //[self.navigationController pushViewController:self.detailViewController animated:YES];
}

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    // in case it's the user location, we already have an annotation, so just return nil
    if ([annotation isKindOfClass:[MKUserLocation class]])
    {
        return nil;
    }
    
    static NSString *servicePointAnnotationIdentifier = @"servicePointAnnotationIdentifier";
    
    // if an existing pin view was not available, create one
    MKPinAnnotationView *customPinView = [[MKPinAnnotationView alloc]
                                          initWithAnnotation:annotation reuseIdentifier:servicePointAnnotationIdentifier];
    customPinView.animatesDrop = YES;
    customPinView.canShowCallout = YES;
    
    TMXServicePointAnnotation *spAnnotation = annotation;
    ServicePoint *servicePoint = spAnnotation.servicePoint;
    
    if (servicePoint.meterReadingIsCompleted)
        customPinView.pinColor = MKPinAnnotationColorGreen;
    else //if (servicePoint.meterReading.reading)
        customPinView.pinColor = MKPinAnnotationColorRed;
    //else
      //  customPinView.pinColor = MKPinAnnotationColorPurple;
    
    // add a detail disclosure button to the callout which will open a new view controller page
    //
    // note: when the detail disclosure button is tapped, we respond to it via:
    //       calloutAccessoryControlTapped delegate method
    //
    // by using "calloutAccessoryControlTapped", it's a convenient way to find out which annotation was tapped
    //
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [rightButton addTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
    customPinView.rightCalloutAccessoryView = rightButton;
    
    //UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    //[leftButton addTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
    //customPinView.leftCalloutAccessoryView = leftButton;
    
    return customPinView;
}

#pragma mark - Fetched results controllers

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    TMXAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ServicePoint" inManagedObjectContext:delegate.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *channelSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"channelName" ascending:YES];
    NSSortDescriptor *nameSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = @[channelSortDescriptor, nameSortDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSDate *lastImport = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastImport"];
    NSPredicate *predicate;
    if (lastImport) {
        predicate = [NSPredicate predicateWithFormat:@"(isMetered == YES) AND (lastImport >= %@)", lastImport];
    } else {
        predicate = [NSPredicate predicateWithFormat:@"(isMetered == YES)"];
    }
    
    [fetchRequest setPredicate:predicate];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:delegate.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    //abort();
	}
    
    return _fetchedResultsController;
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [self fetchedResultsChangeInsert:anObject];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self fetchedResultsChangeDelete:anObject];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self fetchedResultsChangeUpdate:anObject];
            break;
            
        case NSFetchedResultsChangeMove:
            //We do nothing here since we are not concerned with the index an object is at
            break;
    }
}

- (void)fetchedResultsChangeInsert:(NSObject*)anObject
{
    ServicePoint *servicePoint = (ServicePoint*)anObject;
    
    if (servicePoint.validLocation) {
    
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = servicePoint.latitude.doubleValue;
        coordinate.longitude = servicePoint.longitude.doubleValue;
    
        // Add an annotation
        TMXServicePointAnnotation *point = [[TMXServicePointAnnotation alloc] init];
        point.servicePoint = servicePoint;
    
        [self.mapView addAnnotation:point];
    }

}

- (void)fetchedResultsChangeDelete:(NSObject*)anObject
{
    ServicePoint *servicePoint = (ServicePoint*)anObject;
    
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = servicePoint.latitude.doubleValue;
    coordinate.longitude = servicePoint.longitude.doubleValue;
    
    //In case we have more then one match for whatever reason
    NSMutableArray *toRemove = [NSMutableArray arrayWithCapacity:1];
    for (id annotation in self.mapView.annotations) {
        
        if (annotation != self.mapView.userLocation) {
            TMXServicePointAnnotation *pinAnnotation = annotation;
            
            if (pinAnnotation.servicePoint == servicePoint) {
                [toRemove addObject:annotation];
            }
        }
    }
    [self.mapView removeAnnotations:toRemove];
}

- (void)fetchedResultsChangeUpdate:(NSObject*)anObject
{
    //Takes a little bit of overheard but it is simple
    [self fetchedResultsChangeDelete:anObject];
    
    ServicePoint *servicePoint = (ServicePoint*)anObject;
    
    if (servicePoint.validLocation) {
        
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = servicePoint.latitude.doubleValue;
        coordinate.longitude = servicePoint.longitude.doubleValue;
        
        // Add an annotation
        TMXServicePointAnnotation *point = [[TMXServicePointAnnotation alloc] init];
        point.servicePoint = servicePoint;
        
        [self.mapView addAnnotation:point];

    
        [self.mapView selectAnnotation:point animated:true];
    }
}

+ (CGFloat)annotationPadding;
{
    return 10.0f;
}

+ (CGFloat)calloutHeight;
{
    return 40.0f;
}

@end
