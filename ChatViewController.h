//
//  ChatViewController.h
//  PushChat
//
//  Created by Ernesto Carrión on 2/22/12.
//  Copyright (c) 2012 Kogi Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageViewController.h"

@interface ChatViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, MessageDelegate> {

    __unsafe_unretained IBOutlet UITableView * chatsTableView;
}

@end
