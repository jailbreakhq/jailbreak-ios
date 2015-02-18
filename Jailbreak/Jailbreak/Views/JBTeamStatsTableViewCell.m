//
//  JBTeamStatsTableViewCell.m
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 18/02/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import "JBTeamStatsTableViewCell.h"

@implementation JBTeamStatsTableViewCell

- (void)setTeam:(JBTeam *)team
{
    _team = team;
    
    NSUInteger amountRaised = self.team.amountRaisedOnline + self.team.amountRaisedOffline;
    self.raisedAmountLabel.text = [[self priceFormatter] stringFromNumber:@(amountRaised / 100.0)];
    self.raisedAmountLabel.textColor = self.team.universityColor;
    self.raisedLabel.text = @"raised";
    self.countriesAmountLabel.text = [@(self.team.countries) stringValue];
    self.countriesAmountLabel.textColor = self.team.universityColor;
    self.countriesLabel.text = self.team.countries == 1 ? @"country" : @"countries";
    self.transportAmountLabel.text = [@(self.team.transports) stringValue];
    self.transportAmountLabel.textColor = self.team.universityColor;
    self.transportLabel.text = @"transport";
    self.challengesAmountLabel.text = [@(self.team.challenges.count) stringValue];
    self.challengesAmountLabel.textColor = self.team.universityColor;
    self.challengesLabel.text = @"challenges";
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

@end
