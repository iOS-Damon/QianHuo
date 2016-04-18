//
//  HSYCommonModel.m
//  QianHuoClientIOS
//
//  Created by Sean on 16/4/16.
//  Copyright © 2016年 deeepthinking. All rights reserved.
//

#import "HSYCommonModel.h"

@implementation HSYCommonModel

- (void)saveWithParams:(NSDictionary*)params dateStr:(NSString*)dateStr {
    
    self.modelId = params[@"_id"];
    self.dateStr = dateStr;
    self.desc = params[@"desc"];
    self.type = params[@"type"];
    self.url = params[@"url"];
    self.isLike = NO;
    self.hasRead = NO;
    [self saveOrUpdateByColumnName:@"modelId" AndColumnValue:self.modelId];
}

@end
