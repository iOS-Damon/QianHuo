//
//  HSYRestDateModel.m
//  QianHuoClientIOS
//
//  Created by Sean on 16/4/1.
//  Copyright © 2016年 deeepthinking. All rights reserved.
//

#import "HSYRestDateModel.h"

@implementation HSYRestDateModel

- (instancetype)initWithDateStr:(NSString *)dateStr {
    self = [super initWithDateStr:dateStr];
    if (self) {
        self.cellModels = [[NSArray alloc] init];
        self.cellModels = [self.cellModels arrayByAddingObjectsFromArray:self.fulis];
        self.cellModels = [self.cellModels arrayByAddingObjectsFromArray:self.vedios];
    }
    return self;
}

@end
