//
//  LoginViewController.m
//  hh-ios
//
//  Created by Ian Richard on 1/3/18.
//  Copyright © 2018 Ian Richard. All rights reserved.
//

#import "LoginViewController.h"
#import "UserHomeViewController.h"
#import "ViewHelpers.h"
#import "NSString+Security.h"
#import "AuthenticationManager.h"

#define TRIM(string) [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]

@interface LoginViewController ()

@property (nonatomic) BOOL keyboardShowing;
@property (nonatomic) NSString *email;
@property (nonatomic) NSString *password;

@end

@implementation LoginViewController

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
    
    self.navigationController.delegate = self;
    
    [ViewHelpers roundCorners:self.loginButton];
        
    UITapGestureRecognizer *singleTapGestureRecognizer = [ViewHelpers createTapGestureRecognizerWithTarget:self andSelectorName:@"singleTap:"];
    [self.scrollView addGestureRecognizer:singleTapGestureRecognizer];
    
    [self.signupButton addTarget:self action:@selector(signupButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.loginButton addTarget:self action:@selector(loginButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [ViewHelpers roundCorners:self.forgotButton];
    
    self.forgotButton.layer.borderColor = [[UIColor colorWithRed:61/255.0 green:79/255.0 blue:92/255.0 alpha:1.0]CGColor];
    self.forgotButton.layer.borderWidth = 1;
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
    self.signupButtonBottom.constant += keyboardHeight;
}

- (void)keyboardDidHide: (NSNotification *)notification {
    self.keyboardShowing = NO;
    self.scrollToContentHeight.constant = 0;
    self.signupButtonBottom.constant = 20;
}

-(void)singleTap:(UITapGestureRecognizer *)tapGestureRecognizer {
    [self.contentView endEditing:YES];
}

- (void)signupButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loginButtonClicked:(id)sender {
    // Get fields and trim
    self.email = TRIM(self.emailField.text);
    self.password = TRIM(self.passwordField.text);
    
    if (![self.email isValidEmail]) {
        [self presentViewController:[ViewHelpers createErrorAlertWithTitle:@"Email Invalid" andDescription:@"Please enter a valid email."] animated:YES completion:nil];
    } else if ([self.password isEqualToString:@""]) {
        [self presentViewController:[ViewHelpers createErrorAlertWithTitle:@"Password Invalid" andDescription:@"Please enter a valid password."] animated:YES completion:nil];
    } else {
        #if TARGET_OS_SIMULATOR
            // Simulator-specific code
            [self application:[UIApplication sharedApplication] didFailToRegisterForRemoteNotificationsWithError:[NSError errorWithDomain:NSCocoaErrorDomain code:400 userInfo:nil]];
        #else
            // Device-specific code
            [self application:[UIApplication sharedApplication] didFailToRegisterForRemoteNotificationsWithError:[NSError errorWithDomain:NSCocoaErrorDomain code:400 userInfo:nil]];
        #endif
        // Now, wait for response
    }
}

#pragma mark Delegate

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [self loginUserWithDeviceToken:[self stringWithDeviceToken:deviceToken]];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    [self loginUserWithDeviceToken:nil];
}

#pragma mark Nav Control

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // Clear input fields, reset button
    [self.emailField setText:@""];
    [self.passwordField setText:@""];
    [self resetFromLoading];
}

#pragma mark Helpers

- (void)setToLoading {
    [self.view endEditing:YES];
    [self.view setUserInteractionEnabled:NO];
    [self.activityIndicator startAnimating];
    [self.loginButton setTitle:@"" forState:UIControlStateNormal];
}

- (void)resetFromLoading {
    [self.view setUserInteractionEnabled:YES];
    [self.activityIndicator stopAnimating];
    [self.loginButton setTitle:@"Login" forState:UIControlStateNormal];
}

- (void)loginUserWithDeviceToken:(NSString *)deviceToken {
    [self setToLoading];
    [AuthenticationManager loginUserWithEmail:self.email andPassword:self.password andDeviceToken:deviceToken withCompletion:^(User *user, NSString *error) {
        if (!error) {
            UserHomeViewController *userHomeVC = [[UserHomeViewController alloc]initWithNibName:@"UserHomeViewController" bundle:nil];
            userHomeVC.user = user;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController pushViewController:userHomeVC animated:YES];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self presentViewController:[ViewHelpers createErrorAlertWithTitle:@"Error" andDescription:error] animated:YES completion:nil];
                [self resetFromLoading];
            });
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
