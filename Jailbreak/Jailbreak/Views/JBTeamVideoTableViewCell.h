//
//  JBTeamVideoTableViewCell.h
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 17/02/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JBYouTubeView.h"

@interface JBTeamVideoTableViewCell : UITableViewCell

@property (nonatomic, copy) NSString *youTubeVideoId;

@property (nonatomic, weak) IBOutlet JBYouTubeView *youTubeView;

@end
