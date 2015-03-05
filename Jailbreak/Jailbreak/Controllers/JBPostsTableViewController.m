//
//  JBPostsTableViewController.m
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 28/02/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import "JBPost.h"
#import <FacebookSDK.h>
#import "JBAnnotation.h"
#import <Social/Social.h>
#import <TSMessageView.h>
#import <NSDate+DateTools.h>
#import <Accounts/Accounts.h>
#import "JBMapViewController.h"
#import "UIColor+JBAdditions.h"
#import <AFURLSessionManager.h>
#import "JBFeedLinkTableViewCell.h"
#import "JBFeedBaseTableViewCell.h"
#import "JBFeedVineTableViewCell.h"
#import "JBFeedImageTableViewCell.h"
#import "JBFeedDonateTableViewCell.h"
#import "JBFeedCheckinTableViewCell.h"
#import "JBPostsTableViewController.h"
#import "JBFacebookLoginViewController.h"

static NSString * const kTextCellIdentifier         = @"TextCell";
static NSString * const kInstagramCellIdentifier    = @"InstagramCell";
static NSString * const kImageCellIdentifier        = @"ImageCell";
static NSString * const kVineCellIdentifier         = @"VineCell";
static NSString * const kDonateCellIdentifier       = @"DonateCell";
static NSString * const kLinkCellIdentifier         = @"LinkCell";
static NSString * const kCheckinCellIdentifier      = @"CheckinCell";
static NSString * const kYouTubeCellIdentifier      = @"YouTubeCell";

@interface JBPostsTableViewController () <JBFeedImageTableViewCellDelegate, JBFeedDonateTableViewCellDelegate>

@property (nonatomic, strong) ACAccount *twitterAccount;
@property (nonatomic, strong) ACAccount *facebookAccount;
@property (nonatomic, strong) ACAccountStore *accountStore;

@end

@implementation JBPostsTableViewController

#pragma mark - Accessors

- (ACAccountStore *)accountStore
{
    if (!_accountStore) _accountStore = [ACAccountStore new];
    return _accountStore;
}

- (NSMutableArray *)posts
{
    if (!_posts) _posts = [NSMutableArray new];
    return _posts;
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
    else if ([self.posts[indexPath.row] postType] == JBPostTypeYouTube)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:kYouTubeCellIdentifier forIndexPath:indexPath];
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
        JBPost *post = self.posts[indexPath.row];
        CLLocationDistance distanceLeft = [post.checkin.location distanceFromLocation:self.service.finalLocation];
        
        JBAnnotation *annotation = [JBAnnotation new];
        annotation.customCoordinate = post.checkin.location.coordinate;
        annotation.customTitle = [post.checkin.createdTime timeAgoSinceNow];
        annotation.customSubtitle = [NSString stringWithFormat:@"%@ from Location X", [[self lengthFormatter] stringFromMeters:distanceLeft]];
        
        JBMapViewController *dvc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"JBMapViewController"];
        dvc.title = post.limitedTeam.name;
        dvc.annotations = @[annotation];
        
        [self.navigationController pushViewController:dvc animated:YES];
    }
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *actions;
    JBPost *selectedPost = self.posts[indexPath.row];
    UIColor *baseColor = [JBTeam colorForUniversity:[[self.posts[indexPath.row] limitedTeam] university]] ?: [UIColor colorWithHexString:@"#85387C"];
    __weak typeof(self) weakSelf = self;
    
    UITableViewRowAction *dummyAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        [weakSelf.tableView setEditing:NO animated:YES];
    }];
    dummyAction.backgroundColor = [UIColor clearColor];
    
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
        
        likeAction.backgroundColor = [baseColor colorWithBrightnessChangedBy:-10];
        
        actions = @[likeAction];
    }
    else if (selectedPost.postType == JBPostTypeInstagram)
    {
        viewAction.backgroundColor = [baseColor colorWithBrightnessChangedBy:-10];
        actions = @[viewAction];
    }
    else
    {
        actions = @[dummyAction];
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
        height = 10 + 22 + 2 + 10 + ceilf((width/16.0)*9.0) + 10;
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
    else if ([cellIdentifier isEqualToString:kYouTubeCellIdentifier])
    {
        NSString *text = post.youtube.youTubeDescription;
        
        width -= (65 + 10);
        height = 10 + 22 + 2 + 10 + ceilf((width/16.0)*9.0) + 10;
        height += [self heightForLabelWithText:text maxHeight:CGFLOAT_MAX width:width font:font];
    }
    
    height += 5; // hacky hack hack
    
    return height;
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
    else if (post.postType == JBPostTypeYouTube)
    {
        cellIdentifier = kYouTubeCellIdentifier;
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

#pragma mark - Twitter and Facebook API Methods

- (void)favoritePost:(JBPost *)post
{
    [self getTwitterAccountWithCompletionHandler:^(ACAccount *twitterAccount) {
        if (twitterAccount)
        {
            NSURL *favoriteRequestURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/1.1/favorites/create.json?id=%@", @(post.twitter.tweetId)]];
            SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                    requestMethod:SLRequestMethodPOST
                                                              URL:favoriteRequestURL
                                                       parameters:nil];
            request.account = twitterAccount;
            
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
    }];
}

- (void)retweetPost:(JBPost *)post
{
    [self getTwitterAccountWithCompletionHandler:^(ACAccount *twitterAccount) {
        if (twitterAccount)
        {
            NSURL *retweetURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/1.1/statuses/retweet/%@.json", @(post.twitter.tweetId)]];
            SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodPOST URL:retweetURL parameters:nil];
            request.account = twitterAccount;
            
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
    }];
}

- (void)getTwitterAccountWithCompletionHandler:(void (^)(ACAccount *twitterAccount))completionHandler
{
    if (self.twitterAccount)
    {
        completionHandler(self.twitterAccount);
    }
    else
    {
        ACAccountType *accountType = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
        
        [self.accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error) {
            if (granted)
            {
                self.twitterAccount = [self.accountStore accountsWithAccountType:accountType].firstObject;
                
                if (self.twitterAccount)
                {
                    completionHandler(self.twitterAccount);
                }
                else
                {
                    completionHandler(nil);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [TSMessage displayMessageWithTitle:@"No Twitter Account Found" subtitle:@"Please go into settings and log into Twitter" type:TSMessageTypeWarning];
                    });
                }
            }
            else
            {
                completionHandler(nil);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [TSMessage displayMessageWithTitle:@"Twitter Account Access Not Granted" subtitle:@"Go into settings and allow this app to use your account" type:TSMessageTypeError];
                });
            }
        }];
    }
}

