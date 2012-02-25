//
//  Message.h
//  PushChat
//
//  Created by Ernesto Carrión on 2/24/12.
//  Copyright (c) 2012 Kogi Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Message : NSObject


@property (nonatomic, strong) NSString * text;
@property (nonatomic, strong) NSDate * date;
@property (nonatomic, strong) NSString * author;
@property (nonatomic, assign) BOOL ownMessage;


-(Message *)initWithText:(NSString *)text 
                  author:(NSString *)author 
                    date:(NSDate *)date 
              ownMessage:(BOOL)ownMessage;

@end
