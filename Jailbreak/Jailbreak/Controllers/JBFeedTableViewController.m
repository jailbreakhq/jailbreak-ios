//
//  JBFeedTableViewController.m
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 26/01/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import "JBPost.h"
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

@property (nonatomic, strong) NSMutableArray *posts;

@end

@implementation JBFeedTableViewController

#pragma mark - Accessors

- (NSMutableArray *)posts
{
    if (!_posts) _posts = [NSMutableArray new];
    return _posts;
}

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Configure TableView
    self.tableView.estimatedRowHeight = 65.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    JBPost *post;
    
    post = [[JBPost alloc] initWithJSON:@{@"teamName": @"Benedict & Thomas", @"body": @"Arca was definitely a hater.", @"teamAvatar": @"https://static.jailbreakhq.org/avatars/small/team-50.png",
                                   @"network": @"Twitter"}];
    [self.posts addObject:post];
    
    post = [[JBPost alloc] initWithJSON:@{@"teamName": @"Benedict & Thomas", @"body": @"Had a bunch of black guys in a twerk circle is probably the two releases that got me properly into techno",
                                          @"teamAvatar": @"https://static.jailbreakhq.org/avatars/small/team-50.png", @"network": @"Twitter"}];
    [self.posts addObject:post];
    
    post = [[JBPost alloc] initWithJSON:@{@"teamName": @"Benedict & Thomas", @"body": @"Working on this British Shorthair today. #YearOfTheFat #FatFriends https://instagram.com/p/zVcJQ7LClQ/",
                                          @"teamAvatar": @"https://static.jailbreakhq.org/avatars/small/team-50.png", @"network": @"FACEBOOK",
                                          @"media": @"http://scontent-a.cdninstagram.com/hphotos-xaf1/t51.2885-15/e15/11015502_1399670580341952_1221936374_n.jpg"}];
    [self.posts addObject:post];
    
    post = [[JBPost alloc] initWithJSON:@{@"teamName": @"Benedict & Thomas", @"body": @"Thanks so much to everyone for liking the page, we really appreciate your support and enthusiasm 😊 Looking forward to seeing all those of you who live in Dublin at our bakesale next week, and at some other fun events we have planned for the near future. However, we still need your help to raise as much money as possible for SVP and Amnesty international, so if you have any loose change rattling around at the bottom of your pockets, please direct it our way here: https://jailbreakhq.org/teams/team-74 Thanks guys x",
                                          @"teamAvatar": @"https://static.jailbreakhq.org/avatars/small/team-50.png", @"network": @"facebook"}];
    [self.posts addObject:post];
    
    post = [[JBPost alloc] initWithJSON:@{@"teamName": @"Benedict & Thomas", @"teamAvatar": @"https://static.jailbreakhq.org/avatars/small/team-50.png", @"network": @"iNstagraM",
                                          @"media": @"http://scontent-b.cdninstagram.com/hphotos-xaf1/t51.2885-15/e15/10932646_593864644091568_589300573_n.jpg"}];
    [self.posts addObject:post];
    
    post = [[JBPost alloc] initWithJSON:@{@"teamName": @"Benedict & Thomas", @"body": @"Ive watched so may Liam Neeson movies. Another two long days of progress.", @"teamAvatar": @"https://static.jailbreakhq.org/avatars/small/team-50.png",
                                          @"network": @"instagram", @"media": @"http://scontent-b.cdninstagram.com/hphotos-xap1/t51.2885-15/e15/10296704_1778125709080310_1766583521_n.jpg"}];
    [self.posts addObject:post];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.posts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JBFeedImageTableViewCell *cell;
    
    if ([self.posts[indexPath.row] mediaURL])
    {
        if ([self.posts[indexPath.row] socialNetwork] == JBPostSocialNetworkInstagram)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:kInstagramCellIdentifier forIndexPath:indexPath];
        }
        else
        {
            cell = [tableView dequeueReusableCellWithIdentifier:kImageCellIdentifier forIndexPath:indexPath];
        }
        
        [cell.thumbnailImageView sd_setImageWithProgressAndURL:[self.posts[indexPath.row] mediaURL]];
        cell.delegate = self;
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:kTextCellIdentifier forIndexPath:indexPath];
    }
    
    switch ([self.posts[indexPath.row] socialNetwork])
    {
        case JBPostSocialNetworkFacebook:
            cell.socialNetworkImageView.image = [UIImage imageNamed:@"facebookLogo"];
            break;
        case JBPostSocialNetworkInstagram:
            cell.socialNetworkImageView.image = [UIImage imageNamed:@"instagramLogo"];
            break;
        case JBPostSocialNetworkTwitter:
            cell.socialNetworkImageView.image = [UIImage imageNamed:@"twitterLogo"];
            break;
        case JBPostSocialNetworkVine:
            cell.socialNetworkImageView.image = [UIImage imageNamed:@"vineLogo"];
            break;
    }

    [cell.avatarImageView sd_setImageWithProgressAndURL:[self.posts[indexPath.row] teamAvatarURL]];
    cell.titleLabel.text = [self.posts[indexPath.row] teamName];
    cell.bodyLabel.text = [self.posts[indexPath.row] body];
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

#pragma mark - Helper Methods

- (void)refresh
{
    NSUInteger numberOfNewPosts = 3;
    
    for (int i = 0; i < numberOfNewPosts; i++)
    {
        [self.posts insertObject:self.posts[self.posts.count-1-i] atIndex:0];
    }
    
    CGPoint contentOffsetBefore = self.tableView.contentOffset;
    
    // If < -64 (when pulling down to refresh) use -64, otherwise use the current value
    contentOffsetBefore.y = fmaxf(-[self.topLayoutGuide length], contentOffsetBefore.y);
    
    [self.tableView reloadData];
    
    // For some reason you need to get the rects before hand or the values will be wrong
    for (int i = 0; i < numberOfNewPosts; i++)
    {
        [self.tableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    
    contentOffsetBefore.y += [self.tableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:numberOfNewPosts inSection:0]].origin.y;
    [self.tableView setContentOffset:contentOffsetBefore animated:YES];
    [self.refreshControl endRefreshing];
}

@end
