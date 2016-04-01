//
//  HSYRestCellModel.m
//  QianHuoClientIOS
//
//  Created by Sean on 16/4/1.
//  Copyright © 2016年 deeepthinking. All rights reserved.
//

#import "HSYRestFuliModel.h"

@implementation HSYRestFuliModel

- (instancetype)initWithParam:(NSDictionary*)param {
    self = [super init];
    if (self) {
        self.url = param[@"url"];
    }
    return self;
}

@end
