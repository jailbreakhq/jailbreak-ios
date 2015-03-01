//
//  JBTeamPostsTableViewController.m
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 28/02/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import "JBPost.h"
#import <TSMessage.h>
#import <TSMessageView.h>
#import <JTSImageViewController.h>
#import "JBFeedBaseTableViewCell.h"
#import "NSDictionary+JBAdditions.h"
#import "JBTeamPostsTableViewController.h"
#import <UIScrollView+SVInfiniteScrolling.h>

static const NSUInteger kNumberOfPostsToFetchWhenRefreshing = 50;
static const NSUInteger kPostAPILimit = 50;

@interface JBTeamPostsTableViewController ()

@end

@implementation JBTeamPostsTableViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];    
    
    [[JBAPIManager manager] getServicesWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.service = [[JBService alloc] initWithJSON:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[JBAPIManager manager] getServicesWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            self.service = [[JBService alloc] initWithJSON:responseObject];
        } failure:nil];
    }];
    
    [self startLoadingIndicator];
    NSString *filtersJSONString = [@{@"teamId": @(self.team.ID)} jsonString];
    [[JBAPIManager manager] getEventsWithParameters:@{@"limit": @(kPostAPILimit), @"filters": filtersJSONString}
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
                                                [TSMessage displayMessageWithTitle:@"Failed to Fetch Posts" subtitle:operation.responseObject[@"message"] type:TSMessageTypeError];
                                                [self stopLoadingIndicator];
                                            }];
    
    // Configure Pagination
    __weak typeof(self) weakSelf = self;
    [self.tableView addInfiniteScrollingWithActionHandler:^
     {
         NSString *filtersJSONString = [@{@"teamId": @(weakSelf.team.ID), @"beforeId": @([weakSelf.posts.lastObject postId])} jsonString];
         
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

- (void)recursivelyGetEventsWithParameters:(NSDictionary *)parameters numberOfNewPostsSoFar:(NSUInteger)soFarCount untilCountIsGreaterThan:(NSUInteger)limit
{
    NSIndexPath *topRowIndexPath = [self.tableView indexPathsForVisibleRows].firstObject;
    __block NSUInteger totalCount = 0;
    
    [[JBAPIManager manager] getEventsWithParameters:parameters
                                            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                
                                                NSUInteger newCount = 0;
                                                for (NSDictionary *event in responseObject)
                                                {
                                                    if ([JBPost getPostTypeFromString:event[@"type"]] != JBPostTypeUndefined)
                                                    {
                                                        [self.posts insertObject:[[JBPost alloc] initWithJSON:event] atIndex:0];
                                                        newCount++;
                                                    }
                                                }
                                                totalCount = newCount + soFarCount;
                                                
                                                NSUInteger latestPostId = [self.posts.firstObject postId];
                                                NSString *filtersJSONString = [@{@"beforeId": @(latestPostId+1+kPostAPILimit), @"afterId": @(latestPostId)} jsonString];
                                                
                                                if (totalCount >= kNumberOfPostsToFetchWhenRefreshing || newCount < kPostAPILimit)
                                                {
                                                    [self.refreshControl endRefreshing];
                                                    [self.tableView reloadData];
                                                    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:topRowIndexPath.row+totalCount inSection:0]
                                                                          atScrollPosition:UITableViewScrollPositionBottom
                                                                                  animated:YES];
                                                    
                                                    TSMessageView *messageView = [TSMessage messageWithTitle:[NSString stringWithFormat:@"%@ New Posts", @(totalCount)] subtitle:nil type:TSMessageTypeDefault];
                                                    messageView.duration = 1.2;
                                                    [TSMessage displayOrEnqueueMessage:messageView];
                                                }
                                                else
                                                {
                                                    [self recursivelyGetEventsWithParameters:@{@"limit": @(kPostAPILimit), @"filters": filtersJSONString} numberOfNewPostsSoFar:totalCount untilCountIsGreaterThan:kNumberOfPostsToFetchWhenRefreshing];
                                                }
                                                
                                                
                                            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                
                                                [TSMessage displayMessageWithTitle:@"Failed to Fetch New Posts" subtitle:operation.responseObject[@"message"] type:TSMessageTypeError];
                                                [self.refreshControl endRefreshing];
                                                
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
    NSUInteger latestPostId = [self.posts.firstObject postId];
    NSString *filtersJSONString = [@{@"beforeId": @(latestPostId+1+kPostAPILimit), @"afterId": @(latestPostId)} jsonString];
    [self recursivelyGetEventsWithParameters:@{@"limit": @(kPostAPILimit), @"filters": filtersJSONString} numberOfNewPostsSoFar:0 untilCountIsGreaterThan:kNumberOfPostsToFetchWhenRefreshing];
}

@end
