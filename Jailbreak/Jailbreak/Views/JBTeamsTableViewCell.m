//
//  JBTeamsTableViewCell.m
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 11/02/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import "JBTeamsTableViewCell.h"
#import "TTTOrdinalNumberFormatter.h"
#import "UIImageView+WebCacheWithProgress.h"

@implementation JBTeamsTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self.donateButton addTarget:self action:@selector(didTapDonateButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setTeam:(JBTeam *)team
{
    _team = team;
    
    NSNumber *donations = [NSNumber numberWithDouble:(((self.team.amountRaisedOnline + self.team.amountRaisedOffline) / 100.0))];
    self.raisedLabel.text = [[self priceFormatter] stringFromNumber:donations];
    self.namesLabel.text = self.team.membersNames;
    self.teamNameLabel.text = self.team.name;
    self.collegeLabel.text = self.team.universityString;
    self.rankLabel.text = [[self ordinalFormatter] stringFromNumber:@(self.team.position)];
    self.distanceToXLabel.text = [[self lengthFormatter] stringFromMeters:self.team.distanceToX];
    self.checkinLabel.text = self.team.lastCheckin.locationString;
    self.placeholderLabel.hidden = YES;
    
    self.raisedLabel.backgroundColor = self.team.universityColor;
    self.rankLabel.backgroundColor = self.team.universityColor;
    self.collegeLabel.backgroundColor = self.team.universityColor;
    self.distanceToXLabel.backgroundColor = self.team.universityColor;
    self.avatarImageView.progressColor = self.team.universityColor;
    self.avatarImageView.progressWidth = @(5);
    
    self.donateButton.normalTextColor = self.team.universityColor;
    self.donateButton.normalBorderColor = self.team.universityColor;
    self.donateButton.normalBackgroundColor = [UIColor clearColor];
    self.donateButton.activeTextColor = [UIColor whiteColor];
    self.donateButton.activeBorderColor = self.team.universityColor;
    self.donateButton.activeBackgroundColor = self.team.universityColor;
    self.donateButton.borderWidth = 1.0;
    
    [self.avatarImageView sd_setImageWithProgressAndURL:self.team.avatarURL
                                              completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                                  if (!image)
                                                  {
                                                      self.placeholderLabel.hidden = NO;
                                                      self.placeholderLabel.text = [self abbreviationForNames:self.team.membersNames];
                                                  }
                                              }];
}

#pragma mark - Private Methods

- (void)didTapDonateButton:(JBButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(didTapDonateButtonForTeam:)])
    {
        [self.delegate didTapDonateButtonForTeam:self.team];
    }
}

- (NSString *)abbreviationForNames:(NSString *)string
{
    NSArray *names = [[string stringByReplacingOccurrencesOfString:@" " withString:@""] componentsSeparatedByString:@"&"];
    return [NSString stringWithFormat:@"%@&%@", [names[0] substringToIndex:1], [names[1] substringToIndex:1]];
}

- (TTTOrdinalNumberFormatter *)ordinalFormatter
{
    static TTTOrdinalNumberFormatter *_ordinalFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _ordinalFormatter = [TTTOrdinalNumberFormatter new];
        [_ordinalFormatter setLocale:[NSLocale currentLocale]];
        [_ordinalFormatter setGrammaticalGender:TTTOrdinalNumberFormatterMaleGender];
    });
    
    return _ordinalFormatter;
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
