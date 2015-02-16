
//
//  JBDonatePopoverViewController.h
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 13/02/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import "JBTeam.h"
#import <Stripe.h>
#import "JBButton.h"
#import <UIKit/UIKit.h>
#import "JBAPIManager.h"

@interface JBDonatePopoverViewController : UIViewController

@property (nonatomic, strong) JBTeam *team;

@property (nonatomic, weak) IBOutlet UIView *headerView;
@property (nonatomic, weak) IBOutlet UITextField *amountTextField;
@property (nonatomic, weak) IBOutlet UITextField *fullNameTextField;
@property (nonatomic, weak) IBOutlet UITextField *emailTextField;
@property (nonatomic, weak) IBOutlet UILabel *anonymousLabel;
@property (nonatomic, weak) IBOutlet UISwitch *anonymousSwitch;
@property (nonatomic, weak) IBOutlet JBButton *payButton;
@property (nonatomic, weak) IBOutlet JBButton *cancelButton;
@property (nonatomic, weak) IBOutlet UIView *fullNameSeparatorView;
@property (nonatomic, weak) IBOutlet UIView *emailSeparatorView;

@end
