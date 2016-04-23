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
                            @"iOS",
                            @"Android",
                            @"App",
                            @"前端",
                            @"拓展资源",
                            @"瞎推荐"
                         ];
        self.cellModels = [HSYCommonModel findWithFormat:@"%@", sql];
    }
    return self;
}

- (instancetype)initWithDateStr:(NSString *)dateStr params:(NSDictionary *)params {
    self = [super initWithDateStr:dateStr params:params];
    if (self) {
        
        NSArray *ioses = params[@"iOS"];
        self.ioses = [self makeModelsWithParams:ioses dateStr:dateStr avatarName:@"AvatarIOS.png"];
        
        NSArray *android = params[@"Android"];
        self.androids = [self makeModelsWithParams:android dateStr:dateStr avatarName:@"AvatarAndroid.png"];
        
        NSArray *app = params[@"App"];
        self.appes = [self makeModelsWithParams:app dateStr:dateStr avatarName:@"AvatarApp.png"];
        
        NSArray *html = params[@"前端"];
        self.htmls = [self makeModelsWithParams:html dateStr:dateStr avatarName:@"AvatarHtml.png"];
        
        NSArray *resource = params[@"拓展资源"];
        self.resources = [self makeModelsWithParams:resource dateStr:dateStr avatarName:@"AvatarResource.png"];
        
        NSArray *introduce = params[@"瞎推荐"];
        self.introduces = [self makeModelsWithParams:introduce dateStr:dateStr avatarName:@"AvatarIntroduce.png"];
        
        self.cellModels = [[NSArray alloc] init];
        self.cellModels = [self.cellModels arrayByAddingObjectsFromArray:self.ioses];
        self.cellModels = [self.cellModels arrayByAddingObjectsFromArray:self.androids];
        self.cellModels = [self.cellModels arrayByAddingObjectsFromArray:self.appes];
        self.cellModels = [self.cellModels arrayByAddingObjectsFromArray:self.htmls];
        self.cellModels = [self.cellModels arrayByAddingObjectsFromArray:self.resources];
        self.cellModels = [self.cellModels arrayByAddingObjectsFromArray:self.introduces];
    }
    return self;
}

- (NSArray*)makeModelsWithParams:(NSArray*)params dateStr:(NSString*)dateStr avatarName:(NSString*)avaterName {
    NSMutableArray *temps = [[NSMutableArray alloc] initWithCapacity:3];
    if (!FYEmpty(params)) {
        for (NSDictionary *dict in params) {
            HSYCommonModel *model = [[HSYCommonModel alloc] initWithParams:dict dateStr:dateStr];
            model.avatarName = avaterName;
            [temps addObject:model];
        }
    }
    return temps;
}

@end
