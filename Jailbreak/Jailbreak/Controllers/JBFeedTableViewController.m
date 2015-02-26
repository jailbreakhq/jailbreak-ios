//
//  JBFeedTableViewController.m
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 26/01/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import "JBPost.h"
#import "JBDonation.h"
#import <SAMRateLimit.h>
#import <Social/Social.h>
#import <TSMessageView.h>
#import <NSDate+DateTools.h>
#import <Accounts/Accounts.h>
#import "UIColor+JBAdditions.h"
#import <AFURLSessionManager.h>
#import <JTSImageViewController.h>
#import "JBFeedBaseTableViewCell.h"
#import "JBFeedVineTableViewCell.h"
#import "NSDictionary+JBAdditions.h"
#import "JBFeedImageTableViewCell.h"
#import "JBFeedDonateTableViewCell.h"
#import "JBFeedTableViewController.h"
#import "JBPostTableViewController.h"
#import "JBDonatePopoverViewController.h"

static NSString * const kTextCellIdentifier         = @"TextCell";
static NSString * const kInstagramCellIdentifier    = @"InstagramCell";
static NSString * const kImageCellIdentifier        = @"ImageCell";
static NSString * const kVineCellIdentifier         = @"VineCell";
static NSString * const kDonateCellIdentifier       = @"DonateCell";
static NSString * const kLinkCellIdentifier         = @"LinkCell";
static NSString * const kSAMBlockName               = @"Refreshing";
static NSString * const kPostsArchiveKey            = @"Posts-JBFeedTableViewController";

static const NSTimeInterval kIntervalBetweenRefreshing = 60.0;

@interface JBFeedTableViewController () <JBFeedImageTableViewCellDelegate, JBFeedDonateTableViewCellDelegate>

@property (nonatomic, strong) NSMutableArray *posts;
@property (nonatomic, weak) NSTimer *timer;

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
    
