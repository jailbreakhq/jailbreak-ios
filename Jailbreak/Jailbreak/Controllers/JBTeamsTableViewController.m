//
//  JBTeamsTableViewController.m
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 02/02/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import "JBTeam.h"
#import "JBTeamsTableViewCell.h"
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
                                                  
                                                  self.teams = [[self sortTeamsByKey:@"number" ascending:YES] mutableCopy];
                                                  [self.tableView reloadData];
                                              } failure:nil];
    
    // Configure TableView
//    self.tableView.estimatedRowHeight = 30.0;
//    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showTeamProfile"])
    {
        JBTestProfileViewController *dvc = (JBTestProfileViewController *)segue.destinationViewController;
        dvc.team = self.teams[[sender section]];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.teams.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JBTeamsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    cell.team = self.teams[indexPath.section];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"showTeamProfile" sender:indexPath];
}

#pragma mark - Helper Methods

- (NSArray *)sortTeamsByKey:(NSString *)key ascending:(BOOL)asccending
{
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:key ascending:asccending];
    return [self.teams sortedArrayUsingDescriptors:@[sortDescriptor]];
}

@end
