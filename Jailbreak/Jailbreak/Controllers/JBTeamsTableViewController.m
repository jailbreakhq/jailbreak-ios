//
//  JBTeamsTableViewController.m
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 02/02/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import "JBTeam.h"
#import "JBTeamsTableViewController.h"
#import "JBTestProfileViewController.h"

@interface JBTeamsTableViewController ()

@property (nonatomic, strong) NSMutableArray *teams;

@end

@implementation JBTeamsTableViewController

#pragma mark - Accessors

- (NSMutableArray *)teams
{
    if (!_teams) _teams = [NSMutableArray new];
    return _teams;
}

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Fetch teams
    [[JBAPIManager manager] getAllTeamsWithParameters:nil
                                              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                  for (NSDictionary *team in responseObject)
                                                  {
                                                      [self.teams addObject:[[JBTeam alloc] initWithJSON:team]];
                                                  }
                                                  
                                                  [self.tableView reloadData];
                                              } failure:nil];
    
    // Configure TableView
    self.tableView.estimatedRowHeight = 30.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showTeamProfile"])
    {
        JBTestProfileViewController *dvc = (JBTestProfileViewController *)segue.destinationViewController;
        dvc.team = self.teams[[sender row]];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.teams.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.textLabel.text = [self.teams[indexPath.row] name];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"showTeamProfile" sender:indexPath];
}

@end
