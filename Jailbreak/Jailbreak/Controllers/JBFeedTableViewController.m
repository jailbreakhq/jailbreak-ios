//
//  JBFeedTableViewController.m
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 26/01/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import "JBPost.h"
#import "JBDonation.h"
#import "JBAnnotation.h"
#import <SAMRateLimit.h>
#import <Social/Social.h>
#import <TSMessageView.h>
#import <NSDate+DateTools.h>
#import <Accounts/Accounts.h>
#import "JBMapViewController.h"
#import "UIColor+JBAdditions.h"
#import <AFURLSessionManager.h>
#import <JTSImageViewController.h>
#import "JBFeedLinkTableViewCell.h"
#import "JBFeedBaseTableViewCell.h"
#import "JBFeedVineTableViewCell.h"
#import "NSDictionary+JBAdditions.h"
#import "JBFeedImageTableViewCell.h"
#import "JBFeedDonateTableViewCell.h"
#import "JBFeedTableViewController.h"
#import "JBPostTableViewController.h"
#import "JBFeedCheckinTableViewCell.h"
#import "JBDonatePopoverViewController.h"
#import <UIScrollView+SVInfiniteScrolling.h>

static NSString * const kTextCellIdentifier         = @"TextCell";
static NSString * const kInstagramCellIdentifier    = @"InstagramCell";
static NSString * const kImageCellIdentifier        = @"ImageCell";
static NSString * const kVineCellIdentifier         = @"VineCell";
static NSString * const kDonateCellIdentifier       = @"DonateCell";
static NSString * const kLinkCellIdentifier         = @"LinkCell";
static NSString * const kCheckinCellIdentifier      = @"CheckinCell";
static NSString * const kSAMBlockName               = @"Refreshing";
static NSString * const kPostsArchiveKey            = @"Posts-JBFeedTableViewController";

