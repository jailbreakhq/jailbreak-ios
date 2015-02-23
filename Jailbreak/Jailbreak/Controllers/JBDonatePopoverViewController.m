//
//  JBDonatePopoverViewController.m
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 13/02/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import <TSMessage.h>
#import <BSKeyboardControls.h>
#import "JBDonatePopoverViewController.h"

static const NSUInteger kMinimumDonationAmount = 5;

@interface JBDonatePopoverViewController () <BSKeyboardControlsDelegate, STPCheckoutViewControllerDelegate, UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *fullNameLabelHeightConstraint;

@property (nonatomic, strong) NSString *previousTextPlain;
@property (nonatomic, assign) NSUInteger previousTextLength;
@property (nonatomic, assign) CGFloat fullNameTextFieldHeight;
@property (nonatomic, strong) BSKeyboardControls *keyboardControls;
@property (nonatomic, strong) STPCheckoutOptions *checkoutOptions;

@end

@implementation JBDonatePopoverViewController

#pragma mark - Accessors

- (STPCheckoutOptions *)checkoutOptions
{
    if (!_checkoutOptions) _checkoutOptions = [STPCheckoutOptions new];
    return _checkoutOptions;
}

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.anonymousSwitch.tintColor = self.team.universityColor;
    self.anonymousSwitch.onTintColor = self.team.universityColor;
    self.headerView.backgroundColor = self.team.universityColor;
    self.fullNameSeparatorView.backgroundColor = self.team.universityColor;
    self.emailSeparatorView.backgroundColor = self.team.universityColor;
    self.amountTextField.textColor = [UIColor whiteColor];
    self.amountTextField.tintColor = [UIColor whiteColor];
    self.amountTextField.placeholder = [[self priceFormatter] stringFromNumber:@(kMinimumDonationAmount)];
    self.fullNameTextField.textColor = self.team.universityColor;
    self.fullNameTextField.tintColor = self.team.universityColor;
    self.emailTextField.textColor = self.team.universityColor;
    self.emailTextField.tintColor = self.team.universityColor;
    self.anonymousLabel.textColor = self.team.universityColor;
    self.payButton.normalTextColor = self.team.universityColor;
    self.payButton.normalBackgroundColor = [UIColor clearColor];
    self.payButton.normalBorderColor = self.team.universityColor;
    self.payButton.activeTextColor = [UIColor whiteColor];
    self.payButton.activeBackgroundColor = self.team.universityColor;
    self.payButton.activeBorderColor = self.team.universityColor;
    self.payButton.borderWidth = 1.0;
    self.cancelButton.normalTextColor = [UIColor whiteColor];
    self.cancelButton.normalBackgroundColor = [UIColor clearColor];
    self.cancelButton.normalBorderColor = [UIColor whiteColor];
    self.cancelButton.activeTextColor = self.team.universityColor;
    self.cancelButton.activeBackgroundColor = [UIColor whiteColor];
    self.cancelButton.activeBorderColor = [UIColor whiteColor];
    self.cancelButton.borderWidth = 1.0;
    
    self.checkoutOptions.companyName = @"Jailbreak HQ";
    self.checkoutOptions.logoURL = self.team.avatarURL;
    self.checkoutOptions.logoColor = self.team.universityColor;
    self.checkoutOptions.purchaseDescription = [NSString stringWithFormat:@"\"%@\"", self.team.name];
    self.checkoutOptions.purchaseLabel = @"Pay";
    self.checkoutOptions.purchaseCurrency = @"EUR";
    
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

- (BOOL)isValidEmail:(NSString *)email
{
    NSString *emailRegex =
    @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
    @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
    @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
    @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
    @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
    @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
    @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
    
    return [[NSPredicate predicateWithFormat:@"SELF MATCHES[c] %@", emailRegex] evaluateWithObject:email];
}

#pragma mark - IBActions

