//
//  UIImageView+WebCacheWithProgress.h
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 02/02/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import "CERoundProgressView.h"
#import <UIImageView+WebCache.h>

@interface UIImageView (WebCacheWithProgress)

@property (nonatomic, strong) CERoundProgressView *roundProgressView;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) UIColor *progressColor;
@property (nonatomic, strong) NSNumber *progressWidth;

- (void)sd_setImageWithProgressAndURL:(NSURL *)url;

- (void)sd_setImageWithProgressAndURL:(NSURL *)url
                     placeholderImage:(UIImage *)placeholder;

- (void)sd_setImageWithProgressAndURL:(NSURL *)url
                     placeholderImage:(UIImage *)placeholder
                              options:(SDWebImageOptions)options;

- (void)sd_setImageWithProgressAndURL:(NSURL *)url
                            completed:(SDWebImageCompletionBlock)completedBlock;

- (void)sd_setImageWithProgressAndURL:(NSURL *)url
                     placeholderImage:(UIImage *)placeholder
                            completed:(SDWebImageCompletionBlock)completedBlock;

- (void)sd_setImageWithProgressAndURL:(NSURL *)url
                     placeholderImage:(UIImage *)placeholder
                              options:(SDWebImageOptions)options
                            completed:(SDWebImageCompletionBlock)completedBlock;

- (void)sd_setImageWithProgressAndURL:(NSURL *)url
                     placeholderImage:(UIImage *)placeholder
                              options:(SDWebImageOptions)options
                             progress:(SDWebImageDownloaderProgressBlock)progressBlock
                            completed:(SDWebImageCompletionBlock)completedBlock;

@end
