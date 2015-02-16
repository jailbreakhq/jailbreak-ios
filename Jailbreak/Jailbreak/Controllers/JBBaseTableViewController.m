//
//  JBBaseTableViewController.m
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 26/01/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import "JBBaseTableViewController.h"

@interface JBBaseTableViewController ()

@end

@implementation JBBaseTableViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Remove separators for empty cells
    self.tableView.tableFooterView = [UIView new];
    
    self.loadingIndicatorView = [[RTSpinKitView alloc] initWithStyle:RTSpinKitViewStyleWave];
    self.loadingIndicatorView.hidesWhenStopped = YES;
    self.loadingIndicatorView.spinnerSize = 50.0; // default is 37.0
    self.loadingIndicatorView.translatesAutoresizingMaskIntoConstraints = NO;
    self.loadingIndicatorView.color = [UIColor whiteColor];
    [self.loadingIndicatorView stopAnimating];
    
    self.tableView.backgroundView = [UIView new];
    [self.tableView.backgroundView addSubview:self.loadingIndicatorView];
    [self.tableView.backgroundView addConstraint:[NSLayoutConstraint constraintWithItem:self.loadingIndicatorView
                                                                              attribute:NSLayoutAttributeCenterX
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:self.tableView.backgroundView
                                                                              attribute:NSLayoutAttributeCenterX
                                                                             multiplier:1.0
                                                                               constant:0.0]];
    
    [self.tableView.backgroundView addConstraint:[NSLayoutConstraint constraintWithItem:self.loadingIndicatorView
                                                                              attribute:NSLayoutAttributeCenterY
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:self.tableView.backgroundView
                                                                              attribute:NSLayoutAttributeCenterY
                                                                             multiplier:1.0
                                                                               constant:0.0]];

    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleApplicationDidEnterBackgroundNotification)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleApplicationDidEnterBackgroundNotification)
                                                 name:UIApplicationWillTerminateNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleApplicationDidBecomeActiveNotification)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
    self.refreshControl = [UIRefreshControl new];
    [self.refreshControl addTarget:self
                            action:@selector(refresh)
                  forControlEvents:UIControlEventValueChanged];
}

#pragma mark - Public Methods

- (void)handleApplicationDidEnterBackgroundNotification {}
- (void)handleApplicationDidBecomeActiveNotification {}
- (void)refresh {}

- (void)startLoadingIndicator
{
    [self.loadingIndicatorView startAnimating];
}

- (void)stopLoadingIndicator
{
    [self.loadingIndicatorView stopAnimating];
}

- (id)loadFromArchiveObjectWithKey:(NSString *)key
{
    NSString *path = [self pathForArchivedFileWithKey:key];
    NSDictionary *rootObject = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    
    if (rootObject[key])
    {
        NSLog(@"loaded %@", key);
        return rootObject[key];
    }
    else
    {
        NSLog(@"Failed to load %@", key);
        return nil;
    }
}

- (void)saveToArchiveObject:(id)object withKey:(NSString *)key
{
    NSString *path = [self pathForArchivedFileWithKey:key];
    BOOL success = [NSKeyedArchiver archiveRootObject:@{key: object} toFile:path];
    NSLog(@"saveDataToDisk: %@ @ %@", @(success), path);
}

#pragma mark - Private Methods

- (NSString *)pathForArchivedFileWithKey:(NSString *)key
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *folderPath = [@"~/Library/Serialize" stringByExpandingTildeInPath];
    
    if (![fileManager fileExistsAtPath:folderPath])
    {
        [fileManager createDirectoryAtPath:folderPath withIntermediateDirectories:NO attributes:nil error:nil];
    }
    
    return [folderPath stringByAppendingString:[NSString stringWithFormat:@"/%@", key]];
}

@end
