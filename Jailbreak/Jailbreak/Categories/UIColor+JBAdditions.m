//
//  UIColor+JBAdditions.m
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 11/02/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import "UIColor+JBAdditions.h"

@implementation UIColor (JBAdditions)

- (instancetype)colorWithBrightnessChangedBy:(NSInteger)brightnessChange
{
    CGFloat hue, saturation, brightness, alpha;
    CGFloat change = brightnessChange / 255.0;
    
    [self getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
    
    return [UIColor colorWithHue:hue saturation:saturation brightness:MIN(MAX(brightness+change, 0.0), 1.0) alpha:alpha];
}

+ (instancetype)colorWithHexString:(NSString *)hexString
{
    unsigned int hexValue;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // skip '#' character
    [scanner scanHexInt:&hexValue];
    
    return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0
                           green:((float)((hexValue & 0xFF00) >> 8))/255.0
                            blue:((float)(hexValue & 0xFF))/255.0
                           alpha:1.0];
}

@end
