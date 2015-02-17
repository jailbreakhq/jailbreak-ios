//
//  JBButton.h
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 11/02/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JBButton : UIButton

// Active == Highlighted | Selected
@property (nonatomic, strong) IBInspectable UIColor *activeBackgroundColor;
@property (nonatomic, strong) IBInspectable UIColor *activeTextColor;
@property (nonatomic, strong) IBInspectable UIColor *activeBorderColor;

@property (nonatomic, strong) IBInspectable UIColor *normalBackgroundColor;
@property (nonatomic, strong) IBInspectable UIColor *normalTextColor;
@property (nonatomic, strong) IBInspectable UIColor *normalBorderColor;

@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;
@property (nonatomic, assign) IBInspectable CGFloat borderWidth;

@end
