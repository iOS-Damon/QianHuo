//
//  HSYLearningTimeCellModel.h
//  QianHuoClientIOS
//
//  Created by Sean on 16/3/29.
//  Copyright © 2016年 deeepthinking. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSYBaseModel.h"

@interface HSYLearningCellModel : HSYBaseModel

@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *url;

- (instancetype)initWithParam:(NSDictionary*)param;

@end
