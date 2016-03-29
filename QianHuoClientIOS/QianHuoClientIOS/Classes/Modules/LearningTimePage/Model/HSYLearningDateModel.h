//
//  HSYLearningMultiModel.h
//  QianHuoClientIOS
//
//  Created by Sean on 16/3/29.
//  Copyright © 2016年 deeepthinking. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSYLearningCellModel.h"

@interface HSYLearningDateModel : NSObject

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSArray<HSYLearningCellModel *> *cellModels;

@end
