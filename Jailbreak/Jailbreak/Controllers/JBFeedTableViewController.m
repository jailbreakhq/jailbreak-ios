//
//  JBFeedTableViewController.m
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 26/01/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import "JBPost.h"
#import "JBService.h"
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
#import "JBFeedCheckinTableViewCell.h"
#import <UIScrollView+SVInfiniteScrolling.h>

static NSString * const kSAMBlockName           = @"Refreshing";
static NSString * const kPostsArchiveKey        = @"Posts-JBFeedTableViewController";
static NSString * const kPreservedIndexPathKey  = @"IndexPath-JBFeedTableViewController";

static const NSTimeInterval kIntervalBetweenRefreshing = 60.0 * 10.0; // 10 minutes
static const NSUInteger kNumberOfPostsToFetchWhenRefreshing = 100;
static const NSUInteger kNumberOfPostsToPersist = 200;
static const NSUInteger kPostAPILimit = 50;

@interface JBFeedTableViewController ()

@property (nonatomic, weak) NSTimer *timer;
@property (nonatomic, assign, getter=isFirstLaunch) BOOL firstLaunch;

@end

@implementation JBFeedTableViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.firstLaunch = YES;
    
    // Empty /tmp where videos are stored
    for (NSString *file in [[NSFileManager defaultManager] contentsOfDirectoryAtPath:NSTemporaryDirectory() error:nil])
    {
        [[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@%@", NSTemporaryDirectory(), file] error:nil];
    }
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"hasShownIntro"])
    {
        UIViewController *introViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"JBIntroViewController"];
        introViewController.modalPresentationStyle = UIModalPresentationOverFullScreen;
        introViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        [self presentViewController:introViewController animated:YES completion:nil];
    }
    
    [[JBAPIManager manager] getServicesWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.service = [[JBService alloc] initWithJSON:responseObject];
        NSString *string = [NSString stringWithFormat:@"%@ Raised", [[self priceFormatter] stringFromNumber:@(self.service.amountRaised/100.0)]];
        self.navigationItem.title = string;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[JBAPIManager manager] getServicesWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            self.service = [[JBService alloc] initWithJSON:responseObject];
            NSString *string = [NSString stringWithFormat:@"%@ Raised", [[self priceFormatter] stringFromNumber:@(self.service.amountRaised/100.0)]];
            self.navigationItem.title = string;
        } failure:nil];
    }];
    
    self.posts = [self loadFromArchiveObjectWithKey:kPostsArchiveKey];
    
    if (!self.posts.count)
    {
        [self startLoadingIndicator];
        
        [SAMRateLimit executeBlock:^{
            [self refresh];
        } name:kSAMBlockName limit:kIntervalBetweenRefreshing];
    }
    else
    {
        if (self.posts.count > kNumberOfPostsToPersist)
        {
            [self.posts removeObjectsInRange:NSMakeRange(kNumberOfPostsToPersist, self.posts.count - kNumberOfPostsToPersist)];
        }
        
        NSDictionary *indexPathDictionary = [[NSUserDefaults standardUserDefaults] objectForKey:kPreservedIndexPathKey];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[indexPathDictionary[@"row"] unsignedIntegerValue]
                                                    inSection:[indexPathDictionary[@"section"] unsignedIntegerValue]];
        
        if (indexPath.row >= self.posts.count)
        {
            indexPath = [NSIndexPath indexPathForRow:self.posts.count-1 inSection:indexPath.section];
        }
        
        [self.tableView reloadData];
        [self.tableView scrollToRowAtIndexPath:indexPath
                              atScrollPosition:UITableViewScrollPositionTop
                                      animated:NO];
        
        [SAMRateLimit executeBlock:^{
            [self refresh];
        } name:kSAMBlockName limit:kIntervalBetweenRefreshing];
    }
    
    // Configure Pagination
    __weak typeof(self) weakSelf = self;
    [self.tableView addInfiniteScrollingWithActionHandler:^
    {
        NSString *filtersJSONString = [@{@"beforeId": @([weakSelf.posts.lastObject postId])} jsonString];

        [[JBAPIManager manager] getEventsWithParameters:@{@"limit": @(kPostAPILimit), @"filters": filtersJSONString}
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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [SAMRateLimit executeBlock:^{
        [self refresh];
    } name:kSAMBlockName limit:kIntervalBetweenRefreshing];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self.timer invalidate];
    self.timer = nil;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
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
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://jailbreakhq.org/donate/%@?iphone=true", team.slug ?: @""]]];
}

#pragma mark - Helper Methods

- (void)handleApplicationDidBecomeActiveNotification
{
    [SAMRateLimit executeBlock:^{
        [self refresh];
    } name:kSAMBlockName limit:kIntervalBetweenRefreshing];
}

- (void)handleApplicationDidEnterBackgroundNotification
{
    if (self.posts.count)
    {
        [self saveToArchiveObject:self.posts withKey:kPostsArchiveKey];
        
        NSIndexPath *indexPath = (NSIndexPath *)[self.tableView indexPathsForVisibleRows].firstObject;
        [[NSUserDefaults standardUserDefaults] setObject:@{@"row": @(indexPath.row), @"section": @(indexPath.section)} forKey:kPreservedIndexPathKey];
    }
}

- (void)recursivelyGetEventsWithParameters:(NSDictionary *)parameters numberOfNewPostsSoFar:(NSUInteger)soFarCount untilCountIsGreaterThan:(NSUInteger)limit
{
    NSIndexPath *topRowIndexPath = (NSIndexPath *)[self.tableView indexPathsForVisibleRows].firstObject;
    __block NSUInteger totalCount = 0;
    
    [[JBAPIManager manager] getEventsWithParameters:parameters
                                            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                
                                                NSUInteger newCount = 0;
                                                for (NSDictionary *event in responseObject)
                                                {
                                                    if ([JBPost getPostTypeFromString:event[@"type"]] != JBPostTypeUndefined)
                                                    {
                                                        [self.posts insertObject:[[JBPost alloc] initWithJSON:event] atIndex:newCount];
                                                        newCount++;
                                                    }
                                                }
                                                totalCount = newCount + soFarCount;
                                                
                                                NSUInteger latestPostId = [self.posts.firstObject postId];
                                                NSString *filtersJSONString = [@{@"beforeId": @(latestPostId+1+kPostAPILimit), @"afterId": @(latestPostId)} jsonString];
                                                
                                                NSUInteger indexPathRow = totalCount;
                                                indexPathRow += topRowIndexPath.row ?: -1;
                                                
                                                if (totalCount >= kNumberOfPostsToFetchWhenRefreshing || newCount < kPostAPILimit)
                                                {
                                                    [self.refreshControl endRefreshing];
                                                    [self.tableView reloadData];
                                                    
                                                    if (self.posts.count)
                                                    {
                                                        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:indexPathRow inSection:0]
                                                                              atScrollPosition:UITableViewScrollPositionBottom
                                                                                      animated:!self.isFirstLaunch];
                                                    }

                                                    self.firstLaunch = NO;
                                                    
                                                    TSMessageView *messageView = [TSMessage messageWithTitle:[NSString stringWithFormat:@"%@ New Posts", @(totalCount)] subtitle:nil type:TSMessageTypeDefault];
                                                    messageView.duration = 1.2;
                                                    [TSMessage displayOrEnqueueMessage:messageView];
                                                }
                                                else
                                                {
                                                    [self recursivelyGetEventsWithParameters:@{@"limit": @(kPostAPILimit), @"filters": filtersJSONString}
                                                                       numberOfNewPostsSoFar:totalCount
                                                                     untilCountIsGreaterThan:kNumberOfPostsToFetchWhenRefreshing];
                                                }
                                                
                                                
                                            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

                                                [TSMessage displayMessageWithTitle:@"Failed to Fetch New Posts" subtitle:operation.responseObject[@"message"] type:TSMessageTypeError];
                                                [self.refreshControl endRefreshing];
                                                self.firstLaunch = NO;
                                                
                                            }];
}

