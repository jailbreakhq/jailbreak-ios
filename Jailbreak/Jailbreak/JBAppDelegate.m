//
//  JBAppDelegate.m
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 26/01/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import <Stripe.h>
#import "JBAppDelegate.h"
#import <SDWebImage/SDImageCache.h>

NSString * const StripePublishableKey = @"pk_live_lu13pTg7V1dy0MctBEh5PBB3";

@interface JBAppDelegate ()

@end

@implementation JBAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Configure Stripe
    [Stripe setDefaultPublishableKey:StripePublishableKey];
    
    // Configure SDWebImage
    SDImageCache *sharedImageCache = [SDImageCache sharedImageCache];
    sharedImageCache.maxCacheAge = 1 * 7 * 24 * 60 * 60; // 1 week
    sharedImageCache.maxCacheSize = 200 * 1000000; // 200 MBs
    [sharedImageCache cleanDisk]; // remove all expired cached image on each launch

    return YES;
}

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Navigation Bar Title
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-Medium" size:17.0]}];
    
    // Navigation Bar Back Button
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-Medium" size:17.0]}
                                                                                            forState:UIControlStateNormal];
    
    return YES;
}

@end
