//
//  HSYLearningMultiModel.h
//  QianHuoClientIOS
//
//  Created by Sean on 16/3/29.
//  Copyright © 2016年 deeepthinking. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSYBaseModel.h"
#import "HSYLearningCellModel.h"

@interface HSYLearningDateModel : HSYBaseModel

@property (nonatomic, strong) NSString *dateStr;
@property (nonatomic, strong) NSString *headerTitle;
@property (nonatomic, strong) NSArray<HSYLearningCellModel *> *cellModels;

- (instancetype)initWithParam:(NSDictionary*)param;

@end
