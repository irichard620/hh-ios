//
//  ChatViewController.m
//  hh-ios
//
//  Created by Ian Richard on 11/13/17.
//  Copyright © 2017 Ian Richard. All rights reserved.
//

#import "ChatViewController.h"
#import "SWRevealViewController.h"
#import "ViewHelpers.h"
#import "ChatMessageTableViewCell.h"
#import "ChatTimeTableViewCell.h"
#import "ChatActionTableViewCell.h"
#import "ChatManager.h"
#import "UserHomeTableViewCell.h"
#import "ChatMessage.h"

@interface ChatViewController ()

@property (nonatomic) BOOL isLoading;

@property (strong, nonatomic) NSMutableArray *chatArray;
@property (nonatomic) NSString *currentMessage;

@end

@implementation ChatViewController

- (void)shouldDealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (id)init {
    self = [super initWithTableViewStyle:UITableViewStylePlain];
    if (self) {
        _isLoading = YES;
        _chatArray = [[NSMutableArray alloc]init];
        _currentMessage = @"";
        
        // Notifications
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(chatMessageCreated:) name:CHAT_MESSAGE object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Set bar color
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.00 green:0.59 blue:0.53 alpha:1.0];
    self.navigationItem.title = @"Home";
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.navigationController.navigationBar.largeTitleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.navigationController.navigationBar.prefersLargeTitles = YES;
    
    // Set color of text bar
    self.textInputbar.backgroundColor = [UIColor whiteColor];
    
    // Setup SLK Controller
    self.inverted = NO;
    self.textView.maxNumberOfLines = 6;
    self.shouldScrollToBottomAfterKeyboardShows = YES;
    self.textView.placeholder = @"Send Message...";
    self.textView.delegate = self;
    
    [self.rightButton addTarget:self action:@selector(sendChatMessage:) forControlEvents:UIControlEventTouchUpInside];
    [self.textInputbar.leftButton2 addTarget:self action:@selector(createTodo:) forControlEvents:UIControlEventTouchUpInside];
    
    // Setup table view
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // Add gesture recognizer for reveal controller
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
    
    // Create menu button
    self.navigationItem.leftBarButtonItem = [ViewHelpers createNavButtonWithTarget:self.revealViewController andSelectorName:@"revealToggle:" andImage:[UIImage imageNamed:@"menu.png"] isBack:NO];
    
    // Setup table
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];

    // Go to setup
    [self getMessages];
}

#pragma mark Setup Twilio

- (void)getMessages {
    NSLog(@"GEt messages: %@", self.channel);
    [[self.channel messages] getLastMessagesWithCount:20 completion:^(TCHResult * _Nonnull result, NSArray<TCHMessage *> * _Nullable messages) {
        // Messages are listed in order
        NSLog(@"Messages: %@", messages);
        for (int i = 0; i < messages.count; i++) {
            [self.chatArray addObject:[ChatMessage deserializeFromTCHMessage:[messages objectAtIndex:i]]];
        }
        self.isLoading = NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            if (self.tableView.contentSize.height > self.tableView.bounds.size.height) {
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.chatArray.count - 2 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            }
        });
    }];
}

#pragma mark Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Only one section
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Fake info
    if (self.isLoading || self.chatArray.count == 0) {
        return 1;
    } else {
        return self.chatArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // If Twilio class - display message
    if (self.isLoading || self.chatArray.count == 0) {
        // No image cell
        static NSString *CellIdentifier = @"userHomeCell";
        UserHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            [self.tableView registerNib:[UINib nibWithNibName:@"UserHomeTableViewCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        }
        
        if (self.isLoading) {
            [cell setNoImageCellWithText:@"Loading..."];
        } else {
            [cell setNoImageCellWithText:@"No chat messages to show."];
        }
        return cell;
    } else if ([[self.chatArray objectAtIndex:indexPath.row]isKindOfClass:[ChatMessage class]]) {
        // Twilio message
        ChatMessage *message = (ChatMessage *)[self.chatArray objectAtIndex:indexPath.row];
        if ([message.type isEqualToString:CHAT_MESSAGE]) {
            static NSString *CellIdentifier = @"messageCell";
            ChatMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil) {
                [self.tableView registerNib:[UINib nibWithNibName:@"ChatMessageTableViewCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
                cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            }
            
            // Set cell
            [cell setName:message.sender.name andMessage:message.messageBody andAvatarLink:message.sender.avatarLink showMarker:[message.sender._id isEqualToString:self.user._id]];
            
            return cell;
        } else {
            static NSString *CellIdentifier = @"actionCell";
            ChatActionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil) {
                [self.tableView registerNib:[UINib nibWithNibName:@"ChatActionTableViewCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
                cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            }
            if ([message.type isEqualToString:CREATE_TODO_MESSAGE] ||
                [message.type isEqualToString:EDIT_TODO_MESSAGE] ||
                [message.type isEqualToString:COMPLETE_TODO_MESSAGE] ||
                [message.type isEqualToString:DELETE_TODO_MESSAGE]) {
                // Todo action
                [cell setTodoAction:message.messageBody];
            } else if ([message.type isEqualToString:EDIT_HOUSE_MESSAGE] ||
                       [message.type isEqualToString:MEMBER_ADDED] ||
                       [message.type isEqualToString:MEMBER_REMOVED]) {
                // House action
                [cell setHouseAction:message.messageBody];
            } else {
                // Payment action
                [cell setPaymentAction:message.messageBody];
            }
            return cell;
        }
        
    } else {
        // Date object
        static NSString *CellIdentifier = @"timeCell";
        ChatTimeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            [self.tableView registerNib:[UINib nibWithNibName:@"ChatTimeTableViewCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        }
        
        [cell setTime:@"Mon, 8:15pm"];
        
        return cell;
    }
}

#pragma mark  Text editing

- (void)textViewDidChange:(UITextView *)textView {
    NSLog(@"Text view: %@", textView.text);
    self.currentMessage = textView.text;
}

- (void)sendChatMessage:(id)sender {
    [ChatManager sendChatMessageWithBody:self.currentMessage andUniqueName:self.house.uniqueName withCompletion:^(NSString *error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self presentViewController:[ViewHelpers createErrorAlertWithTitle:@"Error" andDescription:error] animated:YES completion:nil];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.textView setText:@""];
                [self.view endEditing:YES];
            });
        }
        // If no error, wait for TCHMessage
    }];
}

- (void)createTodo:(id)sender {
    TodoDetailsViewController *vc = [[TodoDetailsViewController alloc]initWithNibName:@"TodoDetailsViewController" bundle:nil];
    vc.type = CREATE_TYPE;
    vc.user = self.user;
    vc.house = self.house;
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark Notifications

- (void)chatMessageCreated:(NSNotification *)notification {
    [self.chatArray addObject:[ChatMessage deserializeFromBody:[notification.userInfo objectForKey:@"body"] andType:[notification.userInfo objectForKey:@"type"] andSender:[notification.userInfo objectForKey:@"user"]]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.chatArray.count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.chatArray.count - 2 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    });
}

#pragma mark Delegate

- (void)todoCreated:(ToDo *)todo {}
- (void)todoCompleted:(ToDo *)todo {}
- (void)todoDeletedWithId:(NSString *)todoId {}
- (void)todoEdited:(ToDo *)todo {}

@end
