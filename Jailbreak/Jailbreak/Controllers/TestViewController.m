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

@interface TestViewController ()

@property (nonatomic, strong) NSMutableArray *teams;
@property (nonatomic, strong) NSMutableArray *checkins;
@property (nonatomic, strong) NSMutableArray *donations;

@end

@implementation TestViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.teams = [NSMutableArray new];
    self.checkins = [NSMutableArray new];
    self.donations = [NSMutableArray new];
    
    NSLog(@"viewDidLoad");
    
    NSLog(@"~%@~", @(self.teams.count));
    
    [[JBAPIManager manager] getAllTeamsWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        for (NSDictionary *dict in responseObject)
        {
            [self.teams addObject:[[JBTeam alloc] initWithJSON:dict]];
        }
        
        NSLog(@"%@ teams", @(self.teams.count));
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", operation.responseObject[@"message"]);
    }];
    
    [[JBAPIManager manager] getCheckinsForTeamWithId:7
                                             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                 for (NSDictionary *dict in responseObject)
                                                 {
                                                     [self.checkins addObject:[[JBCheckin alloc] initWithJSON:dict]];
                                                 }
                                                 
                                                 NSLog(@"%@ checkins", @(self.checkins.count));
                                             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                 NSLog(@"%@", operation.responseObject[@"message"]);
                                             }];
    
    [[JBAPIManager manager] getAllDonationsWithParameters:@{@"limit": @10}
                                                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                      for (NSDictionary *dict in responseObject)
                                                      {
                                                          [self.donations addObject:[[JBDonation alloc] initWithJSON:dict]];
                                                      }
                                                      
                                                      NSLog(@"%@ donations", @(self.donations.count));
                                                  }
                                                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                      NSLog(@"%@", operation.responseObject[@"message"]);
                                                  }];
}

- (void)handleApplicationDidBecomeActiveNotification
{
    self.teams = [self loadFromArchiveObjectWithKey:@"Teams"];
    NSLog(@"%@", @(self.teams.count));
}

- (void)handleApplicationDidEnterBackgroundNotification
{
    [self saveToArchiveObject:self.teams withKey:@"Teams"];
}

@end
