//
//  Payment.h
//  hh-ios
//
//  Created by Ian Richard on 12/30/17.
//  Copyright © 2017 Ian Richard. All rights reserved.
//
// Purpose: Data model for payment object

#import <Foundation/Foundation.h>
#import "UserReference.h"

@interface Payment : NSObject

// unique ID of the payment
@property (strong, nonatomic) NSString *_id;

// Reference to the user from where money will originate
@property (strong, nonatomic) UserReference *sourceUser;

// Reference to the user from where money will end up
@property (strong, nonatomic) UserReference *destinationUser;

// Description of the payment
@property (strong, nonatomic) NSString *paymentDescription;

// Timestamp of when payment was first created
@property (strong, nonatomic) NSDate *createdTimestamp; // Converted from string to date upon load

// Timestamp of when payment was completed - will be different from created if a request is involved
@property (strong, nonatomic) NSDate *completedTimestamp; // Converted from string to date upon load

// BOOL that says whether this payment was completed
@property (nonatomic) BOOL isCompleted;

// Decimal amount of money that is requested 
@property (nonatomic) float amount;

+ (Payment *) deserializePayment: (NSDictionary *)paymentJson;

@end
