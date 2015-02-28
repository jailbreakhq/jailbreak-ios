//
//  JBAPIManager.h
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 28/01/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"

typedef void (^JBHTTPRequestSuccess)(AFHTTPRequestOperation *operation, id responseObject);
typedef void (^JBHTTPRequestFailure)(AFHTTPRequestOperation *operation, NSError *error);

@interface JBAPIManager : AFHTTPRequestOperationManager

- (void)getServicesWithSuccess:(JBHTTPRequestSuccess)success
                       failure:(JBHTTPRequestFailure)failure;

- (void)getAllTeamsWithParameters:(NSDictionary *)parameters
                          success:(JBHTTPRequestSuccess)success
                          failure:(JBHTTPRequestFailure)failure;

- (void)getTeamWithId:(NSUInteger)teamId
              success:(JBHTTPRequestSuccess)success
              failure:(JBHTTPRequestFailure)failure;

- (void)getCheckinsForTeamWithId:(NSUInteger)teamId
                         success:(JBHTTPRequestSuccess)success
                         failure:(JBHTTPRequestFailure)failure;

- (void)getAllDonationsWithParameters:(NSDictionary *)parameters
                              success:(JBHTTPRequestSuccess)success
                              failure:(JBHTTPRequestFailure)failure;

- (void)makeDonationWithParameters:(NSDictionary *)parameters
                           success:(JBHTTPRequestSuccess)success
                           failure:(JBHTTPRequestFailure)failure;

- (void)getEventsWithParameters:(NSDictionary *)parameters
                        success:(JBHTTPRequestSuccess)success
                        failure:(JBHTTPRequestFailure)failure;


@end