//    self.posts = [self loadFromArchiveObjectWithKey:kPostsArchiveKey];
    
    if (!self.posts.count)
    {
        [self startLoadingIndicator];
        
        [[JBAPIManager manager] getEventsWithParameters:nil
                                                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                    for (NSDictionary *event in responseObject)
                                                    {
                                                        if ([JBPost getPostTypeFromString:event[@"type"]] != JBPostTypeUndefined)
                                                        {
                                                            [self.posts addObject:[[JBPost alloc] initWithJSON:event]];
                                                        }
                                                    }
                                                    [self.tableView reloadData];
                                                    [self stopLoadingIndicator];
                                                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                    [TSMessage displayMessageWithTitle:@"Oops" subtitle:operation.responseObject[@"message"] type:TSMessageTypeError];
                                                    [self stopLoadingIndicator];
                                                }];
    }
    else
    {
        [self.tableView reloadData];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Just to be extra safe!
    if (!self.timer)
    {
        NSTimer *timer = [[NSTimer alloc] initWithFireDate:[NSDate date]
                                                  interval:1.0
                                                    target:self
                                                  selector:@selector(updateCellTimeAgoLabel:)
                                                  userInfo:nil
                                                   repeats:YES];
        self.timer = timer;
        
        // To update while scrolling the table view
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    }
    
//    if (!self.posts.count)
//    {
//        self.posts = [self loadFromArchiveObjectWithKey:kPostsArchiveKey];
//    }
//
//    [SAMRateLimit executeBlock:^{
//        [self refresh];
//        NSLog(@"refresh");
//    } name:kSAMBlockName limit:kIntervalBetweenRefreshing];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self.timer invalidate];
    self.timer = nil;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showPost"])
    {
        JBPostTableViewController *dvc = (JBPostTableViewController *)segue.destinationViewController;
        dvc.post = self.posts[[sender row]];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.posts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id cell;
    
    if ([self.posts[indexPath.row] postType] == JBPostTypeLink)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:kLinkCellIdentifier forIndexPath:indexPath];
    }
    else if ([self.posts[indexPath.row] containsThumbnail])
    {
        if ([self.posts[indexPath.row] postType] == JBPostTypeInstagram)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:kInstagramCellIdentifier forIndexPath:indexPath];
        }
        else if ([self.posts[indexPath.row] postType] == JBPostTypeVine)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:kVineCellIdentifier forIndexPath:indexPath];
        }
        else
        {
            cell = [tableView dequeueReusableCellWithIdentifier:kImageCellIdentifier forIndexPath:indexPath];
        }
        
        [(JBFeedImageTableViewCell *)cell setDelegate:self];
    }
    else if ([self.posts[indexPath.row] postType] == JBPostTypeDonate)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:kDonateCellIdentifier forIndexPath:indexPath];
        [(JBFeedDonateTableViewCell *)cell setDelegate:self];
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:kTextCellIdentifier forIndexPath:indexPath];
    }
    
    [cell configureCellWithPost:self.posts[indexPath.row]];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.posts[indexPath.row] postType] != JBPostTypeVine)
    {
        [self performSegueWithIdentifier:@"showPost" sender:indexPath];
    }
    else
    {
        JBFeedVineTableViewCell *cell = (JBFeedVineTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];        
        [cell playOrStopVine];
    }
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *actions;
    JBPost *selectedPost = self.posts[indexPath.row];
    UIColor *baseColor = [JBTeam colorForUniversity:[[self.posts[indexPath.row] limitedTeam] university]] ?: [UIColor colorWithHexString:@"#85387C"];
    __weak typeof(self) weakSelf = self;
    
    UITableViewRowAction *viewAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"View" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        [self openPostInApp:selectedPost];
        [weakSelf.tableView setEditing:NO animated:YES];
    }];

    if (selectedPost.postType == JBPostTypeTwitter)
    {
        UITableViewRowAction *favouriteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Fave" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            [self favoritePost:selectedPost];
            [weakSelf.tableView setEditing:NO animated:YES];
        }];
        
        UITableViewRowAction *retweetAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Retweet" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            [self retweetPost:selectedPost];
            [weakSelf.tableView setEditing:NO animated:YES];
        }];
        
        viewAction.backgroundColor = [baseColor colorWithBrightnessChangedBy:-10];
        favouriteAction.backgroundColor = baseColor;
        retweetAction.backgroundColor = [baseColor colorWithBrightnessChangedBy:10];
        
        actions = @[viewAction, favouriteAction, retweetAction];
    }
    else if (selectedPost.postType == JBPostTypeFacebook)
    {
        UITableViewRowAction *likeAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Like" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            [self likePost:selectedPost];
            [weakSelf.tableView setEditing:NO animated:YES];
        }];
        
        viewAction.backgroundColor = [baseColor colorWithBrightnessChangedBy:-10];
        likeAction.backgroundColor = baseColor;
        
        actions = @[viewAction, likeAction];
    }
    else
    {
        viewAction.backgroundColor = [baseColor colorWithBrightnessChangedBy:-10];
        actions = @[viewAction];
    }

    return actions;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
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

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)])
    {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - JBFeedDonateTableViewCellDelegate

- (void)didTapDonateButtonWithTeam:(JBTeam *)team
{
    if (team)
    {
        [self performSegueWithIdentifier:@"showDonationPopover" sender:team];
    }
}

#pragma mark - Twitter Helper Methods

- (void)favoritePost:(JBPost *)post
{
    ACAccountStore *accountStore = [ACAccountStore new];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error) {
        if (granted)
        {
            ACAccount *account = [[accountStore accountsWithAccountType:accountType] firstObject];
            
            if (account)
            {
                SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                        requestMethod:SLRequestMethodPOST
                                                                  URL:[NSURL URLWithString:@"https://api.twitter.com/1.1/favorites/create.json"]
                                                           parameters:@{@"id": @(post.twitter.tweetId)}];
                request.account = account;
                [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                    NSString *errorMessage = [NSHTTPURLResponse localizedStringForStatusCode:urlResponse.statusCode];
                    
                    if ([errorMessage isEqualToString:@"no error"])
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [TSMessage displayMessageWithTitle:@"Favourited Tweet!" subtitle:nil type:TSMessageTypeSuccess];
                        });
                    }
                    else
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [TSMessage displayMessageWithTitle:errorMessage subtitle:error.localizedDescription type:TSMessageTypeError];
                        });
                    }
                }];
            }
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [TSMessage displayMessageWithTitle:@"Twitter Account Access Not Granted" subtitle:@"Go into settings and allow this app to use your account" type:TSMessageTypeError];
            });
        }
    }];
}

