//
//  JBFacebookLoginViewController.m
//  Jailbreak
//
//  Created by Shayan Yousefizadeh on 04/03/2015.
//  Copyright (c) 2015 Jailbreak HQ. All rights reserved.
//

#import <TSMessage.h>
#import <FacebookSDK.h>
#import "JBFacebookLoginViewController.h"

@interface JBFacebookLoginViewController () <FBLoginViewDelegate>

@property (nonatomic, weak) IBOutlet FBLoginView *loginView;

@end

@implementation JBFacebookLoginViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.loginView.readPermissions = @[@"public_profile"];
    self.loginView.publishPermissions = @[@"publish_actions"];
    self.loginView.defaultAudience = FBSessionDefaultAudienceEveryone;
    self.loginView.delegate = self;
}

#pragma mark - FBLoginViewDelegate

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
        if ([self facebookSessionHasRequiredPermissions:@[@"publish_actions", @"public_profile"]])
        {
            [TSMessage displayMessageWithTitle:@"Success" subtitle:@"You can now Like posts right inside the app 🙏" type:TSMessageTypeSuccess];
            
            [FBRequestConnection startWithGraphPath:[NSString stringWithFormat:@"/%@/likes", self.post.facebook.facebookPostId]
                                         parameters:nil
                                         HTTPMethod:@"POST"
                                  completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                      if (!error)
                                      {
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              [TSMessage displayMessageWithTitle:@"Facebook Post Liked 👍" subtitle:nil type:TSMessageTypeSuccess];
                                          });
                                      }
                                      else
                                      {
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              [TSMessage displayMessageWithTitle:@"Oops" subtitle:error.localizedFailureReason type:TSMessageTypeError];
                                          });
                                      }
                                  }];
        }
        else
        {
            [TSMessage displayMessageWithTitle:@"Publish Permission Not Granted" subtitle:@"We need this permission to like posts. Try again and grant access this time." type:TSMessageTypeError];
        }
    }];
}

- (BOOL)facebookSessionHasRequiredPermissions:(NSArray *)requiredPermissions
{
    NSArray *permissions = [FBSession activeSession].permissions;
    
    for (NSString *permission in requiredPermissions)
    {
        if (![permissions containsObject:permission]) return NO;
    }
    
    return YES;
}

- (IBAction)cancelButtonPressed:(UIButton *)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error
{
    NSString *alertTitle;
    NSString *alertMessage;
    
    if ([FBErrorUtility shouldNotifyUserForError:error])
    {
        alertMessage = [FBErrorUtility userMessageForError:error];
    }
    else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession)
    {
        alertTitle = @"Session Error";
        alertMessage = @"Your current session is no longer valid. Please log in again.";
    }
    else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled)
    {
    }
    else
    {
        alertTitle  = @"Something went wrong";
        alertMessage = @"Please try again later.";
    }
    
    if (alertMessage)
    {
        [TSMessage displayMessageWithTitle:alertTitle subtitle:alertMessage type:TSMessageTypeError];
    }
}
@end
