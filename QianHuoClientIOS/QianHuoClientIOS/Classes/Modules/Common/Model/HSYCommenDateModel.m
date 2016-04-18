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

- (void)saveWithParams:(NSDictionary*)params dateStr:(NSString*)dateStr {
    NSArray *android = params[@"Android"];
    if(!FYEmpty(android)) {
        for (NSDictionary *dict in android) {
            HSYCommonModel *model = [[HSYCommonModel alloc] init];
            [model saveWithParams:dict dateStr:dateStr];
        }
    }
    
    NSArray *ios = params[@"iOS"];
    if(!FYEmpty(android)) {
        for (NSDictionary *dict in ios) {
            HSYCommonModel *model = [[HSYCommonModel alloc] init];
            [model saveWithParams:dict dateStr:dateStr];
        }
    }
    
    NSArray *app = params[@"App"];
    if(!FYEmpty(android)) {
        for (NSDictionary *dict in app) {
            HSYCommonModel *model = [[HSYCommonModel alloc] init];
            [model saveWithParams:dict dateStr:dateStr];
        }
    }
    
    NSArray *html = params[@"前端"];
    if(!FYEmpty(android)) {
        for (NSDictionary *dict in html) {
            HSYCommonModel *model = [[HSYCommonModel alloc] init];
            [model saveWithParams:dict dateStr:dateStr];
        }
    }
    
    NSArray *resource = params[@"拓展资源"];
    if(!FYEmpty(android)) {
        for (NSDictionary *dict in resource) {
            HSYCommonModel *model = [[HSYCommonModel alloc] init];
            [model saveWithParams:dict dateStr:dateStr];
        }
    }
    
    NSArray *introduce = params[@"瞎推荐"];
    if(!FYEmpty(android)) {
        for (NSDictionary *dict in introduce) {
            HSYCommonModel *model = [[HSYCommonModel alloc] init];
            [model saveWithParams:dict dateStr:dateStr];
        }
    }
    
    NSArray *fuli = params[@"福利"];
    if (!FYEmpty(fuli)) {
        for (NSDictionary *dict in fuli) {
            HSYCommonModel *model = [[HSYCommonModel alloc] init];
            [model saveWithParams:dict dateStr:dateStr];
        }
    }
    
    NSArray *vedio = params[@"休息视频"];
    if (!FYEmpty(vedio)) {
        for (NSDictionary *dict in vedio) {
            HSYCommonModel *model = [[HSYCommonModel alloc] init];
            [model saveWithParams:dict dateStr:dateStr];
        }
    }
}

- (void)loadWithDateStr:(NSString*)dateStr {
    self.androids = [HSYCommonModel findWithFormat:@" WHRER dateStr = '%@' AND type = '%@'", dateStr, @"Android"];
    self.ioses = [HSYCommonModel findWithFormat:@" WHRER dateStr = '%@' AND type = '%@'", dateStr, @"iOS"];
    self.appes = [HSYCommonModel findWithFormat:@" WHRER dateStr = '%@' AND type = '%@'", dateStr, @"App"];
    self.htmls = [HSYCommonModel findWithFormat:@" WHRER dateStr = '%@' AND type = '%@'", dateStr, @"前端"];
    self.resources = [HSYCommonModel findWithFormat:@" WHRER dateStr = '%@' AND type = '%@'", dateStr, @"拓展资源"];
    self.introduces = [HSYCommonModel findWithFormat:@" WHRER dateStr = '%@' AND type = '%@'", dateStr, @"瞎推荐"];
    self.vedios = [HSYCommonModel findWithFormat:@" WHRER dateStr = '%@' AND type = '%@'", dateStr, @"福利"];
    self.fulis = [HSYCommonModel findWithFormat:@" WHRER dateStr = '%@' AND type = '%@'", dateStr, @"休息视频"];
}

@end
