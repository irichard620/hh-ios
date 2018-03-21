//
//  ChatViewController.h
//  hh-ios
//
//  Created by Ian Richard on 11/13/17.
//  Copyright © 2017 Ian Richard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLKTextViewController.h"
#import "MenuViewController.h"
#import <TwilioChatClient/TwilioChatClient.h>
#import "TodoDetailsViewController.h"

@interface ChatViewController : SLKTextViewController <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, TodoDetailsDelegate>

@property (nonatomic) House *house;
@property (nonatomic) User *user;
@property (nonatomic) TCHChannel *channel;

@end
