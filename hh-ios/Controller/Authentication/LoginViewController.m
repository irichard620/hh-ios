//
//  LoginViewController.m
//  hh-ios
//
//  Created by Ian Richard on 1/3/18.
//  Copyright © 2018 Ian Richard. All rights reserved.
//

#import "LoginViewController.h"
#import "UserHomeViewController.h"

@interface LoginViewController ()

@property (nonatomic) BOOL keyboardShowing;

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
    
    self.loginButton.layer.cornerRadius = 13;
    self.loginButton.clipsToBounds = YES;
        
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    singleTapGestureRecognizer.numberOfTapsRequired = 1;
    singleTapGestureRecognizer.enabled = YES;
    singleTapGestureRecognizer.cancelsTouchesInView = NO;
    [self.scrollView addGestureRecognizer:singleTapGestureRecognizer];
    
    [self.signupButton addTarget:self action:@selector(signupButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.loginButton addTarget:self action:@selector(loginButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
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
    UserHomeViewController *userHomeVC = [[UserHomeViewController alloc]initWithNibName:@"UserHomeViewController" bundle:nil];
    [self.navigationController pushViewController:userHomeVC animated:YES];
}

@end
