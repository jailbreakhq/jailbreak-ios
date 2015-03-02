//
//  JBTeamProfileViewController.h
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 18/02/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import "JBTeam.h"
#import "JBBaseViewController.h"

@interface JBTeamProfileViewController : JBBaseViewController

@property (nonatomic, strong) JBTeam *team;
@property (nonatomic, assign) NSUInteger teamSectionIndex;

@end
