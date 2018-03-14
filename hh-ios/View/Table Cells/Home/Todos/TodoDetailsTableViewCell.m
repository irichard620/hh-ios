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
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)restrictEdit {
    self.titleField.userInteractionEnabled = NO;
    self.descrTextView.userInteractionEnabled = NO;
}

- (void)allowEdit {
    self.titleField.userInteractionEnabled = YES;
    self.descrTextView.userInteractionEnabled = YES;
}

- (void)setupForCreateWithCreatedBy:(NSString *)createdBy andAssignee:(NSString *)assignee {
    [self setupWithTitle:nil andDescr:nil isCreate:YES canEdit:YES withCreatedBy:createdBy isComplete:NO withDataLabel:assignee];
}

- (void)setupForEditWithTitle:(NSString *)title andDescr:(NSString *)description andCreatedBy:(NSString *)createdBy andAssignee:(NSString *)assignee {
    [self setupWithTitle:title andDescr:description isCreate:NO canEdit:YES withCreatedBy:createdBy isComplete:NO withDataLabel:assignee];
}

- (void)setupForViewWithTitle:(NSString *)title andDescr:(NSString *)description andCreatedBy:(NSString *)createdBy andAssignee:(NSString *)assignee {
    [self setupWithTitle:title andDescr:description isCreate:NO canEdit:NO withCreatedBy:createdBy isComplete:NO withDataLabel:assignee];
}

- (void)setupForCompleteWithTitle:(NSString *)title andDescr:(NSString *)description andCreatedBy:(NSString *)createdBy {
    [self setupWithTitle:title andDescr:description isCreate:NO canEdit:NO withCreatedBy:createdBy isComplete:YES withDataLabel:nil];
}

- (void)setupWithTitle:(NSString *)title andDescr:(NSString *)description andCreatedBy:(NSString *)createdBy andAssignee:(NSString *)assignee {
    self.titleField.text = title;
    self.descrTextView.text = description;
    self.descrTextView.textColor = [UIColor blackColor];
    self.createdByLabel.text = createdBy;
    self.assigneeSectionLabel.text = @"Assigned To:";
    self.assigneeLabel.text = assignee;
}

- (void)setupWithTitle:(NSString *)title andDescr:(NSString *)description isCreate:(BOOL)isCreate canEdit:(BOOL)canEdit withCreatedBy:(NSString *)createdBy isComplete:(BOOL)isComplete withDataLabel:(NSString *)dataLabel {
    if (isCreate) {
        [self allowEdit];
        self.titleField.text = @"";
        self.descrTextView.text = @"Description";
        self.descrTextView.textColor = [UIColor lightGrayColor];
    } else {
        if (canEdit) {
            [self allowEdit];
        } else {
            [self restrictEdit];
        }
        self.titleField.text = title;
        self.descrTextView.text = description;
        self.descrTextView.textColor = [UIColor blackColor];
    }
    self.createdByLabel.text = createdBy;
    if (isComplete) {
        self.assigneeSectionLabel.text = @"Time Taken:";
        self.assigneeLabel.text = @"5 minutes";
    } else {
        self.assigneeSectionLabel.text = @"Assigned To:";
        self.assigneeLabel.text = dataLabel;
    }
}

- (void)setDataLabel:(NSString *)dataLabel {
    self.assigneeLabel.text = dataLabel;
}

@end
