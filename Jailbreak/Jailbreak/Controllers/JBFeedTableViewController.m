//
//  JBFeedTableViewController.m
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 26/01/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import "JBDonation.h"
#import "NSDictionary+JBAdditions.h"
#import "JBFeedTableViewController.h"

@interface JBFeedTableViewController ()

@end

@implementation JBFeedTableViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Configure TableView
    self.tableView.estimatedRowHeight = 30.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

#pragma mark - UITableViewDataSource


#pragma mark - UITableViewDelegate

@end
