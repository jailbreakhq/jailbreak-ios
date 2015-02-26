//
//  JBTeamsTableViewController.m
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 02/02/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import "JBTeam.h"
#import <Stripe.h>
#import "JBService.h"
#import "JBTeamsTableViewCell.h"
#import "JBTeamsTableViewController.h"
#import "JBTeamProfileViewController.h"
#import "JBDonatePopoverViewController.h"

@interface JBTeamsTableViewController () <JBTeamsTableViewCellDelegate, UISearchControllerDelegate, UISearchResultsUpdating>

@property (nonatomic, strong) NSMutableArray *teamsPointer;
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) JBService *service;

@end

@implementation JBTeamsTableViewController

#pragma mark - Accessors

- (NSMutableArray *)teams
{
    if (!_teams)
    {
        _teams = [NSMutableArray new];
        self.teamsPointer = _teams;
    }
    return _teams;
}

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self startLoadingIndicator];
    
    // Configure Search
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil]; // display in same view as searching!
    self.searchController.delegate = self;
    self.searchController.searchResultsUpdater = self;
    self.searchController.searchBar.frame = CGRectMake(0, 0, self.tableView.frame.size.width, 44);
    self.searchController.searchBar.placeholder = @"Search by college, name or team";
    self.searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    self.searchController.searchBar.barTintColor = [UIColor whiteColor];
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    self.navigationItem.titleView = self.searchController.searchBar;

    // Lower space between 1st cell and top
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, self.tableView.sectionHeaderHeight + self.tableView.sectionFooterHeight)];
    self.tableView.tableHeaderView.backgroundColor = [UIColor clearColor];
    self.definesPresentationContext = YES; // Fixes dodgy search presenting when used outside Navigation Bar
    
    [[JBAPIManager manager] getServicesWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.service = [[JBService alloc] initWithJSON:responseObject];
        
        // Fetch teams
        [[JBAPIManager manager] getAllTeamsWithParameters:nil
                                                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                      for (NSDictionary *dict in responseObject)
                                                      {
                                                          JBTeam *team = [[JBTeam alloc] initWithJSON:dict];
                                                          team.distanceToX = [team.currentLocation distanceFromLocation:self.service.finalLocation];
                                                          team.distanceTravelled = [self.service.startLocation distanceFromLocation:team.currentLocation];
                                                          [self.teams addObject:team];
                                                      }
                                                      
                                                      [self stopLoadingIndicator];
                                                      [self.tableView reloadData];
                                                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                      [TSMessage displayMessageWithTitle:@"Failed To Get Teams" subtitle:operation.responseObject[@"message"] type:TSMessageTypeError];
                                                      [self stopLoadingIndicator];
                                                  }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [TSMessage displayMessageWithTitle:@"Oops" subtitle:operation.responseObject[@"message"] type:TSMessageTypeError];
        [self stopLoadingIndicator];
    }];    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showTeamProfile"])
    {
        JBTeamProfileViewController *dvc = (JBTeamProfileViewController *)segue.destinationViewController;
        dvc.team = self.teams[[sender section]];
        dvc.teamSectionIndex = [sender section];
        dvc.service = self.service;
        dvc.title = [self.teams[[sender section]] name];
    }
    else if ([segue.identifier isEqualToString:@"showDonationPopover"])
    {
        JBDonatePopoverViewController *dvc = (JBDonatePopoverViewController *)segue.destinationViewController;
        dvc.team = (JBTeam *)sender;
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
    cell.delegate = self;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"showTeamProfile" sender:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 205.0;
}

#pragma mark - UISearchResultsUpdatingDelegate

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    if (searchController.searchBar.text.length)
    {
        NSString *predicateFormat = @"(name CONTAINS[cd] $term) OR (membersNames CONTAINS[cd] $term) OR (about CONTAINS[cd] $term) OR (universityString MATCHES[cd] $term)";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateFormat];
        NSPredicate *newPredicate = [predicate predicateWithSubstitutionVariables:@{@"term": searchController.searchBar.text}];
        self.teams = [[self.teamsPointer filteredArrayUsingPredicate:newPredicate] mutableCopy];
    }
    else
    {
        self.teams = self.teamsPointer;
    }
    
    [self.tableView reloadData];
}

#pragma mark - JBTeamsTableViewCellDelegate

- (void)didTapDonateButtonForTeam:(JBTeam *)team
{
    [self performSegueWithIdentifier:@"showDonationPopover" sender:team];
}

#pragma mark - UISearchControllerDelegate

- (void)didDismissSearchController:(UISearchController *)searchController
{
    self.teams = self.teamsPointer;
    [self.tableView reloadData];
}

#pragma mark - Helper Methods

- (void)refresh
{
    [[JBAPIManager manager] getAllTeamsWithParameters:nil
                                              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                  [self.teams removeAllObjects];
                                                  
                                                  for (NSDictionary *dict in responseObject)
                                                  {
                                                      JBTeam *team = [[JBTeam alloc] initWithJSON:dict];
                                                      team.distanceToX = [team.currentLocation distanceFromLocation:self.service.finalLocation];
                                                      team.distanceTravelled = [self.service.startLocation distanceFromLocation:team.currentLocation];
                                                      [self.teams addObject:team];
                                                  }
                                                  
                                                  [self stopLoadingIndicator];
                                                  [self.refreshControl endRefreshing];
                                                  [self.tableView reloadData];
                                              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                  [TSMessage displayMessageWithTitle:@"Failed To Refresh Teams" subtitle:operation.responseObject[@"message"] type:TSMessageTypeError];
                                                  [self stopLoadingIndicator];
                                                  [self.refreshControl endRefreshing];
                                              }];
}

- (NSArray *)sortTeamsByKey:(NSString *)key ascending:(BOOL)asccending
{
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:key ascending:asccending];
    return [self.teams sortedArrayUsingDescriptors:@[sortDescriptor]];
}

@end
