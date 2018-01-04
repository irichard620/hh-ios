//
//  Payment.m
//  hh-ios
//
//  Created by Ian Richard on 12/30/17.
//  Copyright © 2017 Ian Richard. All rights reserved.
//

#import "Payment.h"

@implementation Payment

+ (Payment *) deserializePayment:(NSDictionary *)paymentJson {
    Payment *payment = [[Payment alloc]init];
    payment.sourceUser = [[UserReference alloc]init];
    payment.destinationUser = [[UserReference alloc]init];
    NSDictionary *jSourceUser = paymentJson[@"sourceUser"];
    payment.sourceUser._id = jSourceUser[@"_id"];
    payment.sourceUser.name = jSourceUser[@"name"];
    payment.sourceUser.avatarLink = jSourceUser[@"avatarLink"];
    NSDictionary *jDestinationUser = paymentJson[@"destinationUser"];
    payment.destinationUser._id = jDestinationUser[@"_id"];
    payment.destinationUser.name = jDestinationUser[@"name"];
    payment.destinationUser.avatarLink = jDestinationUser[@"avatarLink"];
    payment.paymentDescription = paymentJson[@"paymentDescription"];
    payment.isCompleted = [paymentJson[@"isCompleted"]boolValue];
    payment.amount = [paymentJson[@"amount"]floatValue];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    payment.createdTimestamp = [dateFormat dateFromString:paymentJson[@"createdTimestamp"]];
    payment.completedTimestamp = [dateFormat dateFromString:paymentJson[@"completedTimestamp"]];
    
    return payment;
}
@end
