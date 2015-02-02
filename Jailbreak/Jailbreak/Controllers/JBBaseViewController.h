//
//  JBBaseViewController.h
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 26/01/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JBBaseViewController : UIViewController

- (void)handleApplicationDidEnterBackgroundNotification;
- (void)handleApplicationDidBecomeActiveNotification;

- (id)loadFromArchiveObjectWithKey:(NSString *)key;
- (void)saveToArchiveObject:(id)object withKey:(NSString *)key;

@end
