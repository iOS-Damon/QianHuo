//
//  HSYCommonModel.h
//  QianHuoClientIOS
//
//  Created by Sean on 16/4/16.
//  Copyright © 2016年 deeepthinking. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JKDBModel.h"

@interface HSYCommonModel : JKDBModel

@property (nonatomic, copy) NSString *modelId;
@property (nonatomic, copy) NSString *dateStr;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *avatarName;
@property (nonatomic, assign) BOOL isLike;
@property (nonatomic, assign) BOOL hasRead;

- (instancetype)initWithParams:(NSDictionary*)params dateStr:(NSString*)dateStr;

@end
