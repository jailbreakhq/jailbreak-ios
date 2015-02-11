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

- (void)setHighlightedBackgroundColor:(UIColor *)highlightedBackgroundColor
{
    _highlightedBackgroundColor = highlightedBackgroundColor;
    [self setBackgroundImage:[self backgroundImageWithColor:_highlightedBackgroundColor] forState:UIControlStateHighlighted];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    _backgroundColor = backgroundColor;
    UIImage *backgroundImage = _backgroundColor ? [self backgroundImageWithColor:_backgroundColor] : nil;
    [self setBackgroundImage:backgroundImage forState:UIControlStateNormal];
}

- (void)setHighlightedTextColor:(UIColor *)highlightedTextColor
{
    _highlightedTextColor = highlightedTextColor;
    [self setTitleColor:_highlightedTextColor forState:UIControlStateHighlighted];
}

- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    [self setTitleColor:_textColor forState:UIControlStateNormal];
}

- (void)setHighlightedBorderColor:(UIColor *)highlightedBorderColor
{
    _highlightedBorderColor = highlightedBorderColor;
    self.layer.borderColor = _highlightedBorderColor.CGColor;
    
}

- (void)setBorderColor:(UIColor *)borderColor
{
    _borderColor = borderColor;
    self.layer.borderColor = _borderColor.CGColor;
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
    [self setBackgroundImage:[self backgroundImageWithColor:self.highlightedBackgroundColor] forState:UIControlStateNormal];
    [self setTitleColor:self.highlightedTextColor forState:UIControlStateNormal];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIImage *backgroundImage = self.backgroundColor ? [self backgroundImageWithColor:self.backgroundColor] : nil;
        [self setBackgroundImage:backgroundImage forState:UIControlStateNormal];
        [self setTitleColor:self.textColor forState:UIControlStateNormal];
    });
}

- (UIImage *)backgroundImageWithColor:(UIColor *)color
{
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
