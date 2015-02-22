//
//  JBFeedBaseTableViewCell.h
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 22/02/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import "JBFeedBaseTableViewCell.h"

@protocol JBFeedImageTableViewCellDelegate <NSObject>

- (void)feedImageTableViewCell:(JBFeedBaseTableViewCell *)cell didTapOnThumbnailImageView:(UIImageView *)imageView;

@end

@interface JBFeedImageTableViewCell : JBFeedBaseTableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *thumbnailImageView;
@property (nonatomic, weak) id <JBFeedImageTableViewCellDelegate> delegate;

@end
