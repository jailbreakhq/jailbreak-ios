//
//  JBIntroViewController.m
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 27/02/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import "UIColor+JBAdditions.h"
#import "JBIntroViewController.h"

@interface JBIntroViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end

@implementation JBIntroViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIColor *baseColor = [UIColor colorWithHexString:@"#85387C"];
    __weak typeof(self) weakSelf = self;

    UITableViewRowAction *favouriteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Favourite" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        [weakSelf.tableView setEditing:NO animated:YES];
    }];
    
    UITableViewRowAction *retweetAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Retweet" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        [weakSelf.tableView setEditing:NO animated:YES];
    }];
    
    favouriteAction.backgroundColor = [baseColor colorWithBrightnessChangedBy:-10];
    retweetAction.backgroundColor = baseColor;
    
    return @[favouriteAction, retweetAction];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
}
- (IBAction)didTapButton:(UIButton *)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"hasShownIntro"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }];
}

@end
