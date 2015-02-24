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
#import <NSDate+DateTools.h>
#import <Accounts/Accounts.h>
#import "UIColor+JBAdditions.h"
#import <JTSImageViewController.h>
#import "JBFeedBaseTableViewCell.h"
#import "NSDictionary+JBAdditions.h"
#import "JBFeedImageTableViewCell.h"
#import "JBFeedTableViewController.h"

static NSString * const kTextCellIdentifier         = @"TextCell";
static NSString * const kInstagramCellIdentifier    = @"InstagramCell";
static NSString * const kImageCellIdentifier        = @"ImageCell";
static NSString * const kSAMBlockName               = @"Refreshing";
static NSString * const kPostsArchiveKey            = @"Posts-JBFeedTableViewController";

static const NSTimeInterval kIntervalBetweenRefreshing = 60.0;

@interface JBFeedTableViewController () <JBFeedImageTableViewCellDelegate>

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
    
    JBPost *post;
    
    post = [[JBPost alloc] initWithJSON:@{@"teamName": @"Benedict & Thomas", @"body": @"Arca was definitely a hater.", @"teamAvatar": @"https://static.jailbreakhq.org/avatars/small/team-50.png",
                                   @"network": @"Twitter", @"postId": @"569875563017576449", @"teamUniversity": @"TCD"}];
    [self.posts addObject:post];
    
    post = [[JBPost alloc] initWithJSON:@{@"teamName": @"Benedict & Thomas", @"body": @"Had a bunch of black guys in a twerk circle is probably the two releases that got me properly into techno",
                                          @"teamAvatar": @"https://static.jailbreakhq.org/avatars/small/team-50.png", @"network": @"Twitter", @"teamUniversity": @"ucd", @"postId": @"570034304950140928"}];
    [self.posts addObject:post];
    
    post = [[JBPost alloc] initWithJSON:@{@"teamName": @"Benedict & Thomas", @"body": @"Working on this British Shorthair today. #YearOfTheFat #FatFriends https://instagram.com/p/zVcJQ7LClQ/",
                                          @"teamAvatar": @"https://static.jailbreakhq.org/avatars/small/team-50.png", @"network": @"FACEBOOK", @"postId": @"1405577633076859",
                                          @"media": @"http://scontent-a.cdninstagram.com/hphotos-xaf1/t51.2885-15/e15/11015502_1399670580341952_1221936374_n.jpg", @"teamUniversity": @"nuig"}];
    [self.posts addObject:post];
    
    post = [[JBPost alloc] initWithJSON:@{@"teamName": @"Benedict & Thomas", @"body": @"Thanks so much to everyone for liking the page, we really appreciate your support and enthusiasm 😊 Looking forward to seeing all those of you who live in Dublin at our bakesale next week, and at some other fun events we have planned for the near future. However, we still need your help to raise as much money as possible for SVP and Amnesty international, so if you have any loose change rattling around at the bottom of your pockets, please direct it our way here: https://jailbreakhq.org/teams/team-74 Thanks guys x",
                                          @"teamAvatar": @"https://static.jailbreakhq.org/avatars/small/team-50.png", @"network": @"facebook", @"teamUniversity": @"ucc"}];
    [self.posts addObject:post];
    
    post = [[JBPost alloc] initWithJSON:@{@"teamName": @"Benedict & Thomas", @"teamAvatar": @"https://static.jailbreakhq.org/avatars/small/team-50.png", @"network": @"iNstagraM",
                                          @"media": @"http://scontent-b.cdninstagram.com/hphotos-xaf1/t51.2885-15/e15/10932646_593864644091568_589300573_n.jpg", @"teamUniversity": @"tcd"}];
    [self.posts addObject:post];
    
    post = [[JBPost alloc] initWithJSON:@{@"teamName": @"Benedict & Thomas", @"body": @"Ive watched so may Liam Neeson movies. Another two long days of progress.", @"teamAvatar": @"https://static.jailbreakhq.org/avatars/small/team-50.png", @"postId": @"924146301657348311_217584541", @"teamUniversity": @"UCd",
                                          @"network": @"instagram", @"media": @"http://scontent-b.cdninstagram.com/hphotos-xap1/t51.2885-15/e15/10296704_1778125709080310_1766583521_n.jpg"}];
    [self.posts addObject:post];
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
    
    if (!self.posts.count)
    {
        self.posts = [self loadFromArchiveObjectWithKey:kPostsArchiveKey];
    }
    
    [SAMRateLimit executeBlock:^{
        [self refresh];
        NSLog(@"refresh");
    } name:kSAMBlockName limit:kIntervalBetweenRefreshing];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self.timer invalidate];
    self.timer = nil;
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
        if ([self.posts[indexPath.row] postType] == JBPostTypeInstagram)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:kInstagramCellIdentifier forIndexPath:indexPath];
        }
        else
        {
            cell = [tableView dequeueReusableCellWithIdentifier:kImageCellIdentifier forIndexPath:indexPath];
        }
        
        cell.delegate = self;
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
    [self openPostInApp:self.posts[indexPath.row]];
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *actions;
    JBPost *selectedPost = self.posts[indexPath.row];
    UIColor *baseColor = [JBTeam colorForUniversity:[self.posts[indexPath.row] teamUniversity]];
    __weak typeof(self) weakSelf = self;
    
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
        
        UITableViewRowAction *replyAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Reply" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            [self openPostInApp:selectedPost];
            [weakSelf.tableView setEditing:NO animated:YES];
        }];
        
        replyAction.backgroundColor = [baseColor colorWithBrightnessChangedBy:-10];
        favouriteAction.backgroundColor = baseColor;
        retweetAction.backgroundColor = [baseColor colorWithBrightnessChangedBy:10];
        
        actions = @[replyAction, favouriteAction, retweetAction];
    }
    else if (selectedPost.postType == JBPostTypeFacebook)
    {
        UITableViewRowAction *likeAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Like" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            [self likePost:selectedPost];
            [weakSelf.tableView setEditing:NO animated:YES];
        }];
        
        likeAction.backgroundColor = baseColor;
        
        actions = @[likeAction];
    }
    else
    {
        UITableViewRowAction *fakeAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:nil handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            [weakSelf.tableView setEditing:NO animated:YES];
        }];
        
        fakeAction.backgroundColor = [UIColor clearColor];

        actions = @[fakeAction];
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
                                                           parameters:@{@"id": post.postId}];
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
                NSURL *retweetURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/1.1/statuses/retweet/%@.json", post.postId]];
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
            break;
        case JBPostTypeDonate:
            break;
        case JBPostTypeFacebook:
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"fb://"]])
            {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"fb://post/%@", post.postId]]];
            }
            else
            {
                [TSMessage displayMessageWithTitle:@"Facebook App Not Installed" subtitle:@"Please install the Facebook app to open posts in" type:TSMessageTypeWarning];
            }
            break;
        case JBPostTypeInstagram:
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"instagram://"]])
            {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"instagram://media?id=%@", post.postId]]];
            }
            else
            {
                [TSMessage displayMessageWithTitle:@"Instagram App Not Installed" subtitle:@"Please install the Instagram app to open images in" type:TSMessageTypeWarning];
            }
            break;
        case JBPostTypeLink:
            break;
        case JBPostTypeTwitter:
        {
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetbot://"]])
            {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tweetbot:///status/%@", post.postId]]];
            }
            else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitterrific://"]])
            {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"twitterrific:///tweet?id=%@", post.postId]]];
            }
            else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter://"]])
            {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"twitter://status?id=%@", post.postId]]];
            }
            else
            {
                [TSMessage displayMessageWithTitle:@"No Twitter App Installed" subtitle:@"Please install a Twitter app to open tweets in" type:TSMessageTypeWarning];
            }
            break;
        }
        case JBPostTypeVine:
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
                    NSURL *likeURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/v2.2/%@/likes", post.postId]];
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
        [visibleCells[i] timeLabel].text = [[self.posts[[indexPathsForVisibleRows[i] row]] timeCreated] shortTimeAgoSinceNow];
    }
}

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
    
    [TSMessage displayMessageWithTitle:[NSString stringWithFormat:@"%@ new posts", @(numberOfNewPosts)] subtitle:nil type:TSMessageTypeDefault];
}

@end
