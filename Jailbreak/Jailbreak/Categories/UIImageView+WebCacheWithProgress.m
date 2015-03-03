//
//  UIImageView+WebCacheWithProgress.m
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 02/02/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import "UIColor+JBAdditions.h"
#import "JBCircularImageView.h"
#import "UIImageView+WebCacheWithProgress.h"

static char kRoundProgressViewKey;
static char kProgressViewKey;
static char kProgressColor;
static char kProgressWidth;

@interface UIImageView (Private)

- (void)addProgressView;
- (void)removeProgressView;
- (BOOL)isCircular;

@end

@implementation UIImageView (WebCacheWithProgress)

@dynamic roundProgressView;
@dynamic progressView;
@dynamic progressColor;
@dynamic progressWidth;

- (CERoundProgressView *)roundProgressView
{
    return (CERoundProgressView *)objc_getAssociatedObject(self, &kRoundProgressViewKey);
}

- (void)setRoundProgressView:(CERoundProgressView *)roundProgressView
{
    objc_setAssociatedObject(self, &kRoundProgressViewKey, roundProgressView, OBJC_ASSOCIATION_RETAIN);
}

- (RTSpinKitView *)progressView
{
    return (RTSpinKitView *)objc_getAssociatedObject(self, &kProgressViewKey);
}

- (void)setProgressView:(RTSpinKitView *)progressView
{
    objc_setAssociatedObject(self, &kProgressViewKey, progressView, OBJC_ASSOCIATION_RETAIN);
}

- (UIColor *)progressColor
{
    return (UIColor *)objc_getAssociatedObject(self, &kProgressColor);
}

- (void)setProgressColor:(UIColor *)progressColor
{
    objc_setAssociatedObject(self, &kProgressColor, progressColor, OBJC_ASSOCIATION_RETAIN);
}

- (NSNumber *)progressWidth
{
    return (NSNumber *)objc_getAssociatedObject(self, &kProgressWidth);
}

- (void)setProgressWidth:(NSNumber *)progressWidth
{
    objc_setAssociatedObject(self, &kProgressWidth, progressWidth, OBJC_ASSOCIATION_RETAIN);
}

- (void)addProgressView
{
    UIColor *trackColor = [UIColor colorWithWhite:0.85 alpha:1.0];
    UIColor *tintColor = self.progressColor ?: [UIColor colorWithHexString:@"#B41C21"];
    
    if ([self isCircular])
    {
        trackColor = [UIColor clearColor];
        
        if (!self.roundProgressView)
        {
            CGFloat size = CGRectGetHeight(self.frame) + (self.progressWidth.doubleValue * 2.0);
            self.roundProgressView = [[CERoundProgressView alloc] initWithFrame:CGRectMake(0, 0, size, size)];
            self.roundProgressView.center = self.center;
            self.roundProgressView.startAngle = (3.0 * M_PI) / 2.0;
            self.roundProgressView.tintColor = tintColor;
            self.roundProgressView.trackColor = trackColor;
            
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                [self.superview insertSubview:self.roundProgressView belowSubview:self];
            });
        }
    }
    else
    {
        if (!self.progressView)
        {
            self.progressView = [[RTSpinKitView alloc] initWithStyle:RTSpinKitViewStyleWave color:tintColor];
            self.progressView.hidesWhenStopped = YES;
            self.progressView.center = CGPointMake(self.frame.size.width / 2.0, self.frame.size.height / 2.0);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.progressView startAnimating];
                [self addSubview:self.progressView];
            });
        }
        else
        {
            self.progressView.color = tintColor;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.progressView startAnimating];
            });
        }
    }
}

- (void)removeProgressView
{
    if ([self isCircular])
    {
        if (self.roundProgressView)
        {
            [self.roundProgressView removeFromSuperview];
            self.roundProgressView = nil;
        }
    }
    else
    {
        if (self.progressView)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.progressView stopAnimating];
            });
        }
    }
}

- (BOOL)isCircular
{
    return [self isKindOfClass:[JBCircularImageView class]];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if ([self isCircular])
    {
        if (self.roundProgressView)
        {
            CGFloat size = CGRectGetHeight(self.frame) + 10.0;
            self.roundProgressView.frame = CGRectMake(0, 0, size, size);
            self.roundProgressView.center = self.center;
        }
    }
    else
    {
        if (self.progressView)
        {
            self.progressView.center = CGPointMake(self.frame.size.width / 2.0, self.frame.size.height / 2.0);
        }
    }
}

#pragma mark - Methods

- (void)sd_setImageWithProgressAndURL:(NSURL *)url
{
    [self sd_setImageWithProgressAndURL:url placeholderImage:nil options:0 progress:nil completed:nil];
}

- (void)sd_setImageWithProgressAndURL:(NSURL *)url
                     placeholderImage:(UIImage *)placeholder
{
    [self sd_setImageWithProgressAndURL:url placeholderImage:placeholder options:0 progress:nil completed:nil];
}

- (void)sd_setImageWithProgressAndURL:(NSURL *)url
                     placeholderImage:(UIImage *)placeholder
                              options:(SDWebImageOptions)options
{
    [self sd_setImageWithProgressAndURL:url placeholderImage:placeholder options:options progress:nil completed:nil];
}

- (void)sd_setImageWithProgressAndURL:(NSURL *)url
                            completed:(SDWebImageCompletionBlock)completedBlock
{
    [self sd_setImageWithProgressAndURL:url placeholderImage:nil options:0 progress:nil completed:completedBlock];
}

- (void)sd_setImageWithProgressAndURL:(NSURL *)url
                     placeholderImage:(UIImage *)placeholder
                            completed:(SDWebImageCompletionBlock)completedBlock
{
    [self sd_setImageWithProgressAndURL:url placeholderImage:placeholder options:0 progress:nil completed:completedBlock];
}

- (void)sd_setImageWithProgressAndURL:(NSURL *)url
                     placeholderImage:(UIImage *)placeholder
                              options:(SDWebImageOptions)options
                            completed:(SDWebImageCompletionBlock)completedBlock
{
    [self sd_setImageWithProgressAndURL:url placeholderImage:placeholder options:options progress:nil completed:completedBlock];
}

- (void)sd_setImageWithProgressAndURL:(NSURL *)url
                     placeholderImage:(UIImage *)placeholder
                              options:(SDWebImageOptions)options
                             progress:(SDWebImageDownloaderProgressBlock)progressBlock
                            completed:(SDWebImageCompletionBlock)completedBlock
{
    [self addProgressView];
    
    __weak typeof(self) weakSelf = self;
    
    [self sd_setImageWithURL:url
            placeholderImage:placeholder
                     options:options
                    progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                        if (progressBlock) progressBlock(receivedSize, expectedSize);
                        
                        dispatch_async(dispatch_get_main_queue(), ^(void) {
                            if ([self isCircular])
                            {
                                [weakSelf.roundProgressView setProgress:((CGFloat)receivedSize / (CGFloat)expectedSize)
                                                          animated:YES];
                            }
                        });
                    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                        if (completedBlock) completedBlock(image, error, cacheType, imageURL);
                        [weakSelf removeProgressView];
                    }];
}

@end
