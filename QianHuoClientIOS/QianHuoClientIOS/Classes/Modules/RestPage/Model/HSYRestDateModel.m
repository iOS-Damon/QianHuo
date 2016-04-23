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
        self.fulis = [HSYCommonModel findWithFormat:@" WHERE dateStr = '%@' AND type = '%@'", dateStr, @"福利"];
        self.vedios = [HSYCommonModel findWithFormat:@" WHERE dateStr = '%@' AND type = '%@'", dateStr, @"休息视频"];
        self.cellModels = [[NSArray alloc] init];
        self.cellModels = [self.cellModels arrayByAddingObjectsFromArray:self.fulis];
        self.cellModels = [self.cellModels arrayByAddingObjectsFromArray:self.vedios];
    }
    return self;
}

- (instancetype)initWithDateStr:(NSString *)dateStr params:(NSDictionary *)params {
    self = [super initWithDateStr:dateStr params:params];
    if (self) {
        NSArray *fuli = params[@"福利"];
        NSMutableArray *tempFulis = [[NSMutableArray alloc] initWithCapacity:3];
        if (!FYEmpty(fuli)) {
            for (NSDictionary *dict in fuli) {
                HSYCommonModel *model = [[HSYCommonModel alloc] initWithParams:dict dateStr:dateStr];
                [tempFulis addObject:model];
            }
        }
        self.fulis = tempFulis;
        
        NSArray *vedio = params[@"休息视频"];
        NSMutableArray *tempVedios = [[NSMutableArray alloc] initWithCapacity:3];
        if (!FYEmpty(vedio)) {
            for (NSDictionary *dict in vedio) {
                HSYCommonModel *model = [[HSYCommonModel alloc] initWithParams:dict dateStr:dateStr];
                model.avatarName = @"AvatarVedio.png";
                [tempVedios addObject:model];
            }
        }
        self.vedios = tempVedios;
        
        self.cellModels = [[NSArray alloc] init];
        self.cellModels = [self.cellModels arrayByAddingObjectsFromArray:self.fulis];
        self.cellModels = [self.cellModels arrayByAddingObjectsFromArray:self.vedios];
    }
    return self;
}

@end
