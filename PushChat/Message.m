//
//  Message.m
//  PushChat
//
//  Created by Ernesto Carrión on 2/24/12.
//  Copyright (c) 2012 Kogi Mobile. All rights reserved.
//

#import "Message.h"

@implementation Message

@synthesize text = _text;
@synthesize author = _author;
@synthesize date = _date;
@synthesize ownMessage = _ownMessage;

-(Message *)initWithText:(NSString *)text 
                  author:(NSString *)author 
                    date:(NSDate *)date 
              ownMessage:(BOOL)ownMessage {
    
    self = [super init];
    
    if (self) {
        
        _text = text;
        _author = author;
        _date = date;
        _ownMessage = ownMessage;
    }
    
    return self;
}

@end
