//
//  JBAnnotation.h
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 16/02/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <Foundation/Foundation.h>

@interface JBAnnotation : NSObject <MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D customCoordinate;
@property (nonatomic, strong) NSString *customTitle;
@property (nonatomic, strong) NSString *customSubtitle;

@end
