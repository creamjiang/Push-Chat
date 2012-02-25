//
//  Model.m
//  PushChat
//
//  Created by Ernesto Carrión on 2/24/12.
//  Copyright (c) 2012 Kogi Mobile. All rights reserved.
//

#import "Model.h"

#define DEFINE_SHARED_INSTANCE_USING_BLOCK(block) \
static dispatch_once_t pred = 0;                \
__strong static id _sharedObject = nil;         \
dispatch_once(&pred, ^{                         \
_sharedObject = block();                        \
});                                             \
return _sharedObject;                           \


@implementation Model

@synthesize deviceToken, udid, nickName, secretCode;

+(Model *) sharedModel {
    
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
        return [[self alloc] init];
    });
}

- (id)init {
    
    self = [super init];
    
    if (self) {
        
        udid = [[[UIDevice currentDevice] uniqueIdentifier] stringByReplacingOccurrencesOfString:@"-" withString:@""];
    }
    
    return self;
}



@end
