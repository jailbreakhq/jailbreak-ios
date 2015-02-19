//
//  JBTeamProfileTableViewController.m
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 16/02/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import "JBDonation.h"
#import "JBAnnotation.h"
#import "JBYouTubeView.h"
#import <XCDYouTubeKit.h>
#import "JBMapTableViewCell.h"
#import "JBMapViewController.h"
#import "JBTeamVideoTableViewCell.h"
#import "JBTeamAboutTableViewCell.h"
#import "NSDictionary+JBAdditions.h"
#import "JBTeamSummaryTableViewCell.h"
#import "JBTeamProfileViewController.h"
#import "JBDonatePopoverViewController.h"

static const NSUInteger kMapCellRow     = 0;
static const NSUInteger kStatsCellRow   = 1;
static const NSUInteger kSummaryCellRow = 2;
static const NSUInteger kAboutCellRow   = 3;
static const NSUInteger kYouTubeCellRow = 4;

static NSString * const kMapCellIdentifier      = @"MapCell";
static NSString * const kStatsCellIdentifier    = @"StatsCell";
static NSString * const kSummaryCellIdentifier  = @"SummaryCell";
static NSString * const kAboutCellIdentifier    = @"AboutCell";
static NSString * const kYouTubeCellIdentifier  = @"YouTubeCell";
static NSString * const kDonationCellIdentifier = @"DonationCell";

@interface JBTeamProfileViewController () <JBYouTubeViewDelegate>

@property (nonatomic, strong) NSMutableArray *donations; // of type JBDonation
@property (nonatomic, strong) XCDYouTubeVideoPlayerViewController *videoPlayerViewController;

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIButton *donateButton;

@end

@implementation JBTeamProfileViewController

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
    
    // Lower space for header and footer
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];

    if (self.team.videoID)
    {
        self.videoPlayerViewController = [[XCDYouTubeVideoPlayerViewController alloc] initWithVideoIdentifier:self.team.videoID];
        
        NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
        [defaultCenter addObserver:self selector:@selector(videoPlayerViewControllerDidReceiveVideo:) name:XCDYouTubeVideoPlayerViewControllerDidReceiveVideoNotification object:self.videoPlayerViewController];
        [defaultCenter addObserver:self selector:@selector(moviePlayerPlaybackDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:self.videoPlayerViewController.moviePlayer];
    }
    
    // Button moves after load (possibly due to scroll view insets being set), here's a temp fix
    self.donateButton.alpha = 0.0;
    [UIView animateWithDuration:0.4
                          delay:0.8
                        options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         self.donateButton.alpha = 1.0;
                     } completion:nil];
    
    self.donateButton.backgroundColor = self.team.universityColor;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showDonationPopover"])
    {
        JBDonatePopoverViewController *dvc = (JBDonatePopoverViewController *)segue.destinationViewController;
        dvc.team = self.team;
    }
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
            return self.team.videoID ? 5 : 4;
            break;
        case 1:
            return self.donations.count + 1; // for "Donation" title cell
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
            case kMapCellRow:
                cell = [tableView dequeueReusableCellWithIdentifier:kMapCellIdentifier forIndexPath:indexPath];
                [cell setTeam:self.team];
                break;
            case kStatsCellRow:
                cell = [tableView dequeueReusableCellWithIdentifier:kStatsCellIdentifier forIndexPath:indexPath];
                [cell setTeam:self.team];
                break;
            case kSummaryCellRow:
                cell = [tableView dequeueReusableCellWithIdentifier:kSummaryCellIdentifier forIndexPath:indexPath];
                [cell setTeam:self.team];
                break;
            case kAboutCellRow:
                cell = [tableView dequeueReusableCellWithIdentifier:kAboutCellIdentifier forIndexPath:indexPath];
                [cell setTeam:self.team];
            case kYouTubeCellRow:
            {
                cell = [tableView dequeueReusableCellWithIdentifier:kYouTubeCellIdentifier forIndexPath:indexPath];
                JBTeamVideoTableViewCell *cellCasted = (JBTeamVideoTableViewCell *)cell;
                cellCasted.youTubeView.delegate = self;
                NSURL *hdThumbnail = [NSURL URLWithString:[NSString stringWithFormat:@"http://i3.ytimg.com/vi/%@/maxresdefault.jpg", self.team.videoID]];
                NSURL *sdThumbnail = [NSURL URLWithString:[NSString stringWithFormat:@"http://i3.ytimg.com/vi/%@/sddefault.jpg", self.team.videoID]];
                [cellCasted.youTubeView.thumbnailImageView sd_setImageWithURL:hdThumbnail
                                                                    completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                                                        if (!image)
                                                                        {
                                                                            [cellCasted.youTubeView.thumbnailImageView sd_setImageWithURL:sdThumbnail];
                                                                        }
                                                                    }];
                break;
            }
            default:
                cell = [tableView dequeueReusableCellWithIdentifier:kMapCellIdentifier forIndexPath:indexPath];
                break;
        }
    }
    else if (indexPath.section == 1)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kDonationCellIdentifier];
        UITableViewCell *donationCell = (UITableViewCell *)cell;
        
        if (indexPath.row == 0)
        {
            donationCell.textLabel.text = @"Donations";
            donationCell.textLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:16.0];
            donationCell.detailTextLabel.text = @"";
        }
        else
        {
            donationCell.textLabel.text = [self.donations[indexPath.row - 1] name];
            donationCell.textLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:15.0];
            donationCell.detailTextLabel.text = [[self priceFormatter] stringFromNumber:@([self.donations[indexPath.row - 1] amount] / 100.0)];
            donationCell.detailTextLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:16.0];
            donationCell.detailTextLabel.textColor = self.team.universityColor;
        }
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:kMapCellIdentifier forIndexPath:indexPath];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == kMapCellRow)
    {
        JBAnnotation *annotation = [JBAnnotation new];
        annotation.customCoordinate = self.team.currentLocation.coordinate;
        annotation.customTitle = @"Colins Barracks";

        JBMapViewController *dvc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"JBMapViewController"];
        dvc.title = @"Map";
        dvc.annotations = @[annotation];

        [self.navigationController pushViewController:dvc animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        switch (indexPath.row)
        {
            case kMapCellRow:
                return 190.0;
            case kStatsCellRow:
                return 125.0;
            case kSummaryCellRow:
                return 190.0;
            case kAboutCellRow:
                return [(JBTeamAboutTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kAboutCellIdentifier] heightForBodyLabelWithText:self.team.about];
            case kYouTubeCellRow:
                return 210.0;
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

#pragma mark - JBYouTubeViewDelegate

- (void)didTapPlayButton
{
    [self presentMoviePlayerViewControllerAnimated:self.videoPlayerViewController];
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
- (IBAction)didTapDonateButton:(UIButton *)sender
{
    [self performSegueWithIdentifier:@"showDonationPopover" sender:nil];
}

- (void)videoPlayerViewControllerDidReceiveVideo:(NSNotification *)notification
{
}

- (void)moviePlayerPlaybackDidFinish:(NSNotification *)notification
{
    
}

@end
