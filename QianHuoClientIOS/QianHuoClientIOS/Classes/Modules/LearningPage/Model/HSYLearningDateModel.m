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
        NSString *sql = [NSString stringWithFormat:
                            @" WHERE dateStr = '%@' AND (type = '%@' OR type = '%@' OR type = '%@' OR type = '%@' OR type = '%@' OR type = '%@')",
                            dateStr,
                            @"Android",
                            @"iOS",
                            @"App",
                            @"前端",
                            @"拓展资源",
                            @"瞎推荐"
                         ];
        self.cellModels = [HSYCommonModel findWithFormat:@"%@", sql];
    }
    return self;
}

@end
