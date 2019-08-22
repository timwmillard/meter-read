//
//  TMXSectionMapViewController.h
//  MeterRead
//
//  Created by Tim Millard on 11/06/13.
//  Copyright (c) 2013 Timix Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#import "TMXServicePointAnnotation.h"
#import "ServicePoint.h"

@interface TMXSectionMapViewController : UIViewController <MKMapViewDelegate,
                                                           NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *mapTypeSegmentControl;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@property (strong, nonatomic) ServicePoint *servicePoint;

- (IBAction)changeZoomState:(id)sender;
- (IBAction)zoomToCurrentLocation:(id)sender;
- (IBAction)zoomToSectionOverview:(id)sender;

@end
