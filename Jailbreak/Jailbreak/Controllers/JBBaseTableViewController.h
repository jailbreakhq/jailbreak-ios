//
//  JBBaseTableViewController.h
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 26/01/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JBAPIManager.h"
#import <RTSpinKitView.h>
#import "UIImageView+WebCacheWithProgress.h"

@interface JBBaseTableViewController : UITableViewController

@property (nonatomic, strong) RTSpinKitView *loadingIndicatorView;

- (void)handleApplicationDidEnterBackgroundNotification;
- (void)handleApplicationDidBecomeActiveNotification;

- (void)refresh;
- (void)startLoadingIndicator;
- (void)stopLoadingIndicator;

- (id)loadFromArchiveObjectWithKey:(NSString *)key;
- (void)saveToArchiveObject:(id)object withKey:(NSString *)key;

@end
