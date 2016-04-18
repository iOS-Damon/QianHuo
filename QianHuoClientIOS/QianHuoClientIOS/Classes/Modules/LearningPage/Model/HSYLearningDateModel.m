//
//  HSYLearningMultiModel.m
//  QianHuoClientIOS
//
//  Created by Sean on 16/3/29.
//  Copyright © 2016年 deeepthinking. All rights reserved.
//

#import "HSYLearningDateModel.h"

@implementation HSYLearningDateModel

- (instancetype)initWithDateStr:(NSString *)dateStr {
    self = [super initWithDateStr:dateStr];
    if (self) {
        self.cellModels = [[NSArray alloc] init];
        self.cellModels = [self.cellModels arrayByAddingObjectsFromArray:self.androids];
        self.cellModels = [self.cellModels arrayByAddingObjectsFromArray:self.ioses];
        self.cellModels = [self.cellModels arrayByAddingObjectsFromArray:self.appes];
        self.cellModels = [self.cellModels arrayByAddingObjectsFromArray:self.htmls];
        self.cellModels = [self.cellModels arrayByAddingObjectsFromArray:self.resources];
        self.cellModels = [self.cellModels arrayByAddingObjectsFromArray:self.introduces];
    }
    return self;
}

@end
