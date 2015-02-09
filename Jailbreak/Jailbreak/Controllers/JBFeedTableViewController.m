//
//  JBFeedTableViewController.m
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 26/01/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import "JBDonation.h"
#import "JBFeedTableViewController.h"

@interface JBFeedTableViewController ()

@property (nonatomic, strong) NSMutableArray *donations;

@end

@implementation JBFeedTableViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.donations = [NSMutableArray new];
    
    [[JBAPIManager manager] getAllDonationsWithParameters:@{@"limit": @20}
                                                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                      for (NSDictionary *dict in responseObject)
                                                      {
                                                          [self.donations addObject:[[JBDonation alloc] initWithJSON:dict]];
                                                      }
                                                      
                                                      [self.tableView reloadData];
                                                  } failure:nil];
    
    // Configure TableView
    self.tableView.estimatedRowHeight = 30.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.donations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.textLabel.text = [self.donations[indexPath.row] name];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [tableView dequeueReusableCellWithIdentifier:@"SectionHeader"];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 100.0f;
}

@end
