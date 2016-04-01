//
//  HSYRestVedioModel.m
//  QianHuoClientIOS
//
//  Created by Sean on 16/4/1.
//  Copyright © 2016年 deeepthinking. All rights reserved.
//

#import "HSYRestVedioModel.h"

@implementation HSYRestVedioModel

- (instancetype)initWithParam:(NSDictionary*)param {
    self = [super init];
    if (self) {
        self.type = param[@"type"];
        self.desc = param[@"desc"];
        self.url = param[@"url"];
    }
    return self;
}

@end
