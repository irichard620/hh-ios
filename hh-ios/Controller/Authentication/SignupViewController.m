//
//  SignupViewController.m
//  hh-ios
//
//  Created by Ian Richard on 1/1/18.
//  Copyright © 2018 Ian Richard. All rights reserved.
//

#import "SignupViewController.h"
#import "LoginViewController.h"
#import "UserHomeViewController.h"
#import "ViewHelpers.h"
#import "AuthenticationManager.h"
#import "NSString+Security.h"

#define TRIM(string) [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]


@interface SignupViewController ()

@property (nonatomic) BOOL keyboardShowing;

@property (nonatomic) NSString *email;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *password;


@end

@implementation SignupViewController

#pragma mark Initialization

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
        _keyboardShowing = NO;
    }
    return self;
}

#pragma mark View Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Customize nav bar
    
    self.navigationController.navigationBarHidden = YES;
    self.navigationItem.hidesBackButton = YES;
//    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.00 green:0.59 blue:0.53 alpha:1.0];
//    self.navigationItem.title = @"Honest Housemate";
//    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
//    self.navigationController.navigationBar.largeTitleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
//    self.navigationController.navigationBar.prefersLargeTitles = YES;
    
    // Round corners
    [ViewHelpers roundCorners:self.messageContainer];
    [ViewHelpers roundCorners:self.createAccountButton];
    
    UITapGestureRecognizer *singleTapGestureRecognizer = [ViewHelpers createTapGestureRecognizerWithTarget:self andSelectorName:@"singleTap:"];
    [self.scrollView addGestureRecognizer:singleTapGestureRecognizer];
    
    [self.loginButton addTarget:self action:@selector(loginButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.createAccountButton addTarget:self action:@selector(createAccountButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark Interaction

- (void)keyboardDidShow: (NSNotification *)notification {
    if (self.keyboardShowing) return;
    self.keyboardShowing = YES;
    
    // Get frame of keyboard
    CGRect keyboardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // Convert frame
    UIWindow *window = [[[UIApplication sharedApplication] windows]objectAtIndex:0];
    UIView *mainSubviewOfWindow = window.rootViewController.view;
    CGRect keyboardFrameConverted = [mainSubviewOfWindow convertRect:keyboardFrame fromView:window];
    
    // Get height
    CGFloat keyboardHeight = keyboardFrameConverted.size.height;
    
    self.scrollToContentHeight.constant += keyboardHeight;
    self.loginButtonBottom.constant += keyboardHeight;
}

- (void)keyboardDidHide: (NSNotification *)notification {
    self.keyboardShowing = NO;
    self.scrollToContentHeight.constant = 0;
    self.loginButtonBottom.constant = 20;
}

-(void)singleTap:(UITapGestureRecognizer *)tapGestureRecognizer {
    [self.contentView endEditing:YES];
}

- (void)loginButtonClicked:(id)sender {
    LoginViewController *loginVC = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
    [self.navigationController pushViewController:loginVC animated:YES];
}

- (void)createAccountButtonClicked:(id)sender {
    // Get fields and trim
    self.name = TRIM(self.nameField.text);
    self.email = TRIM(self.emailField.text);
    self.password = TRIM(self.passwordField.text);

    if ([self.name isEqualToString:@""]) {
        [self presentViewController:[ViewHelpers createErrorAlertWithTitle:@"Missing Name" andDescription:@"Please enter a full name for your user."] animated:YES completion:nil];
    } else if (![self.email isValidEmail]) {
        [self presentViewController:[ViewHelpers createErrorAlertWithTitle:@"Email Invalid" andDescription:@"Please enter a valid email."] animated:YES completion:nil];
    } else if (self.password.length < 6) {
        [self presentViewController:[ViewHelpers createErrorAlertWithTitle:@"Password Invalid" andDescription:@"The password must be 6 or more characters."] animated:YES completion:nil];
    } else {
        
        // All fields present - let's ask for remote notifications first
        //        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [self application:[UIApplication sharedApplication] didFailToRegisterForRemoteNotificationsWithError:[NSError errorWithDomain:NSCocoaErrorDomain code:400 userInfo:nil]];

        // Now, wait for response
    }
}

#pragma mark Delegate

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [self signupUserWithDeviceToken:[self stringWithDeviceToken:deviceToken]];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    [self signupUserWithDeviceToken:nil];
}

#pragma mark Helpers

- (void)signupUserWithDeviceToken:(NSString *)deviceToken {
    [AuthenticationManager createNewUserWithEmail:self.email andPassword:self.password andFullName:self.name andDeviceToken:deviceToken withCompletion:^(User *user, NSString *error) {
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                UserHomeViewController *userHomeVC = [[UserHomeViewController alloc]initWithNibName:@"UserHomeViewController" bundle:nil];
                userHomeVC.user = user;
                [self.navigationController pushViewController:userHomeVC animated:YES];
            });
        } else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:error preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
}

- (NSString *)stringWithDeviceToken:(NSData *)deviceToken {
    const char *data = [deviceToken bytes];
    NSMutableString *token = [NSMutableString string];
    
    for (NSUInteger i = 0; i < [deviceToken length]; i++) {
        [token appendFormat:@"%02.2hhX", data[i]];
    }
    
    return [token copy];
}

@end
