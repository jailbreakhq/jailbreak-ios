//
//  JBTeamProfileTableViewController.m
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 16/02/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import "JBMapTableViewCell.h"
#import "JBTeamProfileTableViewController.h"

@interface JBTeamProfileTableViewController ()

@end

@implementation JBTeamProfileTableViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Lower space between 1st cell and top
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 1)];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JBMapTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MapCell" forIndexPath:indexPath];
    
    cell.team = self.team;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 190.0;
}

@end
