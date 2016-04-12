//
//  HSYRestVedioModel.m
//  QianHuoClientIOS
//
//  Created by Sean on 16/4/1.
//  Copyright © 2016年 deeepthinking. All rights reserved.
//

#import "HSYRestVedioModel.h"
#import "HSYUserDefaults.h"

@implementation HSYRestVedioModel

- (instancetype)initWithParam:(NSDictionary*)param {
    self = [super init];
    if (self) {
        self.cellId = param[@"_id"];
        self.type = param[@"type"];
        self.desc = param[@"desc"];
        self.url = param[@"url"];
        self.hasRead = [HSYUserDefaults BoolForKey:self.cellId];
    }
    return self;
}

@end
