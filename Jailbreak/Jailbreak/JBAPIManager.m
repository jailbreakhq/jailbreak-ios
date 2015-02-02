//
//  JBAPIManager.m
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 28/01/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import "JBAPIManager.h"
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>

#define BASE_URL @"http://private-anon-5ab11e309-jailbreakapi.apiary-mock.com/"

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
    }
    
    return self;
}

- (void)getAllTeamsWithSuccess:(HTTPRequestSuccess)success
                       failure:(HTTPRequestFailure)failure
{
    [self GET:[NSString stringWithFormat:@"teams"]
   parameters:nil
      success:SuccessBlockWithJSONOperation
      failure:FailureBlockWithJSONOperation];

}

- (void)getCheckinsForTeamWithId:(NSUInteger)teamId
                         success:(HTTPRequestSuccess)success
                         failure:(HTTPRequestFailure)failure
{
    [self GET:[NSString stringWithFormat:@"teams/%lu/checkins", (unsigned long)teamId]
   parameters:nil
      success:SuccessBlockWithJSONOperation
      failure:FailureBlockWithJSONOperation];
}

- (void)getAllDonationsWithParameters:(NSDictionary *)parameters
                              success:(HTTPRequestSuccess)success
                              failure:(HTTPRequestFailure)failure
{
    [self GET:@"donations"
   parameters:parameters
      success:SuccessBlockWithJSONOperation
      failure:FailureBlockWithJSONOperation];
}

@end
