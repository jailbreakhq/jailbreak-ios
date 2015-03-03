//
//  JBPostsTableViewController.h
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 28/02/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import "JBService.h"
#import "JBBaseTableViewController.h"

@interface JBPostsTableViewController : JBBaseTableViewController

@property (nonatomic, strong) NSMutableArray *posts;
@property (nonatomic, strong) JBService *service;

@end
