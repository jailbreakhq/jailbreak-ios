//
//  JBFeedLinkTableViewCell.h
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 26/02/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import "JBPost.h"
#import <UIKit/UIKit.h>

@interface JBFeedLinkTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *photoImageView;
@property (nonatomic, weak) IBOutlet UILabel *bodyLabel;
@property (nonatomic, weak) IBOutlet UIButton *button;

@property (nonatomic, weak) JBPost *post;

- (void)configureCellWithPost:(JBPost *)post;

@end
