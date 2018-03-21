//
//  ChatMessage.h
//  hh-ios
//
//  Created by Ian Richard on 3/16/18.
//  Copyright © 2018 Ian Richard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserReference.h"
#import <TwilioChatClient/TwilioChatClient.h>

@interface ChatMessage : NSObject

// Body of the message
@property (nonatomic) NSString *messageBody;

// Type
@property (nonatomic) NSString *type;

// Info about sender 
@property (nonatomic) UserReference *sender;

+ (ChatMessage *)deserializeFromTCHMessage:(TCHMessage *)message;
+ (ChatMessage *)deserializeFromBody:(NSString *)body andType:(NSString *)type andSender:(NSDictionary *)sender;

@end