- (IBAction)paymentButtonPressed:(JBButton *)sender
{
    // Alert if all required fields aren't filled in
    if (!self.emailTextField.text.length || (!self.fullNameTextField.text.length && !self.anonymousSwitch.isOn) || !self.previousTextPlain.length)
    {
        [TSMessage displayMessageWithTitle:@"Fields not filled in" subtitle:@"Please fill in all the fields to continue" type:TSMessageTypeWarning];
    }
    // Alert if donation is less than minimum
    else if ([self.previousTextPlain integerValue] < kMinimumDonationAmount)
    {
        [TSMessage displayMessageWithTitle:@"Minimum donation is €5" subtitle:nil type:TSMessageTypeWarning];
    }
    // Alert if email is invalid (Stripe Checkout will validate but can't get address back for API call so...)
    else if (![self isValidEmail:self.emailTextField.text])
    {
        [TSMessage displayMessageWithTitle:@"Invalid Email" subtitle:@"Please enter a valid email to continue" type:TSMessageTypeError];
    }
    else
    {
        [self.view endEditing:YES];
        
        self.checkoutOptions.customerEmail = self.emailTextField.text;
        self.checkoutOptions.purchaseAmount = [self.previousTextPlain integerValue] * 100;;
        
        STPCheckoutViewController *checkoutViewController = [[STPCheckoutViewController alloc] initWithOptions:self.checkoutOptions];
        checkoutViewController.checkoutDelegate = self;
        
        [self presentViewController:checkoutViewController animated:YES completion:nil];
    }
}

- (IBAction)anonymousSwitchValueChanged:(UISwitch *)sender
{
    CGFloat animationDuration = 0.3;
    
    if (sender.isOn)
    {
        self.fullNameTextFieldHeight = self.fullNameLabelHeightConstraint.constant;
        
        [UIView animateWithDuration:animationDuration animations:^{
            self.fullNameSeparatorView.alpha = 0.0;
            self.fullNameLabelHeightConstraint.constant = 0.0;
            self.fullNameTextField.enabled = NO;
            [self.view layoutIfNeeded];
        }];
    }
    else
    {
        [UIView animateWithDuration:animationDuration animations:^{
            self.fullNameSeparatorView.alpha = 1.0;
            self.fullNameLabelHeightConstraint.constant = self.fullNameTextFieldHeight;
            self.fullNameTextField.enabled = YES;
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
            if ([self.delegate respondsToSelector:@selector(donatePopoverViewControllerDidSuccessfullyCharge)])
            {
                [self.delegate donatePopoverViewControllerDidSuccessfullyCharge];
            }
        case STPPaymentStatusUserCancelled:
            [TSMessage displayMessageWithTitle:@"€5 donation succeeded!" subtitle:@"Thank you so much 😘" type:TSMessageTypeSuccess];
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
            break;
        case STPPaymentStatusError:
        {
            [self dismissViewControllerAnimated:YES completion:^{
                [TSMessage displayMessageWithTitle:nil subtitle:error.localizedDescription type:TSMessageTypeError];
            }];
            break;
        }
    }
}

- (void)checkoutController:(STPCheckoutViewController *)controller didCreateToken:(STPToken *)token completion:(STPTokenSubmissionHandler)completion
{
    if (token)
    {
        [[JBAPIManager manager] makeDonationWithParameters:@{@"token": token.tokenId,
                                                             @"amount": @(self.checkoutOptions.purchaseAmount),
                                                             @"teamId": @(self.team.ID),
                                                             @"email": self.checkoutOptions.customerEmail,
                                                             @"name": self.fullNameTextField.text,
                                                             @"backer": self.anonymousSwitch.isOn ? @"false" : @"true"}
                                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                       completion(STPBackendChargeResultSuccess, nil);
                                                   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                       NSError *usefulError = [NSError errorWithDomain:error.domain
                                                                                                  code:error.code
                                                                                              userInfo:@{NSLocalizedDescriptionKey: operation.responseObject[@"message"]}];
                                                       completion(STPBackendChargeResultFailure, usefulError);
                                                   }];
    }
    else
    {
        completion(STPBackendChargeResultFailure, nil);
    }
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
