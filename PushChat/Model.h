//
//  Model.h
//  PushChat
//
//  Created by Ernesto Carrión on 2/24/12.
//  Copyright (c) 2012 Kogi Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Model : NSObject

+(Model *) sharedModel;

@property (nonatomic, strong)  NSString * udid;
@property (nonatomic, strong)  NSString * deviceToken;
@property (nonatomic, strong)  NSString * nickName;
@property (nonatomic, strong)  NSString * secretCode;


@end
