//
//  MKMapView+Snapshot.h
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 09/02/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MKMapView (Snapshot)

- (void)createSnapshotWithSize:(CGSize)size completionHandler:(void (^)(UIImage *snapshot))completionHandler;

@end
