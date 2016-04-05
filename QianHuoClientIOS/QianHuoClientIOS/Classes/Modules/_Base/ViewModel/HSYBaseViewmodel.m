//
//  HSYBaseViewmodel.m
//  QianHuoClientIOS
//
//  Created by Sean on 16/3/28.
//  Copyright © 2016年 deeepthinking. All rights reserved.
//

#import "HSYBaseViewmodel.h"

@implementation HSYBaseViewmodel

- (instancetype)init {
    if (self = [super init]) {
        self.isFirstLoad = YES;
    }
    return self;
}

- (void)saveSection:(NSInteger)section {

}

- (void)saveOffsetY:(CGFloat)offsetY {

}

- (CGFloat)loadOffsetY {
    return 0;
}

@end
