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

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
