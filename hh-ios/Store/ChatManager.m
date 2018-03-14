//
//  ChatManager.m
//  hh-ios
//
//  Created by Ian Richard on 3/8/18.
//  Copyright © 2018 Ian Richard. All rights reserved.
//

#import "ChatManager.h"

@implementation ChatManager

+ (void)sendChatMessageWithBody:(NSString *)messageBody andUniqueName:(NSString *)uniqueName withCompletion:(void (^)(NSString *error))completion {
    // Pass unique name
    NSDictionary* parameters = @{@"unique_name": uniqueName, @"body": messageBody};
    
    // Send request
    [StoreHelpers sendPostRequestWithEndpoint:@"/chat/send" requiresAuth:YES hasParameters:parameters withCallback:^(NSDictionary *jsonResponse, NSString *errorType) {
        completion(errorType);
    }];
}

@end
