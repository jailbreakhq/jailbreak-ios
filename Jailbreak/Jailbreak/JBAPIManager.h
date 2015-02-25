//
//  JBAPIManager.h
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 28/01/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"

typedef void (^HTTPRequestSuccess)(AFHTTPRequestOperation *operation, id responseObject);
typedef void (^HTTPRequestFailure)(AFHTTPRequestOperation *operation, NSError *error);

@interface JBAPIManager : AFHTTPRequestOperationManager

- (void)getServicesWithSuccess:(HTTPRequestSuccess)success
                       failure:(HTTPRequestFailure)failure;

- (void)getAllTeamsWithParameters:(NSDictionary *)parameters
                          success:(HTTPRequestSuccess)success
                          failure:(HTTPRequestFailure)failure;

- (void)getTeamWithId:(NSUInteger)teamId
              success:(HTTPRequestSuccess)success
              failure:(HTTPRequestFailure)failure;

- (void)getCheckinsForTeamWithId:(NSUInteger)teamId
                         success:(HTTPRequestSuccess)success
                         failure:(HTTPRequestFailure)failure;

- (void)getAllDonationsWithParameters:(NSDictionary *)parameters
                              success:(HTTPRequestSuccess)success
                              failure:(HTTPRequestFailure)failure;

- (void)makeDonationWithParameters:(NSDictionary *)parameters
                           success:(HTTPRequestSuccess)success
                           failure:(HTTPRequestFailure)failure;

- (void)getEventsWithParameters:(NSDictionary *)parameters
                        success:(HTTPRequestSuccess)success
                        failure:(HTTPRequestFailure)failure;


@end
