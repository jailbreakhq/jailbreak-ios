//
//  MKMapView+Snapshot.m
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 09/02/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import "MKMapView+Snapshot.h"

@implementation MKMapView (Snapshot)

- (void)createSnapshotWithSize:(CGSize)size completionHandler:(void (^)(UIImage *))completionHandler
{
    MKMapSnapshotOptions *options = [[MKMapSnapshotOptions alloc] init];
    options.region = self.region;
    options.scale = [UIScreen mainScreen].scale;
    options.size = size;
    
    MKMapSnapshotter *snapshotter = [[MKMapSnapshotter alloc] initWithOptions:options];
    [snapshotter startWithCompletionHandler:^(MKMapSnapshot *snapshot, NSError *error) {
        completionHandler(snapshot.image);
    }];
}

@end
