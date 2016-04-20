//
//  HSYCommenDateModel.m
//  QianHuoClientIOS
//
//  Created by Sean on 16/4/17.
//  Copyright © 2016年 deeepthinking. All rights reserved.
//

#import "HSYCommenDateModel.h"
#import "HSYCommonModel.h"

@implementation HSYCommenDateModel

+ (void)saveWithParams:(NSDictionary*)params dateStr:(NSString*)dateStr {
    
    NSMutableArray *tempModels = [[NSMutableArray alloc] initWithCapacity:5];
    
    NSArray *android = params[@"Android"];
    if(!FYEmpty(android)) {
        for (NSDictionary *dict in android) {
            HSYCommonModel *model = [HSYCommonModel findFirstWithFormat:@"WHERE modelId = '%@'", params[@"_id"]];
            if (!model) {
                model = [[HSYCommonModel alloc] initWithParams:dict dateStr:dateStr];
                model.avatarName = @"AvatarAndroid.png";
                [tempModels addObject:model];
            }
        }
    }
    
    NSArray *ios = params[@"iOS"];
    if(!FYEmpty(android)) {
        for (NSDictionary *dict in ios) {
            HSYCommonModel *model = [HSYCommonModel findFirstWithFormat:@"WHERE modelId = '%@'", params[@"_id"]];
            if (!model) {
                model = [[HSYCommonModel alloc] initWithParams:dict dateStr:dateStr];
                model.avatarName = @"AvatarIOS.png";
                [tempModels addObject:model];
            }
        }
    }
    
    NSArray *app = params[@"App"];
    if(!FYEmpty(android)) {
        for (NSDictionary *dict in app) {
            HSYCommonModel *model = [HSYCommonModel findFirstWithFormat:@"WHERE modelId = '%@'", params[@"_id"]];
            if (!model) {
                model = [[HSYCommonModel alloc] initWithParams:dict dateStr:dateStr];
                model.avatarName = @"AvatarApp.png";
                [tempModels addObject:model];
            }
        }
    }
    
    NSArray *html = params[@"前端"];
    if(!FYEmpty(android)) {
        for (NSDictionary *dict in html) {
            HSYCommonModel *model = [HSYCommonModel findFirstWithFormat:@"WHERE modelId = '%@'", params[@"_id"]];
            if (!model) {
                model = [[HSYCommonModel alloc] initWithParams:dict dateStr:dateStr];
                model.avatarName = @"AvatarHtml.png";
                [tempModels addObject:model];
            }
        }
    }
    
    NSArray *resource = params[@"拓展资源"];
    if(!FYEmpty(android)) {
        for (NSDictionary *dict in resource) {
            HSYCommonModel *model = [HSYCommonModel findFirstWithFormat:@"WHERE modelId = '%@'", params[@"_id"]];
            if (!model) {
                model = [[HSYCommonModel alloc] initWithParams:dict dateStr:dateStr];
                model.avatarName = @"AvatarResource.png";
                [tempModels addObject:model];
            }
        }
    }
    
    NSArray *introduce = params[@"瞎推荐"];
    if(!FYEmpty(android)) {
        for (NSDictionary *dict in introduce) {
            HSYCommonModel *model = [HSYCommonModel findFirstWithFormat:@"WHERE modelId = '%@'", params[@"_id"]];
            if (!model) {
                model = [[HSYCommonModel alloc] initWithParams:dict dateStr:dateStr];
                model.avatarName = @"AvatarIntroduce.png";
                [tempModels addObject:model];
            }
        }
    }
    
    NSArray *fuli = params[@"福利"];
    if (!FYEmpty(fuli)) {
        for (NSDictionary *dict in fuli) {
            HSYCommonModel *model = [HSYCommonModel findFirstWithFormat:@"WHERE modelId = '%@'", params[@"_id"]];
            if (!model) {
                model = [[HSYCommonModel alloc] initWithParams:dict dateStr:dateStr];
                [tempModels addObject:model];
            }
        }
    }
    
    NSArray *vedio = params[@"休息视频"];
    if (!FYEmpty(vedio)) {
        for (NSDictionary *dict in vedio) {
            HSYCommonModel *model = [HSYCommonModel findFirstWithFormat:@"WHERE modelId = '%@'", params[@"_id"]];
            if (!model) {
                model = [[HSYCommonModel alloc] initWithParams:dict dateStr:dateStr];
                model.avatarName = @"AvatarVedio.png";
                [tempModels addObject:model];
            }
        }
    }
    
    [HSYCommonModel saveObjects:tempModels];
}

+ (BOOL)hasValueWithDateStr:(NSString*)dateStr {
    HSYCommonModel *model = [HSYCommonModel findFirstWithFormat:@"WHERE dateStr = '%@'", dateStr];
    if (model) {
        return YES;
    } else {
        return NO;
    }
}

- (instancetype)initWithDateStr:(NSString*)dateStr {
    self = [super init];
    if (self) {
        self.headerTitle = [self formatWithDateStr:dateStr];
        self.androids = [HSYCommonModel findWithFormat:@" WHERE dateStr = '%@' AND type = '%@'", dateStr, @"Android"];
        self.ioses = [HSYCommonModel findWithFormat:@" WHERE dateStr = '%@' AND type = '%@'", dateStr, @"iOS"];
        self.appes = [HSYCommonModel findWithFormat:@" WHERE dateStr = '%@' AND type = '%@'", dateStr, @"App"];
        self.htmls = [HSYCommonModel findWithFormat:@" WHERE dateStr = '%@' AND type = '%@'", dateStr, @"前端"];
        self.resources = [HSYCommonModel findWithFormat:@" WHERE dateStr = '%@' AND type = '%@'", dateStr, @"拓展资源"];
        self.introduces = [HSYCommonModel findWithFormat:@" WHERE dateStr = '%@' AND type = '%@'", dateStr, @"瞎推荐"];
        self.fulis = [HSYCommonModel findWithFormat:@" WHERE dateStr = '%@' AND type = '%@'", dateStr, @"福利"];
        self.vedios = [HSYCommonModel findWithFormat:@" WHERE dateStr = '%@' AND type = '%@'", dateStr, @"休息视频"];
    }
    return self;
}

#pragma mark - 获取headerTitle
- (NSString*)formatWithDateStr:(NSString*)dateStr {
    NSArray *arr = [dateStr componentsSeparatedByString:@"-"];
    NSString *year = arr[0];
    NSString *month = arr[1];
    NSString *day = arr[2];
    return [NSString stringWithFormat:@"%@年%@月%@日", year, month, day];
}

@end
