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

@end
