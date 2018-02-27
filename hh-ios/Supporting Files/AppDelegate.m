//
//  AppDelegate.m
//  hh-ios
//
//  Created by Ian Richard on 11/13/17.
//  Copyright © 2017 Ian Richard. All rights reserved.
//

#import "AppDelegate.h"
#import "ChatViewController.h"
#import "MenuViewController.h"
#import "SWRevealViewController.h"
#import "UserHomeViewController.h"
#import "SignupViewController.h"
#import <SimpleKeychain.h>
#import "AuthenticationManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Set window
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Check token
    NSString *jwt = [AuthenticationManager getCurrentAccessToken];
    if (jwt) {
        // Go to user home
        return [self goToUserHome];
    } else {
        // No token in keychain - go to sign up
        return [self goToSignup];
    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark Helpers
- (BOOL)tokenNeedsRefresh {
    NSDate *now = [NSDate date];
    NSDate *expirationDate = (NSDate *)[[NSUserDefaults standardUserDefaults] objectForKey:@"auth0-token-expiration"];
    if ([now compare:expirationDate] == NSOrderedAscending) {
        // expiration in the past - must logout
        return YES;
    } else {
        NSTimeInterval secondsBetween = [expirationDate timeIntervalSinceDate:now];
        int numberOfHours = secondsBetween / 60;
        if (numberOfHours < 12) {
            // If less than half a day to expiration - reset
            return YES;
        } else {
            return NO;
        }
    }
}

- (BOOL)goToSignup {
    SignupViewController *signupVC = [[SignupViewController alloc]initWithNibName:@"SignupViewController" bundle:nil];
    UINavigationController *navVC = [[UINavigationController alloc]initWithRootViewController:signupVC];
    
    // Set as root
    self.window.rootViewController = navVC;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (BOOL)goToUserHome {
    UserHomeViewController *userVC = [[UserHomeViewController alloc]initWithNibName:@"UserHomeViewController" bundle:nil];
    UINavigationController *navVC = [[UINavigationController alloc]initWithRootViewController:userVC];
    
    // Set as root
    self.window.rootViewController = navVC;
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
