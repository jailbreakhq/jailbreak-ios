//
//  JBMapViewController.h
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 19/02/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import "JBAnnotation.h"
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "JBCheckin+Annotation.h"

@interface JBMapViewController : UIViewController

@property (nonatomic, weak) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) NSArray *annotations;

@end
