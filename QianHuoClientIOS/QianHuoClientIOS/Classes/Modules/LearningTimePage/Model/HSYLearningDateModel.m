//
//  HSYLearningMultiModel.m
//  QianHuoClientIOS
//
//  Created by Sean on 16/3/29.
//  Copyright © 2016年 deeepthinking. All rights reserved.
//

#import "HSYLearningDateModel.h"

@implementation HSYLearningDateModel

- (instancetype)initWithParam:(NSDictionary*)param {
    self = [super init];
    if (self) {
        self.dateStr = @"";
        self.headerTitle = @"";
        
        NSMutableArray *temp = [[NSMutableArray alloc] initWithCapacity:5];
        
        NSArray *android = param[@"Android"];
        for (NSDictionary *dict in android) {
            HSYLearningCellModel *cellModel = [[HSYLearningCellModel alloc] initWithParam:dict];
            [temp addObject:cellModel];
        }
        
        NSArray *ios = param[@"iOS"];
        for (NSDictionary *dict in ios) {
            HSYLearningCellModel *cellModel = [[HSYLearningCellModel alloc] initWithParam:dict];
            [temp addObject:cellModel];
        }
        
        self.cellModels = temp;
    }
    return self;
}

@end