#pragma mark - Facebook Helper Methods

- (void)likePost:(JBPost *)post
{
    if ([FBSession openActiveSessionWithAllowLoginUI:NO])
    {
        if ([self facebookSessionHasRequiredPermissions:@[@"publish_actions", @"public_profile"]])
        {
            [FBRequestConnection startWithGraphPath:[NSString stringWithFormat:@"/%@/likes", post.facebook.facebookPostId]
                                         parameters:nil
                                         HTTPMethod:@"POST"
                                  completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                      if (!error)
                                      {
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              [TSMessage displayMessageWithTitle:@"Facebook Post Liked 👍" subtitle:nil type:TSMessageTypeSuccess];
                                          });
                                      }
                                      else
                                      {
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              [TSMessage displayMessageWithTitle:@"Oops" subtitle:error.localizedFailureReason type:TSMessageTypeError];
                                          });
                                      }
                                  }];
        }
        else
        {
            // Get Publish Permission
            [[FBSession activeSession] requestNewPublishPermissions:@[@"publish_actions"]
                                                    defaultAudience:FBSessionDefaultAudienceEveryone
                                                  completionHandler:^(FBSession *session, NSError *error) {
                                                      if (session.state == FBSessionStateOpenTokenExtended)
                                                      {
                                                          [FBRequestConnection startWithGraphPath:[NSString stringWithFormat:@"/%@/likes", post.facebook.facebookPostId]
                                                                                       parameters:nil
                                                                                       HTTPMethod:@"POST"
                                                                                completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                                                                    if (!error)
                                                                                    {
                                                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                                                            [TSMessage displayMessageWithTitle:@"Facebook Post Liked 👍" subtitle:nil type:TSMessageTypeSuccess];
                                                                                        });
                                                                                    }
                                                                                    else
                                                                                    {
                                                                                        NSLog(@"%@", [result description]);
                                                                                        
                                                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                                                            [TSMessage displayMessageWithTitle:@"Oops" subtitle:error.localizedFailureReason type:TSMessageTypeError];
                                                                                        });
                                                                                    }
                                                                                }];
                                                      }
                                                      else
                                                      {
                                                          dispatch_async(dispatch_get_main_queue(), ^{
                                                              [TSMessage displayMessageWithTitle:@"Publish Permission Not Granted" subtitle:@"We need this permission to like posts. Try again and grant access this time." type:TSMessageTypeError];
                                                          });
                                                      }
                                                  }];
        }
    }
    else
    {
        // Present login view controller
        JBFacebookLoginViewController *loginViewController = (JBFacebookLoginViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"JBFacebookLoginViewController"];
        loginViewController.post = post;
        [self presentViewController:loginViewController animated:YES completion:nil];
    }
}

- (BOOL)facebookSessionHasRequiredPermissions:(NSArray *)requiredPermissions
{
    NSArray *permissions = [FBSession activeSession].permissions;
    
    for (NSString *permission in requiredPermissions)
    {
        if (![permissions containsObject:permission]) return NO;
    }
    
    return YES;
}

#pragma mark - Helper Methods

- (void)openPostInApp:(JBPost *)post
{
    switch (post.postType)
    {
        case JBPostTypeCheckin:
        case JBPostTypeDonate:
        case JBPostTypeVine:
        case JBPostTypeUndefined:
        case JBPostTypeLink:
        case JBPostTypeFacebook:
        case JBPostTypeYouTube:
            break;
        case JBPostTypeInstagram:
            if (!post.instagram.instagramMediaId) return;
            
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
    }
}

- (NSLengthFormatter *)lengthFormatter
{
    static NSLengthFormatter *_lengthFormater = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _lengthFormater = [[NSLengthFormatter alloc] init];
        [_lengthFormater.numberFormatter setLocale:[NSLocale currentLocale]];
        _lengthFormater.numberFormatter.maximumFractionDigits = 0;
    });
    
    return _lengthFormater;
}

@end
