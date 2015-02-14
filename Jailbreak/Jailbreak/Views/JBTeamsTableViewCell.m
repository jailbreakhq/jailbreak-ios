//
//  JBTeamsTableViewCell.m
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 11/02/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import "UIColor+JBAdditions.h"
#import "JBTeamsTableViewCell.h"
#import "UIImageView+WebCacheWithProgress.h"

@implementation JBTeamsTableViewCell

- (void)setTeam:(JBTeam *)team
{
    _team = team;
    
    NSNumber *donations = [NSNumber numberWithDouble:(((self.team.amountRaisedOnline + self.team.amountRaisedOffline) / 100.0))];
    self.raisedLabel.text = [[self priceFormatter] stringFromNumber:donations];
    self.namesLabel.text = self.team.membersNames;
    self.teamNameLabel.text = self.team.name;
    self.collegeLabel.text = self.team.universityString;
    self.rankLabel.text = @"42nd";
    self.distanceToXLabel.text = [[self lengthFormatter] stringFromMeters:self.team.distanceToX];
    self.checkinLabel.text = @"Collins Barracks";
    
    [self.donateButton addTarget:self action:@selector(didTapDonateButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self setUniversityColors];
    
    [self.avatarImageView sd_setImageWithProgressAndURL:self.team.avatarURL];
}

#pragma mark - Private Methods

- (UIColor *)getColorForUniversity:(University)university
{
    switch (university)
    {
        case TCD:
            return [UIColor colorWithHexString:@"#85387C"];
        case UCD:
            return [UIColor colorWithHexString:@"#388085"];
        case UCC:
            return [UIColor colorWithHexString:@"#C94242"];
        case NUIG:
            return [UIColor colorWithHexString:@"#1EC971"];
        default:
            return [UIColor colorWithHexString:@"#4672A6"];
    }
}

- (void)setUniversityColors
{
    UIColor *color = [self getColorForUniversity:self.team.university];
    
    self.raisedLabel.backgroundColor = color;
    self.rankLabel.backgroundColor = color;
    self.collegeLabel.backgroundColor = color;
    self.distanceToXLabel.backgroundColor = color;
    self.avatarImageView.progressColor = color;
    
    self.donateButton.normalTextColor = color;
    self.donateButton.normalBorderColor = color;
    self.donateButton.normalBackgroundColor = [UIColor clearColor];
    self.donateButton.activeTextColor = [UIColor whiteColor];
    self.donateButton.activeBorderColor = color;
    self.donateButton.activeBackgroundColor = color;
    self.donateButton.borderWidth = 1.0;
}

- (void)didTapDonateButton:(JBButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(didTapDonateButtonWithCheckoutOptions:)])
    {
        STPCheckoutOptions *checkoutOptions = [STPCheckoutOptions new];
        checkoutOptions.companyName = [NSString stringWithFormat:@"\"%@\"", self.team.name];
        checkoutOptions.logoURL = self.team.avatarURL;
        checkoutOptions.logoColor = [self getColorForUniversity:self.team.university];
        checkoutOptions.purchaseDescription = @"Thanks for supporting Amnesty & SVP!";
        checkoutOptions.purchaseLabel = @"Donate";
        checkoutOptions.purchaseCurrency = @"EUR";
        
        [self.delegate didTapDonateButtonWithCheckoutOptions:checkoutOptions];
    }
}

- (NSNumberFormatter *)priceFormatter
{
    static NSNumberFormatter *_priceFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _priceFormatter = [[NSNumberFormatter alloc] init];
        [_priceFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        [_priceFormatter setLocale:[NSLocale currentLocale]];
        [_priceFormatter setCurrencyCode:@"EUR"];
        _priceFormatter.minimumFractionDigits = 0;
    });
    
    return _priceFormatter;
}

- (NSLengthFormatter *)lengthFormatter
{
    static NSLengthFormatter *_lengthFormater = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _lengthFormater = [[NSLengthFormatter alloc] init];
        [_lengthFormater.numberFormatter setLocale:[NSLocale currentLocale]];
        _lengthFormater.numberFormatter.maximumFractionDigits = 0;
    });
    
    return _lengthFormater;
}

@end
