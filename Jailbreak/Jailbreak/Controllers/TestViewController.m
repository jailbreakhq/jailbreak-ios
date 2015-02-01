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

@interface TestViewController ()

@property (nonatomic, strong) NSMutableArray *teams;

@end

@implementation TestViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.teams = [NSMutableArray new];
    
    [[JBAPIManager manager] getAllTeamsWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        for (NSDictionary *dict in responseObject)
        {
            [self.teams addObject:[[JBTeam alloc] initWithJSON:dict]];
        }
        
        NSLog(@"%@", [self.teams.firstObject description]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", operation.responseObject[@"message"]);
    }];
}

@end
