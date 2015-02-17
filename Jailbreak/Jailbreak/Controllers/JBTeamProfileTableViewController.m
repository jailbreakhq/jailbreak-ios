//
//  JBTeamProfileTableViewController.m
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 16/02/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import "JBDonation.h"
#import "JBMapTableViewCell.h"
#import "NSDictionary+JBAdditions.h"
#import "JBTeamSummaryTableViewCell.h"
#import "JBTeamProfileTableViewController.h"

@interface JBTeamProfileTableViewController ()

@property (nonatomic, strong) NSMutableArray *donations; // of type JBDonation

@end

@implementation JBTeamProfileTableViewController

#pragma mark - Accessors

- (NSMutableArray *)donations
{
    if (!_donations) _donations = [NSMutableArray new];
    return _donations;
}

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[JBAPIManager manager] getAllDonationsWithParameters:@{@"filters": [@{@"teamId": @(self.team.ID)} jsonString]}
                                                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                      for (NSDictionary *donation in responseObject)
                                                      {
                                                          [self.donations addObject:[[JBDonation alloc] initWithJSON:donation]];
                                                      }
                                                      
                                                      [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
                                                  }
                                                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                      
                                                  }];

    // Lower space between 1st cell and top
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return 3;
            break;
        case 1:
            return self.donations.count;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id cell;
    
    if (indexPath.section == 0)
    {
        switch (indexPath.row)
        {
            case 0:
                cell = [tableView dequeueReusableCellWithIdentifier:@"MapCell" forIndexPath:indexPath];
                [cell setTeam:self.team];
                break;
            case 1:
                cell = [tableView dequeueReusableCellWithIdentifier:@"SummaryCell" forIndexPath:indexPath];
                [cell setTeam:self.team];
                break;
            case 2:
                cell = [tableView dequeueReusableCellWithIdentifier:@"AboutCell" forIndexPath:indexPath];
                [cell setTeam:self.team];
            default:
                cell = [tableView dequeueReusableCellWithIdentifier:@"MapCell" forIndexPath:indexPath];
                break;
        }
    }
    else if (indexPath.section == 1)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"DonationCell"];
        UITableViewCell *donationCell = (UITableViewCell *)cell;
        donationCell.textLabel.text = [self.donations[indexPath.row] name];
        donationCell.textLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:15.0];
        donationCell.detailTextLabel.text = [[self priceFormatter] stringFromNumber:@([self.donations[indexPath.row] amount] / 100.0)];
        donationCell.detailTextLabel.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:16.0];
        donationCell.detailTextLabel.textColor = self.team.universityColor;
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"MapCell" forIndexPath:indexPath];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        switch (indexPath.row)
        {
            case 0:
                return 190.0;
            case 1:
                return 190.0;
            case 2:
                return 200.0;
            default:
                return 44.0;
        }
    }
    else if (indexPath.section == 1)
    {
        return 44.0;
    }
    else
    {
        return 44.0;
    }
}

#pragma mark - Helper Methods

- (NSNumberFormatter *)priceFormatter
{
    static NSNumberFormatter *_priceFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _priceFormatter = [[NSNumberFormatter alloc] init];
        [_priceFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        [_priceFormatter setLocale:[NSLocale currentLocale]];
        [_priceFormatter setCurrencyCode:@"EUR"];
        _priceFormatter.minimumFractionDigits = 0;
    });
    
    return _priceFormatter;
}

@end
