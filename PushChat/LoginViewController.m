//
//  LoginViewController.m
//  PushChat
//
//  Created by Ernesto Carrión on 2/22/12.
//  Copyright (c) 2012 Kogi Mobile. All rights reserved.
//

#import "LoginViewController.h"
#import "ChatViewController.h"
#import "MBProgressHUD.h"
#import "ASIFormDataRequest.h"

@interface LoginViewController ()

-(void)postJointRequest;

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       
        self.title = @"Push Chat";
    }
    return self;
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


#pragma mark . Private methods
-(void)postJointRequest {
    
    
    
     
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Connecting...";
    
    NSURL* url = [NSURL URLWithString:ServerApiURL];
    __unsafe_unretained ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL:url];
    [request setDelegate:self];
    
    Model * model = [Model sharedModel];
    
    [request setPostValue:@"join" forKey:@"cmd"];
    [request setPostValue:model.udid forKey:@"udid"];
    [request setPostValue:model.deviceToken forKey:@"token"];
    [request setPostValue:model.nickName forKey:@"name"];
    [request setPostValue:model.secretCode forKey:@"code"];
    
    [request setCompletionBlock:^ {
         
        [MBProgressHUD hideHUDForView:self.view animated:YES];
         
         if ([request responseStatusCode] != 200) {
             
             puts("Error");
             
         } else {
             
              NSString * nibNname = @"ChatViewController";
              if (IS_IPAD)
                  nibNname  = @"ChatViewController_iPad";
              
              ChatViewController * cvc =[[ChatViewController alloc] initWithNibName:nibNname bundle:nil];
              [self.navigationController pushViewController:cvc animated:YES];
         }
         
     }];
    
    [request setFailedBlock:^
     {
         
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         puts("error");
        
     }];
    
    [request startAsynchronous];
    
    
    
}

#pragma mark - IBActions
-(void)joinChatRoom:(id)sender {
    
    [[Model sharedModel] setNickName:nickname.text];
    [[Model sharedModel] setSecretCode:secret.text];
    
    [self postJointRequest];
}

#pragma mark - UItextfield Delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    return [textField resignFirstResponder];
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