static const NSTimeInterval kIntervalBetweenRefreshing = 60.0;
static const NSUInteger kNumberOfPostsToFetchWhenRefreshing = 100;


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
    
    // Configure Pagination
    __weak typeof(self) weakSelf = self;
    [self.tableView addInfiniteScrollingWithActionHandler:^
    {
        NSString *filtersJSONString = [@{@"beforeId": @([weakSelf.posts.lastObject postId])} jsonString];

        [[JBAPIManager manager] getEventsWithParameters:@{@"limit": @20, @"filters": filtersJSONString}
                                                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                    
                                                    NSMutableArray *rows = [NSMutableArray new];
                                                    for (NSDictionary *event in responseObject)
                                                    {
                                                        if ([JBPost getPostTypeFromString:event[@"type"]] != JBPostTypeUndefined)
                                                        {
                                                            [weakSelf.posts addObject:[[JBPost alloc] initWithJSON:event]];
                                                            [rows addObject:[NSIndexPath indexPathForRow:weakSelf.posts.count-1 inSection:0]];
                                                        }
                                                    }
                                                    
                                                    [weakSelf.tableView insertRowsAtIndexPaths:rows withRowAnimation:UITableViewRowAnimationLeft];
                                                    [weakSelf.tableView.infiniteScrollingView stopAnimating];
                                                    
                                                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                    
                                                    [TSMessage displayMessageWithTitle:@"Oops" subtitle:operation.responseObject[@"message"] type:TSMessageTypeError];
                                                    [weakSelf.tableView.infiniteScrollingView stopAnimating];
                                                
                                                }];
    }];
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
    else if ([self.posts[indexPath.row] postType] == JBPostTypeCheckin)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:kCheckinCellIdentifier forIndexPath:indexPath];
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
    if ([self.posts[indexPath.row] postType] == JBPostTypeCheckin)
    {
        JBAnnotation *annotation = [JBAnnotation new];
        annotation.customCoordinate = [[self.posts[indexPath.row] checkin] location].coordinate;
        annotation.customTitle = [[[self.posts[indexPath.row] checkin] createdTime] timeAgoSinceNow];
        annotation.customSubtitle = @"(coming soon)km to go";
        
        JBMapViewController *dvc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"JBMapViewController"];
        dvc.title = @"Map";
        dvc.annotations = @[annotation];
        
        [self.navigationController pushViewController:dvc animated:YES];
    }
    else if ([self.posts[indexPath.row] postType] == JBPostTypeVine)
    {
        JBFeedVineTableViewCell *cell = (JBFeedVineTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];        
        [cell playOrStopVine];
    }
    else
    {
        [self performSegueWithIdentifier:@"showPost" sender:indexPath];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height;
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    UIFont *font = [UIFont fontWithName:@"AvenirNext-Regular" size:15.0];
    JBPost *post = self.posts[indexPath.row];
    NSString *cellIdentifier = [self cellIdentifierForPost:post];
    
    if ([cellIdentifier isEqualToString:kTextCellIdentifier])
    {
        NSString *text = post.twitter.tweetBodyPlain ?: post.facebook.facebookPostBody;

        width -= (65 + 10);
        height = 10 + 22 + 2 + 10;
        height += [self heightForLabelWithText:text maxHeight:CGFLOAT_MAX width:width font:font];
    }
    else if ([cellIdentifier isEqualToString:kDonateCellIdentifier])
    {
        width -= (20 + 20);
        height = 20 + 80 + 10 + 22 + 2 + 10 + 45 + 20;
        height += [self heightForLabelWithText:post.donate.donateDescription maxHeight:CGFLOAT_MAX width:width font:font];
    }
    else if ([cellIdentifier isEqualToString:kImageCellIdentifier])
    {
        NSString *text = post.twitter.tweetBodyPlain ?: post.facebook.facebookPostBody;

        width -= (65 + 10);
        height = 10 + 22 + 2 + 10 + ceilf((width/30.0)*17.0) + 10;
        height += [self heightForLabelWithText:text maxHeight:CGFLOAT_MAX width:width font:font];
    }
    else if ([cellIdentifier isEqualToString:kInstagramCellIdentifier])
    {
        width -= (65 + 10);
        height = 10 + 22 + 2 + 10 + width + 10;
        height += [self heightForLabelWithText:post.instagram.instagramDescription maxHeight:CGFLOAT_MAX width:width font:font];
    }
    else if ([cellIdentifier isEqualToString:kVineCellIdentifier])
    {
        width -= (65 + 10);
        height = 10 + 22 + 2 + 10 + width + 10;
        height += [self heightForLabelWithText:post.vine.vineDescription maxHeight:CGFLOAT_MAX width:width font:font];
    }
    else if ([cellIdentifier isEqualToString:kCheckinCellIdentifier])
    {
        width -= (65 + 10);
        height = 10 + 22 + 2 + 10 + (width / 4.0) + 5 + 20 + 10;
        height += [self heightForLabelWithText:post.checkin.status maxHeight:CGFLOAT_MAX width:width font:font];
    }
    else if ([cellIdentifier isEqualToString:kLinkCellIdentifier])
    {
        width -= (20 + 20);
        height = 20 + width + 10 + 10 + 20 + 45;
        height += [self heightForLabelWithText:post.link.linkDescription maxHeight:CGFLOAT_MAX width:width font:font];
    }
    
    height += 5; // hacky hack hack
    
    return height;
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
                NSURL *requestURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/1.1/favorites/create.json?id=%@", @(post.twitter.tweetId)]];
                SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                        requestMethod:SLRequestMethodPOST
                                                                  URL:requestURL
                                                           parameters:nil];
                request.account = account;
                [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                    NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
                    NSString *errorMessage = [response[@"errors"] firstObject][@"message"];
                    
                    if (errorMessage)
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [TSMessage displayMessageWithTitle:@"Oops" subtitle:errorMessage type:TSMessageTypeError];
                        });
                    }
                    else
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [TSMessage displayMessageWithTitle:[NSString stringWithFormat:@"Favourited @%@'s Tweet!", post.twitter.twitterUsername] subtitle:nil type:TSMessageTypeSuccess];
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
                    NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
                    NSString *errorMessage = [response[@"errors"] firstObject][@"message"];
                    
                    if (errorMessage)
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [TSMessage displayMessageWithTitle:@"Oops" subtitle:errorMessage type:TSMessageTypeError];
                        });
                    }
                    else
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [TSMessage displayMessageWithTitle:[NSString stringWithFormat:@"Retweeted @%@'s Tweet!", post.twitter.twitterUsername] subtitle:nil type:TSMessageTypeSuccess];
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

