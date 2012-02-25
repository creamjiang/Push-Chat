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
        for (int i = 0; i < 7; i++) {
            
            NSString * men = [NSString stringWithFormat:@"Message %d", i];
            Message * message = [[Message alloc] initWithText:men 
                                                       author:@"Author" 
                                                         date:[NSDate date] 
                                                   ownMessage:(i % 2)];
            [messages addObject:message];
        }
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
                 
                 [self userDidLeave];
             }
     }];
    
	[request setFailedBlock:^
     {
         if ([self isViewLoaded])
         {
             [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
             ShowErrorAlert([[request error] localizedDescription]);
         }
     }];
    
	[request startAsynchronous];
}

-(void)exitRoom {
    
    [self postLeaveRequest];
    
    [self.navigationController popViewControllerAnimated:YES];
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
