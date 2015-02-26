//
//  JBPostTableViewController.m
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 25/02/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import <JTSImageViewController.h>
#import "JBFeedImageTableViewCell.h"
#import "JBFeedDonateTableViewCell.h"
#import "JBPostTableViewController.h"
#import "JBDonatePopoverViewController.h"

static NSString * const kTextCellIdentifier         = @"TextCell";
static NSString * const kInstagramCellIdentifier    = @"InstagramCell";
static NSString * const kImageCellIdentifier        = @"ImageCell";
static NSString * const kVineCellIdentifier         = @"VineCell";
static NSString * const kDonateCellIdentifier       = @"DonateCell";
static NSString * const kLinkCellIdentifier         = @"LinkCell";

@interface JBPostTableViewController () <JBFeedImageTableViewCellDelegate, JBFeedDonateTableViewCellDelegate>

@end

@implementation JBPostTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.refreshControl = nil;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showDonationPopover"])
    {
        JBDonatePopoverViewController *dvc = (JBDonatePopoverViewController *)segue.destinationViewController;
        dvc.team = (JBTeam *)sender;
    }
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
    id cell;
    
    if (self.post.postType == JBPostTypeLink)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:kLinkCellIdentifier forIndexPath:indexPath];
    }
    else if (self.post.containsThumbnail)
    {
        if (self.post.postType == JBPostTypeInstagram)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:kInstagramCellIdentifier forIndexPath:indexPath];
        }
        else if (self.post.postType == JBPostTypeVine)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:kVineCellIdentifier forIndexPath:indexPath];
        }
        else
        {
            cell = [tableView dequeueReusableCellWithIdentifier:kImageCellIdentifier forIndexPath:indexPath];
        }
        
        [(JBFeedImageTableViewCell *)cell setDelegate:self];
    }
    else if ([self.post postType] == JBPostTypeDonate)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:kDonateCellIdentifier forIndexPath:indexPath];
        [(JBFeedDonateTableViewCell *)cell setDelegate:self];
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:kTextCellIdentifier forIndexPath:indexPath];
    }
    
    [cell configureCellWithPost:self.post];
    
    return cell;
}

#pragma mark - JBFeedImageTableViewCellDelegate

- (void)feedImageTableViewCell:(JBFeedBaseTableViewCell *)cell didTapOnThumbnailImageView:(UIImageView *)imageView
{
    JTSImageInfo *imageInfo = [JTSImageInfo new];
    imageInfo.image = imageView.image;
    imageInfo.referenceRect = imageView.frame;
    imageInfo.referenceView = imageView.superview;
    imageInfo.referenceContentMode = imageView.contentMode;
    imageInfo.referenceCornerRadius = imageView.layer.cornerRadius;
    
    JTSImageViewController *imageViewController = [[JTSImageViewController alloc] initWithImageInfo:imageInfo
                                                                                               mode:JTSImageViewControllerMode_Image
                                                                                    backgroundStyle:JTSImageViewControllerBackgroundOption_Blurred];
    
    [imageViewController showFromViewController:self transition:JTSImageViewControllerTransition_FromOriginalPosition];
}

#pragma mark - JBFeedDonateTableViewCellDelegate

- (void)didTapDonateButtonWithTeam:(JBTeam *)team
{
    if (team)
    {
        [self performSegueWithIdentifier:@"showDonationPopover" sender:team];
    }
}

@end
