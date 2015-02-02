//
//  TestViewController.m
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 01/02/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import "TestViewController.h"
#import "JBAPIManager.h"
#import "JBTeam.h"
#import "JBCheckin.h"
#import "JBDonation.h"
#import "UIImageView+WebCacheWithProgress.h"

@interface TestViewController ()

@property (nonatomic, strong) NSMutableArray *teams;

@property (nonatomic, weak) IBOutlet UIImageView *imageView;

@end

@implementation TestViewController

- (NSMutableArray *)teams
{
    if (!_teams) _teams = [NSMutableArray new];
    return _teams;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[JBAPIManager manager] getAllTeamsWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        for (NSDictionary *dict in responseObject)
        {
            [self.teams addObject:[[JBTeam alloc] initWithJSON:dict]];
        }
        
        [self.imageView sd_setImageWithProgressAndURL:[self.teams.firstObject avatarURL]];
        
        NSLog(@"%@ teams", @(self.teams.count));
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", operation.responseObject[@"message"]);
    }];
}

- (void)handleApplicationDidBecomeActiveNotification
{
    self.teams = [self loadFromArchiveObjectWithKey:@"Teams"];
}

- (void)handleApplicationDidEnterBackgroundNotification
{
    [self saveToArchiveObject:self.teams withKey:@"Teams"];
}

@end