- (void)retweetPost:(JBPost *)post
{
    ACAccountStore *accountStore = [ACAccountStore new];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error) {
        if (granted)
        {
            ACAccount *account = [[accountStore accountsWithAccountType:accountType] firstObject];
            
            if (account)
            {
                NSURL *retweetURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/1.1/statuses/retweet/%@.json", @(post.twitter.tweetId)]];
                SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodPOST URL:retweetURL parameters:nil];
                request.account = account;
                [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                    NSString *errorMessage = [NSHTTPURLResponse localizedStringForStatusCode:urlResponse.statusCode];
                    
                    if ([errorMessage isEqualToString:@"no error"])
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [TSMessage displayMessageWithTitle:@"Retweeted!" subtitle:nil type:TSMessageTypeSuccess];
                        });
                    }
                    else
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [TSMessage displayMessageWithTitle:errorMessage subtitle:error.localizedDescription type:TSMessageTypeError];
                        });
                    }
                }];
            }
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [TSMessage displayMessageWithTitle:@"Twitter Account Access Not Granted" subtitle:error.localizedDescription type:TSMessageTypeError];
            });
        }
    }];
}

- (void)openPostInApp:(JBPost *)post
{
    switch (post.postType)
    {
        case JBPostTypeCheckin:
        case JBPostTypeDonate:
        case JBPostTypeUndefined:
        case JBPostTypeLink:
            break;
        case JBPostTypeFacebook:
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"fb://"]])
            {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"fb://post/%@", @(post.facebook.facebookPostId)]]];
            }
            else
            {
                [TSMessage displayMessageWithTitle:@"Facebook App Not Installed" subtitle:@"Please install the Facebook app to open posts in" type:TSMessageTypeWarning];
            }
            break;
        case JBPostTypeInstagram:
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"instagram://"]])
            {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"instagram://media?id=%@", post.instagram.instagramMediaId]]];
            }
            else
            {
                [TSMessage displayMessageWithTitle:@"Instagram App Not Installed" subtitle:@"Please install the Instagram app to open images in" type:TSMessageTypeWarning];
            }
            break;
        case JBPostTypeTwitter:
        {
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetbot://"]])
            {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tweetbot:///status/%@", @(post.twitter.tweetId)]]];
            }
            else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitterrific://"]])
            {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"twitterrific:///tweet?id=%@", @(post.twitter.tweetId)]]];
            }
            else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter://"]])
            {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"twitter://status?id=%@", @(post.twitter.tweetId)]]];
            }
            else
            {
                [TSMessage displayMessageWithTitle:@"No Twitter App Installed" subtitle:@"Please install a Twitter app to open tweets in" type:TSMessageTypeWarning];
            }
            break;
        }
        case JBPostTypeVine:
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"vine://"]])
            {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"vine://post/%@", @1153945031292469248]]];
            }
            else
            {
                [TSMessage displayMessageWithTitle:@"Vine App Not Installed" subtitle:@"Please install the Vine app to open videos in" type:TSMessageTypeWarning];
            }
            break;
    }
}

#pragma mark - Facebook Helper Methods

