//
//  JBTeamAboutTableViewCell.h
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 17/02/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import "JBTeam.h"
#import <UIKit/UIKit.h>

@interface JBTeamAboutTableViewCell : UITableViewCell

@property (nonatomic, weak) JBTeam *team;

@property (nonatomic, weak) IBOutlet UILabel *aboutHeadingLabel;
@property (nonatomic, weak) IBOutlet UILabel *aboutBodyLabel;

- (CGFloat)heightForBodyLabelWithText:(NSString *)text;

@end
