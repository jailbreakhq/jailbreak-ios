//
//  JBButton.m
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 11/02/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import "JBButton.h"

@implementation JBButton

#pragma mark - Accessors

- (void)setActiveBackgroundColor:(UIColor *)activeBackgroundColor
{
    _activeBackgroundColor = activeBackgroundColor;
    [self setBackgroundImage:[self imageWithColor:_activeBackgroundColor] forState:UIControlStateHighlighted];
}

- (void)setNormalBackgroundColor:(UIColor *)normalBackgroundColor
{
    _normalBackgroundColor = normalBackgroundColor;
    [self setBackgroundImage:[self imageWithColor:_normalBackgroundColor] forState:UIControlStateNormal];
}

- (void)setActiveTextColor:(UIColor *)activeTextColor
{
    _activeTextColor = activeTextColor;
    [self setTitleColor:_activeTextColor forState:UIControlStateHighlighted];
}

- (void)setNormalTextColor:(UIColor *)normalTextColor
{
    _normalTextColor = normalTextColor;
    [self setTitleColor:_normalTextColor forState:UIControlStateNormal];
}

- (void)setActiveBorderColor:(UIColor *)activeBorderColor
{
    _activeBorderColor = activeBorderColor;
    self.layer.borderColor = _activeBorderColor.CGColor;
    
}

- (void)setNormalBorderColor:(UIColor *)normalBorderColor
{
    _normalBorderColor = normalBorderColor;
    self.layer.borderColor = _normalBackgroundColor.CGColor;
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = _cornerRadius;
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    _borderWidth = borderWidth;
    self.layer.borderWidth = _borderWidth;
}

#pragma mark - Initializers

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        [self addTarget:self action:@selector(delay) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self addTarget:self action:@selector(delay) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        [self addTarget:self action:@selector(delay) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return self;
}

#pragma mark - Private Methods

- (void)delay
{
    [self setBackgroundImage:[self imageWithColor:self.activeBackgroundColor] forState:UIControlStateNormal];
    [self setTitleColor:self.activeTextColor forState:UIControlStateNormal];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setBackgroundImage:[self imageWithColor:self.normalBackgroundColor] forState:UIControlStateNormal];
        [self setTitleColor:self.normalTextColor forState:UIControlStateNormal];
    });
}

- (UIImage *)imageWithColor:(UIColor *)color
{
    if (!color)
    {
        return nil;
    }
    
    CGRect rect = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (ceilf(self.layer.cornerRadius))
    {
        CGPathRef clippingPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:self.layer.cornerRadius].CGPath;
        CGContextAddPath(context, clippingPath);
        CGContextClip(context);
    }
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
