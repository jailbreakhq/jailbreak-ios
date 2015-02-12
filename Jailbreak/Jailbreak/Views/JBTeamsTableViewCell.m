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
    
    self.namesLabel.text = self.team.membersNames;
    self.teamNameLabel.text = self.team.name;
    
    NSNumber *donations = [NSNumber numberWithDouble:(((self.team.amountRaisedOnline + self.team.amountRaisedOffline) / 100.0))];
    self.raisedLabel.text = [[self priceFormatter] stringFromNumber:donations];
    self.collegeLabel.text = self.team.universityString;
    self.rankLabel.text = @"42nd";
    self.traveledLabel.text = @"40 km";
    self.checkinLabel.text = @"Collins Barracks";
    
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
    self.traveledLabel.backgroundColor = color;
    self.avatarImageView.progressColor = color;
    
    self.donateButton.textColor = color;
    self.donateButton.borderColor = color;
    self.donateButton.highlightedBorderColor = color;
    self.donateButton.highlightedBackgroundColor = color;
    self.donateButton.highlightedTextColor = [UIColor whiteColor];
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
    });
    _priceFormatter.minimumFractionDigits = 0;
    
    return _priceFormatter;
}

@end
