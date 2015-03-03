//
//  JBTeamProfileTableViewController.m
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 16/02/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import "JBCheckin.h"
#import "JBDonation.h"
#import "JBAnnotation.h"
#import "JBAppDelegate.h"
#import "JBPostYouTube.h"
#import "JBYouTubeView.h"
#import <XCDYouTubeKit.h>
#import <JTSHardwareInfo.h>
#import "JBMapTableViewCell.h"
#import <JTSImageViewController.h>
#import "JBTeamMapViewController.h"
#import "JBTeamVideoTableViewCell.h"
#import "JBTeamAboutTableViewCell.h"
#import "NSDictionary+JBAdditions.h"
#import "JBTeamsTableViewController.h"
#import "JBTeamSummaryTableViewCell.h"
#import "JBTeamProfileViewController.h"
#import "JBTeamPostsTableViewController.h"

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

@interface JBTeamProfileViewController () <JBTeamSummaryTableViewCellDelegate, JBYouTubeViewDelegate>

@property (nonatomic, strong) XCDYouTubeVideoPlayerViewController *videoPlayerViewController;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) NSURL *videoThumbnailURL;
@property (nonatomic, strong) id observer;

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIButton *donateButton;

@end

@implementation JBTeamProfileViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.navigationController)
    {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Feed" style:UIBarButtonItemStylePlain target:self action:@selector(didTapFeedBarButton:)];
    }
    
    // Get YouTube video thumbnail
    if (self.team.videoID)
    {
        self.videoPlayerViewController = [[XCDYouTubeVideoPlayerViewController alloc] initWithVideoIdentifier:self.team.videoID];
        
        if (!self.team.videoThumbnailURL)
        {
            [JBPostYouTube getThumbnailURLForYouTubeVideoWithId:self.team.videoID completionHandler:^(NSURL *thumbnailURL) {
                self.team.videoThumbnailURL = thumbnailURL;
                self.videoThumbnailURL = self.team.videoThumbnailURL;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    JBTeamVideoTableViewCell *cell = (JBTeamVideoTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:kYouTubeCellRow inSection:0]];
                    if (cell)
                    {
                        [cell.youTubeView.thumbnailImageView sd_setImageWithURL:self.team.videoThumbnailURL];
                    }
                });
            }];
        }
    }
    
    self.refreshControl = [UIRefreshControl new];
    [self.refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
    [[JBAPIManager manager] getAllDonationsWithParameters:@{@"filters": [@{@"teamId": @(self.team.ID)} jsonString], @"limit": @(20)}
                                                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                      NSMutableArray *temp = [NSMutableArray new];
                                                      for (NSDictionary *donation in responseObject)
                                                      {
                                                          [temp addObject:[[JBDonation alloc] initWithJSON:donation]];
                                                      }
                                                      self.team.numberOfDonations = [operation.response.allHeaderFields[@"x-total-count"] integerValue];
                                                      self.team.donations = temp;
                                                      
                                                      [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
                                                  }
                                                  failure:nil];
    
    [[JBAPIManager manager] getCheckinsForTeamWithId:self.team.ID
                                             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                 NSMutableArray *temp = [NSMutableArray new];
                                                 for (NSDictionary *dict in responseObject)
                                                 {
                                                     [temp addObject:[[JBCheckin alloc] initWithJSON:dict]];
                                                 }
                                                 self.team.checkins = temp;
                                             } failure:nil];
    
    // Lower space for header and footer
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 60.0)];
    
    // Button moves after load (possibly due to scroll view insets being set), here's a temp fix
    self.donateButton.alpha = 0.0;
    self.donateButton.backgroundColor = self.team.universityColor;
    [UIView animateWithDuration:0.4
                          delay:0.5
                        options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         self.donateButton.alpha = 1.0;
                     } completion:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.observer = [[NSNotificationCenter defaultCenter] addObserverForName:kJBDonationDidSucceedNotification
                                                                      object:nil
                                                                       queue:[NSOperationQueue mainQueue]
                                                                  usingBlock:^(NSNotification *note) {
                                                                      [self handleDonationDidSucceed];
                                                                  }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self.observer];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showFeed"])
    {
        JBTeamPostsTableViewController *dvc = (JBTeamPostsTableViewController *)segue.destinationViewController;
        dvc.team = self.team;
    }
    else if ([segue.identifier isEqualToString:@"showMap"])
    {
        JBTeamMapViewController *dvc = (JBTeamMapViewController *)segue.destinationViewController;
        dvc.title = @"Checkins";
        dvc.team = self.team;
    }
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
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
            return self.team.videoID ? 5 : 4; // don't show video if none
            break;
        case 1:
            return self.team.donations.count + 1 + (self.team.donations.count < self.team.numberOfDonations ? 1 : 0); // for "Donation" title cell and footer count cell
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
                [(JBTeamSummaryTableViewCell *)cell setDelegate:self];
                break;
            case kAboutCellRow:
                cell = [tableView dequeueReusableCellWithIdentifier:kAboutCellIdentifier forIndexPath:indexPath];
                [cell setTeam:self.team];
                break;
            case kYouTubeCellRow:
            {
                cell = [tableView dequeueReusableCellWithIdentifier:kYouTubeCellIdentifier forIndexPath:indexPath];
                JBTeamVideoTableViewCell *cellCasted = (JBTeamVideoTableViewCell *)cell;
                cellCasted.youTubeView.delegate = self;
                [cellCasted.youTubeView.thumbnailImageView sd_setImageWithURL:self.team.videoThumbnailURL];
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
        donationCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (indexPath.row == 0)
        {
            donationCell.textLabel.text = @"Donations";
            donationCell.textLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:16.0];
            donationCell.detailTextLabel.text = @"";
        }
        else if (indexPath.row == self.team.donations.count + 1)
        {
            donationCell.textLabel.text = [NSString stringWithFormat:@"and %@ more donations...", @(self.team.numberOfDonations - self.team.donations.count)];
            donationCell.textLabel.font = [UIFont fontWithName:@"AvenirNext-Italic" size:14.0];
            donationCell.detailTextLabel.text = @"";
        }
        else
        {
            donationCell.textLabel.text = [self.team.donations[indexPath.row - 1] name];
            donationCell.textLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:15.0];
            donationCell.detailTextLabel.text = [[self priceFormatter] stringFromNumber:@([self.team.donations[indexPath.row - 1] amount] / 100.0)];
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
        [self performSegueWithIdentifier:@"showMap" sender:nil];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        switch (indexPath.row)
        {
            case kMapCellRow:
                if ([JTSHardwareInfo hardwareFamily] == JTSHardwareFamily_iPad)
                    return 280.0;
                else
                    return 180.0;
            case kStatsCellRow:
                return 125.0;
            case kSummaryCellRow:
                return 200.0;
            case kAboutCellRow:
                return [(JBTeamAboutTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kAboutCellIdentifier] heightForBodyLabelWithText:self.team.about];
            case kYouTubeCellRow:
                if ([JTSHardwareInfo hardwareFamily] == JTSHardwareFamily_iPad)
                    return 432.0;
                else
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

#pragma mark - JBTeamSummaryTableViewCellDelegate

- (void)didTapAvatarImageView:(UIImageView *)avatarImageView
{
    JTSImageInfo *imageInfo = [JTSImageInfo new];
    imageInfo.image = avatarImageView.image;
    imageInfo.referenceRect = avatarImageView.frame;
    imageInfo.referenceView = avatarImageView.superview;
    imageInfo.referenceContentMode = avatarImageView.contentMode;
    imageInfo.referenceCornerRadius = avatarImageView.layer.cornerRadius;
    
    JTSImageViewController *imageViewController = [[JTSImageViewController alloc] initWithImageInfo:imageInfo
                                                                                               mode:JTSImageViewControllerMode_Image
                                                                                    backgroundStyle:JTSImageViewControllerBackgroundOption_Blurred];
    
    [imageViewController showFromViewController:self transition:JTSImageViewControllerTransition_FromOriginalPosition];
}

#pragma mark - JBDonatePopoverViewControllerDelegate

- (void)handleDonationDidSucceed
{
    __weak typeof(self) weakSelf = self;
    
    // Refresh team data to update raised amount and donations
    [[JBAPIManager manager] getTeamWithId:self.team.ID
                                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                      
                                      NSMutableArray *checkins = weakSelf.team.checkins;
                                      weakSelf.team = [[JBTeam alloc] initWithJSON:responseObject];
                                      weakSelf.team.checkins = checkins;
                                      
                                      JBTeamsTableViewController *vc = [self getPreviousViewController];
                                      vc.teams[weakSelf.teamSectionIndex] = weakSelf.team;
                                      [vc.tableView reloadData];
                                      
                                      [[JBAPIManager manager] getAllDonationsWithParameters:@{@"filters": [@{@"teamId": @(self.team.ID)} jsonString], @"limit": @(20)}
                                                                                    success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                                                        
                                                                                        NSMutableArray *temp = [NSMutableArray new];
                                                                                        for (NSDictionary *donation in responseObject)
                                                                                        {
                                                                                            [temp addObject:[[JBDonation alloc] initWithJSON:donation]];
                                                                                        }
                                                                                        weakSelf.team.numberOfDonations = [operation.response.allHeaderFields[@"x-total-count"] integerValue];
                                                                                        weakSelf.team.donations = temp;
                                                                                        
                                                                                        [weakSelf.tableView reloadData];
                                                                                        
                                                                                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                                                        [weakSelf.tableView reloadData];
                                                                                    }];
                                  } failure:nil];
}

