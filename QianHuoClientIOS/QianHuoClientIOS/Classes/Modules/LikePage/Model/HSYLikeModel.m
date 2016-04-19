//
//  HSYLikeModel.m
//  QianHuoClientIOS
//
//  Created by Sean on 16/4/19.
//  Copyright © 2016年 deeepthinking. All rights reserved.
//

#import "HSYLikeModel.h"

@implementation HSYLikeModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.cellModels = [HSYCommonModel findWithFormat:@"WHERE isLike = 1 ORDER BY dateStr DESC"];
    }
    return self;
}

@end
