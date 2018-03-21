//
//  ChatMessage.m
//  hh-ios
//
//  Created by Ian Richard on 3/16/18.
//  Copyright © 2018 Ian Richard. All rights reserved.
//

#import "ChatMessage.h"

@implementation ChatMessage

+ (ChatMessage *)deserializeFromTCHMessage:(TCHMessage *)message {
    ChatMessage *chatMessage = [[ChatMessage alloc]init];
    chatMessage.messageBody = [message body];
    chatMessage.type = [message.attributes objectForKey:@"type"];
    if ([chatMessage.type isEqualToString:@"chat"]) {
        chatMessage.sender = [UserReference deserializeUserRef:[message.attributes objectForKey:@"user"]];
    }
    return chatMessage;
}

+ (ChatMessage *)deserializeFromBody:(NSString *)body andType:(NSString *)type andSender:(NSDictionary *)sender {
    ChatMessage *chatMessage = [[ChatMessage alloc]init];
    chatMessage.messageBody = body;
    chatMessage.type = type;
    if ([chatMessage.type isEqualToString:@"chat"]) {
        chatMessage.sender = [UserReference deserializeUserRef:sender];
    }
    return chatMessage;
}

@end