- (void)likePost:(JBPost *)post
{
    ACAccountStore *accountStore = [ACAccountStore new];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    NSDictionary *readOptions = @{ACFacebookAppIdKey: @"893612184039371", ACFacebookPermissionsKey: @[@"email"], ACFacebookAudienceKey: ACFacebookAudienceEveryone};
    
    [accountStore requestAccessToAccountsWithType:accountType options:readOptions completion:^(BOOL granted, NSError *error) {
        if (granted)
        {
            NSDictionary *writeOptions = @{ACFacebookAppIdKey: @"893612184039371", ACFacebookPermissionsKey: @[@"publish_actions"], ACFacebookAudienceKey: ACFacebookAudienceEveryone};
            [accountStore requestAccessToAccountsWithType:accountType options:writeOptions completion:^(BOOL granted, NSError *error) {
                ACAccount *account = [[accountStore accountsWithAccountType:accountType] firstObject];
                
                if (account)
                {
                    NSURL *likeURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/v2.2/%@/likes", @(post.facebook.facebookPostId)]];
                    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeFacebook requestMethod:SLRequestMethodPOST URL:likeURL parameters:nil];
                    request.account = account;
                    [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                        NSString *errorMessage = [NSHTTPURLResponse localizedStringForStatusCode:urlResponse.statusCode];
                        
                        if ([errorMessage isEqualToString:@"no error"])
                        {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [TSMessage displayMessageWithTitle:@"Retweeted!" subtitle:nil type:TSMessageTypeSuccess];
                            });
                        }
                        else
                        {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [TSMessage displayMessageWithTitle:errorMessage subtitle:error.localizedDescription type:TSMessageTypeError];
                            });
                        }
                    }];
                }
                else
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [TSMessage displayMessageWithTitle:@"Facebook Account Access Not Granted" subtitle:error.localizedDescription type:TSMessageTypeError];
                    });
                }
            }];
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [TSMessage displayMessageWithTitle:@"Facebook Account Access Not Granted" subtitle:error.localizedDescription type:TSMessageTypeError];
            });
        }
    }];
}

#pragma mark - Helper Methods

// Leaving out refreshing when handling active notification because of contentOffset issues

- (void)handleApplicationDidEnterBackgroundNotification
{
    if (self.posts.count)
    {
        [self saveToArchiveObject:self.posts withKey:kPostsArchiveKey];
    }
}

- (void)updateCellTimeAgoLabel:(NSTimer *)timer
{
    NSArray *indexPathsForVisibleRows = [self.tableView indexPathsForVisibleRows];
    NSArray *visibleCells = [self.tableView visibleCells];
    
    for (int i = 0; i < visibleCells.count; i++)
    {
        if ([visibleCells[i] respondsToSelector:@selector(timeLabel)])
        {
            [visibleCells[i] timeLabel].text = [[self.posts[[indexPathsForVisibleRows[i] row]] createdTime] shortTimeAgoSinceNow];
        }
    }
}

- (void)refresh
{
//    NSUInteger numberOfNewPosts = 3;
//    
//    for (int i = 0; i < numberOfNewPosts; i++)
//    {
//        [self.posts insertObject:self.posts[self.posts.count-1-i] atIndex:0];
//    }
//    
//    CGPoint contentOffsetBefore = self.tableView.contentOffset;
//    
//    // If < -64 (when pulling down to refresh) use -64, otherwise use the current value
//    contentOffsetBefore.y = fmaxf(-[self.topLayoutGuide length], contentOffsetBefore.y);
//    
//    [self.tableView reloadData];
//    
//    // For some reason you need to get the rects before hand or the values will be wrong
//    for (int i = 0; i < numberOfNewPosts; i++)
//    {
//        [self.tableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
//    }
//    
//    contentOffsetBefore.y += [self.tableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:numberOfNewPosts inSection:0]].origin.y;
//    [self.tableView setContentOffset:contentOffsetBefore animated:YES];
    [self.refreshControl endRefreshing];
//
//    TSMessageView *messageView = [TSMessage messageWithTitle:[NSString stringWithFormat:@"%@ new posts", @(numberOfNewPosts)] subtitle:nil type:TSMessageTypeDefault];
//    messageView.duration = 1.0;
//    [TSMessage displayOrEnqueueMessage:messageView];
}

@end
