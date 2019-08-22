//
//  TMXServicePointAnnotation.m
//  MeterRead
//
//  Created by Tim Millard on 12/06/13.
//  Copyright (c) 2013 Timix Technology. All rights reserved.
//

#import "TMXServicePointAnnotation.h"

@implementation TMXServicePointAnnotation

- (CLLocationCoordinate2D)coordinate;
{
    CLLocationCoordinate2D location;
    location.latitude = self.servicePoint.latitude.doubleValue;
    location.longitude = self.servicePoint.longitude.doubleValue;
    return location;
}

// required if you set the MKPinAnnotationView's "canShowCallout" property to YES
- (NSString *)title
{
    return self.servicePoint.name;
}

// optional
- (NSString *)subtitle
{
    return self.servicePoint.type;
}

@end
