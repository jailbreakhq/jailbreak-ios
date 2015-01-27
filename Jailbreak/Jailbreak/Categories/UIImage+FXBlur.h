//
//  UIImage+FXBlur.h
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 27/01/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (FXBlur)

- (UIImage *)blurredImageWithRadius:(CGFloat)radius iterations:(NSUInteger)iterations tintColor:(UIColor *)tintColor;

@end
