//
//  JBPostDonate.h
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 26/02/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import "JBTeam.h"
#import <Foundation/Foundation.h>

@interface JBPostDonate : NSObject <NSCoding>

@property (nonatomic, strong) NSString *donateDescription;
@property (nonatomic, strong) NSString *buttonText;
@property (nonatomic, assign) NSUInteger teamId; // optional
@property (nonatomic, strong) JBTeam *limitedTeam; // optional

- (instancetype)initWithJSON:(NSDictionary *)json;

@end
