//
//  TMXServicePointAnnotation.h
//  MeterRead
//
//  Created by Tim Millard on 12/06/13.
//  Copyright (c) 2013 Timix Technology. All rights reserved.
//

#import <MapKit/MapKit.h>

#import "ServicePoint.h"

@interface TMXServicePointAnnotation : NSObject <MKAnnotation>

@property (strong, nonatomic) ServicePoint *servicePoint;

@end
