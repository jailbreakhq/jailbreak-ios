//
//  JBFeedTableViewController.m
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 26/01/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import "JBDonation.h"
#import <JTSImageViewController.h>
#import "JBFeedBaseTableViewCell.h"
#import "NSDictionary+JBAdditions.h"
#import "JBFeedImageTableViewCell.h"
#import "JBFeedTableViewController.h"

static NSString * const kTextCellIdentifier         = @"TextCell";
static NSString * const kInstagramCellIdentifier    = @"InstagramCell";
static NSString * const kImageCellIdentifier        = @"ImageCell";


@interface JBFeedTableViewController () <JBFeedImageTableViewCellDelegate>

@property (nonatomic, assign) CGPoint tableViewContentOffsetPriorToJTSPresentation;

@end

@implementation JBFeedTableViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Configure TableView
    self.tableView.estimatedRowHeight = 65.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JBFeedImageTableViewCell *cell;
    
    switch (indexPath.row)
    {
        case 0:
            cell = [tableView dequeueReusableCellWithIdentifier:kTextCellIdentifier forIndexPath:indexPath];
            cell.socialNetworkImageView.image = [UIImage imageNamed:@"twitterLogo"];
            cell.bodyLabel.text = @"Arca was definitely a hater.";
            break;
        case 1:
            cell = [tableView dequeueReusableCellWithIdentifier:kTextCellIdentifier forIndexPath:indexPath];
            cell.socialNetworkImageView.image = [UIImage imageNamed:@"twitterLogo"];
            cell.bodyLabel.text = @"Had a bunch of black guys in a twerk circle is probably the two releases that got me properly into techno";
            break;
        case 2:
            cell = [tableView dequeueReusableCellWithIdentifier:kImageCellIdentifier forIndexPath:indexPath];
            cell.socialNetworkImageView.image = [UIImage imageNamed:@"facebookLogo"];
            cell.bodyLabel.text = @"Working on this British Shorthair today. #YearOfTheFat #FatFriends https://instagram.com/p/zVcJQ7LClQ/";
            [cell.thumbnailImageView sd_setImageWithProgressAndURL:[NSURL URLWithString:@"http://scontent-a.cdninstagram.com/hphotos-xaf1/t51.2885-15/e15/11015502_1399670580341952_1221936374_n.jpg"]];
            cell.delegate = self;
            break;
        case 3:
            cell = [tableView dequeueReusableCellWithIdentifier:kTextCellIdentifier forIndexPath:indexPath];
            cell.socialNetworkImageView.image = [UIImage imageNamed:@"facebookLogo"];
            cell.bodyLabel.text = @"Thanks so much to everyone for liking the page, we really appreciate your support and enthusiasm 😊 Looking forward to seeing all those of you who live in Dublin at our bakesale next week, and at some other fun events we have planned for the near future. However, we still need your help to raise as much money as possible for SVP and Amnesty international, so if you have any loose change rattling around at the bottom of your pockets, please direct it our way here: https://jailbreakhq.org/teams/team-74 Thanks guys x";
            break;
        case 4:
            cell = [tableView dequeueReusableCellWithIdentifier:kInstagramCellIdentifier forIndexPath:indexPath];
            cell.socialNetworkImageView.image = [UIImage imageNamed:@"instagramLogo"];
            cell.bodyLabel.text = @"";
            [cell.thumbnailImageView sd_setImageWithProgressAndURL:[NSURL URLWithString:@"http://scontent-b.cdninstagram.com/hphotos-xaf1/t51.2885-15/e15/10932646_593864644091568_589300573_n.jpg"]];
            cell.delegate = self;
            break;
        case 5:
            cell = [tableView dequeueReusableCellWithIdentifier:kInstagramCellIdentifier forIndexPath:indexPath];
            cell.socialNetworkImageView.image = [UIImage imageNamed:@"instagramLogo"];
            cell.bodyLabel.text = @"Ive watched so may Liam Neeson movies. Another two long days of progress.";
            [cell.thumbnailImageView sd_setImageWithProgressAndURL:[NSURL URLWithString:@"http://scontent-b.cdninstagram.com/hphotos-xap1/t51.2885-15/e15/10296704_1778125709080310_1766583521_n.jpg"]];
            cell.delegate = self;
            break;
        default:
            break;
    }

    [cell.avatarImageView sd_setImageWithProgressAndURL:[NSURL URLWithString:@"https://static.jailbreakhq.org/avatars/small/team-50.png"]];
    cell.titleLabel.text = @"Benedict & Thomas";
    cell.timeLabel.text = @"20m";
    
    return cell;
}

#pragma mark - UITableViewDelegate

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
                                                                                    backgroundStyle:JTSImageViewControllerBackgroundOption_None];
    
    [imageViewController showFromViewController:self transition:JTSImageViewControllerTransition_FromOriginalPosition];
}

@end
