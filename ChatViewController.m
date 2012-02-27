//
//  ChatViewController.m
//  PushChat
//
//  Created by Ernesto Carrión on 2/22/12.
//  Copyright (c) 2012 Kogi Mobile. All rights reserved.
//

#import "ChatViewController.h"
#import "Message.h"
#import "ASIFormDataRequest.h"
#import "MBProgressHUD.h"

@interface ChatViewController ()

-(void)exitRoom;
-(void)composeMessage;
-(void)postLeaveRequest;
-(void)incommingMessage:(NSNotification *)noti;

@end

@implementation ChatViewController {
    
    NSMutableArray * messages;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.title = @"Chat Room";
        
        //Create Top Buttons
        UIBarButtonItem * exit = [[UIBarButtonItem alloc] initWithTitle:@"Exit" 
                                                                  style:UIBarButtonItemStylePlain 
                                                                 target:self 
                                                                 action:@selector(exitRoom)];
        UIBarButtonItem * compose = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose 
                                                                                  target:self 
                                                                                  action:@selector(composeMessage)];
        [self.navigationItem setLeftBarButtonItem:exit];
        [self.navigationItem setRightBarButtonItem:compose];
        
        
        messages = [NSMutableArray array];
        
        
        //NSnotification 
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(incommingMessage:) 
                                                     name:@"message" 
                                                   object:nil];
        
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


#pragma mark - Private Methods

- (void)postLeaveRequest
{
    
	MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
	hud.labelText = NSLocalizedString(@"Signing Out", nil);
    
	NSURL* url = [NSURL URLWithString:ServerApiURL];
	__unsafe_unretained ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL:url];
	[request setDelegate:self];
    
	[request setPostValue:@"leave" forKey:@"cmd"];
	[request setPostValue:[[Model sharedModel] udid] forKey:@"udid"];
    
	[request setCompletionBlock:^ {
        

             [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
             
             if ([request responseStatusCode] != 200) {
                 
                 puts("error");
                 
             } else {
                 
                 [self.navigationController popViewControllerAnimated:YES];
             }
     }];
    
	[request setFailedBlock:^ {
        
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        puts("error");
        
     }];
    
	[request startAsynchronous];
     
}

-(void)exitRoom {
    
    [self postLeaveRequest];
}

-(void)composeMessage {
    
    //new message
    
    NSString * nibNname = @"MessageViewController";
    if (IS_IPAD)
        nibNname  = @"MessageViewController_iPad";
    
    MessageViewController * mvc = [[MessageViewController alloc] initWithNibName:nibNname bundle:nil];
    mvc.delegate = self;
    
    if (IS_IPAD) {
        mvc.modalPresentationStyle = UIModalPresentationFormSheet;
    }
    
    [self presentModalViewController:mvc animated:YES];

}

-(void)messageAdded:(Message *)message {
    
    [messages addObject:message];
    
    NSIndexPath * ip = [NSIndexPath indexPathForRow:messages.count-1 inSection:0];
    
    [chatsTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:ip] 
                          withRowAnimation:UITableViewRowAnimationTop];
}


-(void)incommingMessage:(NSNotification *)noti {
    
    
    NSString* alertValue = [[noti.userInfo valueForKey:@"aps"] valueForKey:@"alert"];
    NSArray * messageData = [alertValue componentsSeparatedByString:@": "];
    NSString * name = [messageData objectAtIndex:0];
    NSString * messageText = [messageData objectAtIndex:1];
    
    Message * message = [[Message alloc] initWithText:messageText 
                                               author:name 
                                                 date:[NSDate date] 
                                           ownMessage:NO];
    
    [self messageAdded:message];
}

#pragma mark - TableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [messages count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString * identifier = @"chatCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    Message * message = [messages objectAtIndex:indexPath.row];
    
    cell.textLabel.text = message.text;
    
    if (!message.ownMessage) {
        cell.textLabel.textAlignment = UITextAlignmentLeft;
    } else {
        cell.textLabel.textAlignment = UITextAlignmentRight;
    }
    
    return cell;
}

-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"message" object:nil];
}


#pragma mark - Rotate
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if (IS_IPAD) {
        return (UIInterfaceOrientationIsLandscape(interfaceOrientation));
    } else  {
        return (UIInterfaceOrientationIsPortrait(interfaceOrientation));
    }
}

@end
