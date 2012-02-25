//
//  MessageViewController.m
//  PushChat
//
//  Created by Ernesto Carrión on 2/22/12.
//  Copyright (c) 2012 Kogi Mobile. All rights reserved.
//

#import "MessageViewController.h"
#import <QuartzCore/QuartzCore.h>



@implementation MessageViewController

@synthesize delegate = _delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [textInput.layer setBackgroundColor: [[UIColor whiteColor] CGColor]];
    [textInput.layer setBorderColor: [[UIColor grayColor] CGColor]];
    [textInput.layer setBorderWidth: 1.0];
    [textInput.layer setCornerRadius:5.0];
    [textInput.layer setMasksToBounds:YES];
}

#pragma mark - IBActions

-(void)cancel:(id)sender {
    
    [self dismissModalViewControllerAnimated:YES];
}

-(void)send:(id)sender {
    
    Message * message = [[Message alloc] initWithText:textInput.text 
                                               author:@"Me"
                                                 date:[NSDate date] 
                                           ownMessage:YES];
    [_delegate messageAdded:message];
    
    [self dismissModalViewControllerAnimated:YES];
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
