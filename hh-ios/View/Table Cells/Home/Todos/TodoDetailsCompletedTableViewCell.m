//
//  TodoDetailsCompletedTableViewCell.m
//  hh-ios
//
//  Created by Ian Richard on 4/9/18.
//  Copyright © 2018 Ian Richard. All rights reserved.
//

#import "TodoDetailsCompletedTableViewCell.h"

@implementation TodoDetailsCompletedTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setUpForTitle:(NSString *)title andDescription:(NSString *)description andCreatedBy:(NSString *)createdBy andCompletedBy:(NSString *)completedBy andTimeTaken:(NSString *)timeTaken {
    self.titleLabel.text = title;
    self.descriptionLabel.text = description;
    self.createdByLabel.text = createdBy;
    self.completedByLabel.text = completedBy;
    self.timeTakenLabel.text = timeTaken;
}

@end
