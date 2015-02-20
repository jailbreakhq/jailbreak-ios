//
//  MKMapView+Snapshot.m
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 09/02/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import <SDImageCache.h>
#import "MKMapView+Snapshot.h"

@implementation MKMapView (Snapshot)

- (void)createSnapshotWithSize:(CGSize)size completionHandler:(void (^)(UIImage *))completionHandler
{
    MKMapSnapshotOptions *options = [[MKMapSnapshotOptions alloc] init];
    options.region = self.region;
    options.scale = [UIScreen mainScreen].scale;
    options.size = size;
    
    // https://github.com/Wave39/BPMapSnapshotter/blob/master/BPMapSnapshotter.m
    NSString *key = [NSString stringWithFormat:@"%f %f %f %f %f | %@ | %f %f %f %f | %@ %f | %d",
                     options.camera.centerCoordinate.latitude, options.camera.centerCoordinate.longitude,
                     options.camera.heading, options.camera.pitch, options.camera.altitude,
                     MKStringFromMapRect(options.mapRect),
                     options.region.center.latitude, options.region.center.longitude,
                     options.region.span.latitudeDelta, options.region.span.longitudeDelta,
                     NSStringFromCGSize(options.size), options.scale, (int)options.mapType];
    
    UIImage *snapshotImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:key];
    if (snapshotImage)
    {
        completionHandler(snapshotImage);
    }
    else
    {
        MKMapSnapshotter *snapshotter = [[MKMapSnapshotter alloc] initWithOptions:options];
        [snapshotter startWithCompletionHandler:^(MKMapSnapshot *snapshot, NSError *error) {
            if (!error)
            {
                [[SDImageCache sharedImageCache] storeImage:snapshot.image forKey:key];
                completionHandler(snapshot.image);
            }
        }];
    }
}

@end
