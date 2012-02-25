//
//  MessageViewController.h
//  PushChat
//
//  Created by Ernesto Carrión on 2/22/12.
//  Copyright (c) 2012 Kogi Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Message.h"

@protocol MessageDelegate

-(void)messageAdded:(Message *)message;

@end

@interface MessageViewController : UIViewController {
    
    __unsafe_unretained IBOutlet UITextView * textInput;
}

@property (nonatomic, unsafe_unretained) id<MessageDelegate> delegate;

-(IBAction)cancel:(id)sender;
-(IBAction)send:(id)sender;

@end