#pragma mark - Helper Methods

- (JBTeamsTableViewController *)getPreviousViewController
{
    NSUInteger index = self.navigationController.viewControllers.count - 2;
    return (JBTeamsTableViewController *)self.navigationController.viewControllers[index];
}

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
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://jailbreakhq.org/donate/%@?iphone=true", self.team.slug]]];
}

- (IBAction)didTapFeedBarButton:(UIBarButtonItem *)sender
{
    [self performSegueWithIdentifier:@"showFeed" sender:nil];
}

- (void)refresh
{
    __weak typeof(self) weakSelf = self;
    
    [[JBAPIManager manager] getTeamWithId:self.team.ID
                                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                      weakSelf.team = [[JBTeam alloc] initWithJSON:responseObject];
                                      weakSelf.team.videoThumbnailURL = weakSelf.videoThumbnailURL;
                                      JBTeamsTableViewController *vc = [weakSelf getPreviousViewController];
                                      vc.teams[weakSelf.teamSectionIndex] = weakSelf.team;
                                      [vc.tableView reloadData];
                                      
                                      [[JBAPIManager manager] getAllDonationsWithParameters:@{@"filters": [@{@"teamId": @(self.team.ID)} jsonString], @"limit": @(20)}
                                                                                    success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                                                        NSMutableArray *temp = [NSMutableArray new];
                                                                                        for (NSDictionary *donation in responseObject)
                                                                                        {
                                                                                            [temp addObject:[[JBDonation alloc] initWithJSON:donation]];
                                                                                        }
                                                                                        self.team.donations = temp;
                                                                                        self.team.numberOfDonations = [operation.response.allHeaderFields[@"x-total-count"] integerValue];
                                                                                        
                                                                                        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
                                                                                        [self.refreshControl endRefreshing];
                                                                                    }
                                                                                    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                                                        [self.refreshControl endRefreshing];
                                                                                    }];
                                      
                                      [[JBAPIManager manager] getCheckinsForTeamWithId:self.team.ID
                                                                               success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                                                   NSMutableArray *temp = [NSMutableArray new];
                                                                                   for (NSDictionary *dict in responseObject)
                                                                                   {
                                                                                       [temp addObject:[[JBCheckin alloc] initWithJSON:dict]];
                                                                                   }
                                                                                   self.team.checkins = temp;
                                                                                   [self.refreshControl endRefreshing];
                                                                               } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                                                   [self.refreshControl endRefreshing];
                                                                               }];
                                      
                                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                      [TSMessage displayMessageWithTitle:@"Failed To Refresh Profile" subtitle:@"" type:TSMessageTypeWarning];
                                      [self.refreshControl endRefreshing];
                                  }];
}

@end
