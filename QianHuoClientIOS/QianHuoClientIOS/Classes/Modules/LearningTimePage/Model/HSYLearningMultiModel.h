//
//  HSYLearningMultiModel.h
//  QianHuoClientIOS
//
//  Created by Sean on 16/3/29.
//  Copyright © 2016年 deeepthinking. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSYLearningDateModel.h"

@interface HSYLearningMultiModel : NSObject

@property (nonatomic, strong) NSArray<HSYLearningDateModel *> *dateModels;

@end
