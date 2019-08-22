//
//  TMXMapViewController.h
//  MeterRead
//
//  Created by Tim Millard on 7/06/13.
//  Copyright (c) 2013 Timix Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#import "ServicePoint.h"

@interface TMXMapViewController : UIViewController <MKMapViewDelegate>

@property (nonatomic, strong) IBOutlet MKMapView *mapView;

@property (strong, nonatomic) ServicePoint *servicePoint;

@end
