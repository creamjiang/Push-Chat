//
//  LoginViewController.h
//  PushChat
//
//  Created by Ernesto Carrión on 2/22/12.
//  Copyright (c) 2012 Kogi Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController <UITextFieldDelegate> {
    
    __unsafe_unretained IBOutlet UITextField * nickname;
    __unsafe_unretained IBOutlet UITextField * secret;
}


-(IBAction)joinChatRoom:(id)sender;

@end
