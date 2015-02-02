//
//  JBCircularImageView.m
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 02/02/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import "JBCircularImageView.h"

@implementation JBCircularImageView

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self configure];
}

- (void)configure
{
    self.clipsToBounds = NO;
    self.layer.cornerRadius = CGRectGetWidth(self.frame) / 2.0;
    self.layer.masksToBounds = YES;
}

@end
