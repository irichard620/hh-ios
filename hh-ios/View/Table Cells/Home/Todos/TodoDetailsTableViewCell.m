//
//  TodoDetailsTableViewCell.m
//  hh-ios
//
//  Created by Ian Richard on 2/20/18.
//  Copyright © 2018 Ian Richard. All rights reserved.
//

#import "TodoDetailsTableViewCell.h"

@implementation TodoDetailsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)restrictEditForNonOwner {
    self.titleField.userInteractionEnabled = NO;
    self.descrTextView.userInteractionEnabled = NO;
}

- (void)displayNewAssignee:(NSString *)fullName {
    self.assigneeLabel.textColor = [UIColor blackColor];
    self.assigneeLabel.text = [NSString stringWithFormat:@"Assignee: %@", fullName];
}

- (NSString *)getCurrentAssignee {
    if (self.assigneeLabel.text.length > 10) {
        return [self.assigneeLabel.text substringFromIndex:10];
    } else {
        return nil;
    }
}

@end
