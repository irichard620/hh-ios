//
//  ChatManager.h
//  hh-ios
//
//  Created by Ian Richard on 3/8/18.
//  Copyright © 2018 Ian Richard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StoreHelpers.h"

@interface ChatManager : NSObject

/*
 * Send chat message
 *
 * Arguments:
 * body of message
 * uniqueName of house
 *
 * Return:
 * None - just error or success
 */
+ (void)sendChatMessageWithBody:(NSString *)messageBody andUniqueName:(NSString *)uniqueName withCompletion:(void (^)(NSString *error))completion;

@end
