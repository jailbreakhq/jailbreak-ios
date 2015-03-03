//
//  JBAppDelegate.m
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 26/01/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//


#import <TSMessage.h>
#import <TSMessageView.h>
#import "JBAppDelegate.h"
#import "UIColor+JBAdditions.h"
#import <SDWebImage/SDImageCache.h>
#import <XCDYouTubeVideoPlayerViewController.h>

@interface JBAppDelegate ()

@end

@implementation JBAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Configure SDWebImage
    SDImageCache *sharedImageCache = [SDImageCache sharedImageCache];
    sharedImageCache.maxCacheAge = 1 * 7 * 24 * 60 * 60; // 1 week
    sharedImageCache.maxCacheSize = 200 * 1000000; // 200 MBs
    [sharedImageCache cleanDisk]; // remove all expired cached image on each launch

    return YES;
}

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Global Tint
    [self.window setTintColor:[UIColor colorWithHexString:@"#B41C21"]];
    [self.window setTintAdjustmentMode:UIViewTintAdjustmentModeNormal];
    
    // Navigation Bar Title
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-Medium" size:17.0]}];
    
    // Navigation Bar Back Button
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-Medium" size:17.0]}
                                                                                            forState:UIControlStateNormal];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    TSMessageView *messageView = [TSMessage messageWithTitle:@"Thank you so much for donating and supporting Amnesty & SVP 😘" subtitle:nil type:TSMessageTypeSuccess];
    messageView.duration = 4.0;
    [messageView displayOrEnqueue];
    
    return YES;
}

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    if ([window isKindOfClass:[TSWindowContainer class]])
    {
        return UIInterfaceOrientationMaskPortrait;
    }
    else
    {
        if ([self.window.rootViewController.presentedViewController isKindOfClass:[XCDYouTubeVideoPlayerViewController class]])
        {
            return UIInterfaceOrientationMaskAllButUpsideDown;
        }
        
        return UIInterfaceOrientationMaskPortrait;
    }
}

@end