- (IBAction)didTapDonateButton:(UIBarButtonItem *)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://jailbreakhq.org/donate/?iphone=true"]]];
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

- (void)refresh
{
    [[JBAPIManager manager] getServicesWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.service = [[JBService alloc] initWithJSON:responseObject];
        NSString *string = [NSString stringWithFormat:@"%@ Raised", [[self priceFormatter] stringFromNumber:@(self.service.amountRaised/100.0)]];
        self.navigationItem.title = string;
    } failure:nil];
    
    if (self.posts.count)
    {
        NSUInteger latestPostId = [self.posts.firstObject postId];
        NSString *filtersJSONString = [@{@"beforeId": @(latestPostId+1+kPostAPILimit), @"afterId": @(latestPostId)} jsonString];
        [self recursivelyGetEventsWithParameters:@{@"limit": @(kPostAPILimit), @"filters": filtersJSONString} numberOfNewPostsSoFar:0 untilCountIsGreaterThan:kNumberOfPostsToFetchWhenRefreshing];
    }
    else
    {
        [[JBAPIManager manager] getEventsWithParameters:@{@"limit": @(kPostAPILimit)}
                                                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                    for (NSDictionary *event in responseObject)
                                                    {
                                                        if ([JBPost getPostTypeFromString:event[@"type"]] != JBPostTypeUndefined)
                                                        {
                                                            [self.posts addObject:[[JBPost alloc] initWithJSON:event]];
                                                        }
                                                    }
                                                    [self.tableView reloadData];
                                                    [self.refreshControl endRefreshing];
                                                    [self stopLoadingIndicator];
                                                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                    [TSMessage displayMessageWithTitle:@"Failed to Fetch Posts" subtitle:operation.responseObject[@"message"] type:TSMessageTypeError];
                                                    [self.refreshControl endRefreshing];
                                                    [self stopLoadingIndicator];
                                                }];
    }
}

@end