#pragma mark - Dynamic Cell Height Methods

- (CGFloat)heightForLabelWithText:(NSString *)text maxHeight:(CGFloat)maxHeight width:(CGFloat)width font:(UIFont *)font
{
    CGFloat height = [text boundingRectWithSize:CGSizeMake(width, maxHeight)
                              options:NSStringDrawingUsesLineFragmentOrigin
                           attributes:@{NSFontAttributeName: font}
                              context:nil].size.height;
    
    height = ceilf(height);
    height = fminf(height, maxHeight);
    
    return height;
}

- (NSString *)cellIdentifierForPost:(JBPost *)post
{
    NSString *cellIdentifier;
    
    if (post.postType == JBPostTypeLink)
    {
        cellIdentifier = kLinkCellIdentifier;
    }
    else if (post.containsThumbnail)
    {
        if (post.postType == JBPostTypeInstagram)
        {
            cellIdentifier = kInstagramCellIdentifier;
        }
        else if (post.postType == JBPostTypeVine)
        {
            cellIdentifier = kVineCellIdentifier;
        }
        else
        {
            cellIdentifier = kImageCellIdentifier;
        }
    }
    else if (post.postType == JBPostTypeDonate)
    {
        cellIdentifier = kDonateCellIdentifier;
    }
    else if (post.postType == JBPostTypeCheckin)
    {
        cellIdentifier = kCheckinCellIdentifier;
    }
    else
    {
        cellIdentifier = kTextCellIdentifier;
    }
    
    return cellIdentifier;
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

- (void)recursivelyGetEventsWithParameters:(NSDictionary *)parameters numberOfNewPostsSoFar:(NSUInteger)soFarCount untilCountIsGreaterThan:(NSUInteger)limit
{
    NSIndexPath *topRowIndexPath = [self.tableView indexPathsForVisibleRows].firstObject;
    __block NSUInteger totalCount = soFarCount;
    
    [[JBAPIManager manager] getEventsWithParameters:parameters
                                            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                
                                                for (NSDictionary *event in responseObject)
                                                {
                                                    if ([JBPost getPostTypeFromString:event[@"type"]] != JBPostTypeUndefined)
                                                    {
                                                        [self.posts insertObject:[[JBPost alloc] initWithJSON:event] atIndex:0];
                                                        totalCount++;
                                                    }
                                                }
                                                
                                                NSUInteger latestPostId = [self.posts.firstObject postId];
                                                NSString *filtersJSONString = [@{@"beforeId": @(latestPostId+1+20), @"afterId": @(latestPostId)} jsonString];
                                                
                                                if (totalCount > kNumberOfPostsToFetchWhenRefreshing || totalCount == soFarCount)
                                                {
                                                    [self.refreshControl endRefreshing];
                                                    [self.tableView reloadData];
                                                    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:topRowIndexPath.row+totalCount inSection:0]
                                                                          atScrollPosition:UITableViewScrollPositionTop
                                                                                  animated:NO];
                                                    
                                                    TSMessageView *messageView = [TSMessage messageWithTitle:[NSString stringWithFormat:@"%@ New Posts", @(totalCount)] subtitle:nil type:TSMessageTypeDefault];
                                                    messageView.duration = 1.2;
                                                    [TSMessage displayOrEnqueueMessage:messageView];
                                                }
                                                else
                                                {
                                                    [self recursivelyGetEventsWithParameters:@{@"filters": filtersJSONString} numberOfNewPostsSoFar:totalCount untilCountIsGreaterThan:kNumberOfPostsToFetchWhenRefreshing];
                                                }
                                                
                                                
                                            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

                                                [TSMessage displayMessageWithTitle:@"Oops" subtitle:operation.responseObject[@"message"] type:TSMessageTypeError];
                                                [self.refreshControl endRefreshing];
                                                
                                            }];
}

- (void)refresh
{
    NSUInteger latestPostId = [self.posts.firstObject postId];
    NSString *filtersJSONString = [@{@"beforeId": @(latestPostId+1+20), @"afterId": @(latestPostId)} jsonString];
    [self recursivelyGetEventsWithParameters:@{@"filters": filtersJSONString} numberOfNewPostsSoFar:0 untilCountIsGreaterThan:kNumberOfPostsToFetchWhenRefreshing];
}

@end
