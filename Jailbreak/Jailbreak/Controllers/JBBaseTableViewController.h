//
//  JBBaseTableViewController.h
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 26/01/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JBBaseTableViewController : UITableViewController

- (void)handleApplicationDidEnterBackgroundNotification;
- (void)handleApplicationDidBecomeActiveNotification;

@end
