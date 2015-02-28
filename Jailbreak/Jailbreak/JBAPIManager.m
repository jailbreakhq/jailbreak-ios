//
//  JBAPIManager.m
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 28/01/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import "JBAPIManager.h"
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>

#define BASE_URL @"https://jbapi.net"

#define SuccessBlockWithJSONOperation                           \
    ^(AFHTTPRequestOperation *operation, id responseObject) {   \
        if (success) success(operation, responseObject);        \
    }

#define FailureBlockWithJSONOperation                           \
    ^(AFHTTPRequestOperation *operation, NSError *error) {      \
        if (failure) failure(operation, error);                 \
    }

@implementation JBAPIManager

+ (instancetype)manager
{
    static JBAPIManager *sharedInstance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^ {
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (instancetype)init
{
    self = [super initWithBaseURL:[NSURL URLWithString:BASE_URL]];
    
    if (self)
    {
        [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
        self.requestSerializer = [AFJSONRequestSerializer new];
        self.responseSerializer = [AFJSONResponseSerializer new];
    }
    
    return self;
}

- (void)getServicesWithSuccess:(JBHTTPRequestSuccess)success failure:(JBHTTPRequestFailure)failure
{
    [self GET:@""
   parameters:nil
      success:SuccessBlockWithJSONOperation
      failure:FailureBlockWithJSONOperation];
}

- (void)getAllTeamsWithParameters:(NSDictionary *)parameters
                          success:(JBHTTPRequestSuccess)success
                          failure:(JBHTTPRequestFailure)failure
{
    [self GET:@"teams"
   parameters:parameters
      success:SuccessBlockWithJSONOperation
      failure:FailureBlockWithJSONOperation];
}

- (void)getTeamWithId:(NSUInteger)teamId success:(JBHTTPRequestSuccess)success failure:(JBHTTPRequestFailure)failure
{
    [self GET:[NSString stringWithFormat:@"teams/%@", @(teamId)]
   parameters:nil
      success:SuccessBlockWithJSONOperation
      failure:FailureBlockWithJSONOperation];
}

- (void)getCheckinsForTeamWithId:(NSUInteger)teamId
                         success:(JBHTTPRequestSuccess)success
                         failure:(JBHTTPRequestFailure)failure
{
    [self GET:[NSString stringWithFormat:@"teams/%lu/checkins", (unsigned long)teamId]
   parameters:nil
      success:SuccessBlockWithJSONOperation
      failure:FailureBlockWithJSONOperation];
}

- (void)getAllDonationsWithParameters:(NSDictionary *)parameters
                              success:(JBHTTPRequestSuccess)success
                              failure:(JBHTTPRequestFailure)failure
{
    [self GET:@"donations"
   parameters:parameters
      success:SuccessBlockWithJSONOperation
      failure:FailureBlockWithJSONOperation];
}

- (void)makeDonationWithParameters:(NSDictionary *)parameters
                           success:(JBHTTPRequestSuccess)success
                           failure:(JBHTTPRequestFailure)failure
{
    [self POST:@"stripe"
    parameters:parameters
       success:SuccessBlockWithJSONOperation
       failure:FailureBlockWithJSONOperation];
}

- (void)getEventsWithParameters:(NSDictionary *)parameters
                        success:(JBHTTPRequestSuccess)success
                        failure:(JBHTTPRequestFailure)failure
{
    [self GET:@"events"
   parameters:parameters
      success:SuccessBlockWithJSONOperation
      failure:FailureBlockWithJSONOperation];
}

@end
