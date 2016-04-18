//
//  HSYCommonModel.m
//  QianHuoClientIOS
//
//  Created by Sean on 16/4/16.
//  Copyright © 2016年 deeepthinking. All rights reserved.
//

#import "HSYCommonModel.h"

@implementation HSYCommonModel

- (instancetype)initWithParams:(NSDictionary*)params dateStr:(NSString*)dateStr {
    self = [super init];
    if (self) {
        self.modelId = params[@"_id"];
        self.dateStr = dateStr;
        self.desc = params[@"desc"];
        self.type = params[@"type"];
        self.url = params[@"url"];
        self.avatarName = @"";
        self.isLike = NO;
        self.hasRead = NO;
    }
    return self;
}

@end
