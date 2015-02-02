//
//  JBBaseViewController.m
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 26/01/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import "JBBaseViewController.h"

@interface JBBaseViewController ()

- (NSString *)pathForArchivedFileWithKey:(NSString *)key;

@end

@implementation JBBaseViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

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
}

#pragma mark - Public Methods

- (void)handleApplicationDidEnterBackgroundNotification {}
- (void)handleApplicationDidBecomeActiveNotification {}

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
