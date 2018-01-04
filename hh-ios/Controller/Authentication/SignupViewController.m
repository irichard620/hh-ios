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

@interface SignupViewController ()

@property (nonatomic) BOOL keyboardShowing;

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
    self.messageContainer.layer.cornerRadius = 13;
    self.messageContainer.clipsToBounds = YES;
    self.createAccountButton.layer.cornerRadius = 13;
    self.createAccountButton.clipsToBounds = YES;
    
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    singleTapGestureRecognizer.numberOfTapsRequired = 1;
    singleTapGestureRecognizer.enabled = YES;
    singleTapGestureRecognizer.cancelsTouchesInView = NO;
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
    UserHomeViewController *userHomeVC = [[UserHomeViewController alloc]initWithNibName:@"UserHomeViewController" bundle:nil];
    [self.navigationController pushViewController:userHomeVC animated:YES];
}

@end
