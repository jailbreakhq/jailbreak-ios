//
//  JBDonatePopoverViewController.m
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 13/02/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import <BSKeyboardControls.h>
#import "JBDonatePopoverViewController.h"

@interface JBDonatePopoverViewController () <BSKeyboardControlsDelegate, STPCheckoutViewControllerDelegate, UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *fullNameLabelHeightConstraint;

@property (nonatomic, strong) NSString *previousTextPlain;
@property (nonatomic, assign) NSUInteger previousTextLength;
@property (nonatomic, strong) BSKeyboardControls *keyboardControls;

@end

@implementation JBDonatePopoverViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIColor *teamColor = self.checkoutOptions.logoColor;
    self.anonymousSwitch.tintColor = teamColor;
    self.anonymousSwitch.onTintColor = teamColor;
    self.headerView.backgroundColor = teamColor;
    self.fullNameSeparatorView.backgroundColor = teamColor;
    self.emailSeparatorView.backgroundColor = teamColor;
    self.amountTextField.textColor = [UIColor whiteColor];
    self.fullNameTextField.textColor = teamColor;
    self.emailTextField.textColor = teamColor;
    self.anonymousLabel.textColor = teamColor;
    self.payButton.normalTextColor = teamColor;
    self.payButton.normalBackgroundColor = [UIColor clearColor];
    self.payButton.normalBorderColor = teamColor;
    self.payButton.activeTextColor = [UIColor whiteColor];
    self.payButton.activeBackgroundColor = teamColor;
    self.payButton.activeBorderColor = teamColor;
    self.payButton.borderWidth = 1.0;
    self.cancelButton.normalTextColor = [UIColor whiteColor];
    self.cancelButton.normalBackgroundColor = [UIColor clearColor];
    self.cancelButton.normalBorderColor = [UIColor whiteColor];
    self.cancelButton.activeTextColor = teamColor;
    self.cancelButton.activeBackgroundColor = [UIColor whiteColor];
    self.cancelButton.activeBorderColor = [UIColor whiteColor];
    self.cancelButton.borderWidth = 1.0;
    
    NSArray *fields = @[self.amountTextField, self.fullNameTextField, self.emailTextField];
    self.keyboardControls = [[BSKeyboardControls alloc] initWithFields:fields];
    self.keyboardControls.delegate = self;
    
    [self.amountTextField becomeFirstResponder];
}

#pragma mark - Private Helper Methods

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

#pragma mark - IBActions

- (IBAction)paymentButtonPressed:(JBButton *)sender
{
    [self.view endEditing:YES];

    // Automatically charge minimum donation (€5) if they forget to fill in
    NSInteger donationAmount = self.amountTextField.text.length ? [[[self priceFormatter] numberFromString:self.amountTextField.text] integerValue] * 100 : 500;
    self.checkoutOptions.customerEmail = self.emailTextField.text;
    self.checkoutOptions.purchaseAmount = donationAmount;
    
    STPCheckoutViewController *checkoutViewController = [[STPCheckoutViewController alloc] initWithOptions:self.checkoutOptions];
    checkoutViewController.checkoutDelegate = self;
    [self presentViewController:checkoutViewController animated:YES completion:nil];
}

- (IBAction)anonymousSwitchValueChanged:(UISwitch *)sender
{
    static CGFloat fullNameLabelHeight = 0.0;
    CGFloat animationDuration = 0.3;
    
    if (sender.isOn)
    {
        fullNameLabelHeight = self.fullNameLabelHeightConstraint.constant;
        
        [UIView animateWithDuration:animationDuration animations:^{
            self.fullNameSeparatorView.alpha = 0.0;
            self.fullNameLabelHeightConstraint.constant = 0.0;
            [self.view layoutIfNeeded];
        }];
    }
    else
    {
        [UIView animateWithDuration:animationDuration animations:^{
            self.fullNameSeparatorView.alpha = 1.0;
            self.fullNameLabelHeightConstraint.constant = fullNameLabelHeight;
            [self.view layoutIfNeeded];
        }];
    }
}
- (IBAction)didTapCancelButton:(JBButton *)sender
{
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)amountTextFieldChanged:(UITextField *)sender
{
    // Avoid adding leading zeros
    if ([sender.text isEqualToString:@"0"])
    {
        sender.text = @"";
    }
    else
    {
        // First digit
        if (!self.previousTextPlain.length)
        {
            self.previousTextPlain = sender.text;
        }
        else
        {
            NSString *newText = [sender.text substringFromIndex:sender.text.length-1];
            
            // Added text
            if (self.previousTextLength < sender.text.length)
            {
                self.previousTextPlain = [self.previousTextPlain stringByAppendingString:newText];
            }
            else
            {
                self.previousTextPlain = [self.previousTextPlain substringToIndex:self.previousTextPlain.length-1];
            }
        }
        
        if (self.previousTextPlain.length)
        {
            sender.text = [[self priceFormatter] stringFromNumber:@([self.previousTextPlain integerValue])];
        }
        else
        {
            sender.text = @"";
        }
        
        self.previousTextLength = sender.text.length;
    }
}

#pragma mark - STPCheckoutViewControllerDelegate

- (void)checkoutController:(STPCheckoutViewController *)controller didFinishWithStatus:(STPPaymentStatus)status error:(NSError *)error
{
    switch (status)
    {
        case STPPaymentStatusSuccess:
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
            break;
        case STPPaymentStatusError:
            break;
        case STPPaymentStatusUserCancelled:
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
    }
}

- (void)checkoutController:(STPCheckoutViewController *)controller didCreateToken:(STPToken *)token completion:(STPTokenSubmissionHandler)completion
{
    completion(STPBackendChargeResultSuccess, nil);
}

#pragma mark - BSKeyboardControlsDelegate

- (void)keyboardControlsDonePressed:(BSKeyboardControls *)keyboardControls
{
    [keyboardControls.activeField resignFirstResponder];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.keyboardControls.activeField = textField;
}

@end
