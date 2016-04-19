//
//  HSYRestDateModel.m
//  QianHuoClientIOS
//
//  Created by Sean on 16/4/1.
//  Copyright © 2016年 deeepthinking. All rights reserved.
//

#import "HSYRestDateModel.h"

@implementation HSYRestDateModel

//- (instancetype)initWithParam:(NSDictionary*)param {
//    self = [super init];
//    if (self) {
//        self.dateStr = @"";
//        self.headerTitle = @"";
//        
//        NSMutableArray *fuliTemp = [[NSMutableArray alloc] initWithCapacity:3];
//        NSArray *fuli = param[@"福利"];
//        if (!FYEmpty(fuli)) {
//            for (NSDictionary *dict in fuli) {
//                HSYRestFuliModel *fuliModel = [[HSYRestFuliModel alloc] initWithParam:dict];
//                [fuliTemp addObject:fuliModel];
//            }
//        }
//        self.fuliModels = fuliTemp;
//        
//        NSMutableArray *vedioTemp = [[NSMutableArray alloc] initWithCapacity:3];
//        NSArray *vedio = param[@"休息视频"];
//        if (!FYEmpty(vedio)) {
//            for (NSDictionary *dict in vedio) {
//                HSYRestVedioModel *vedioModel = [[HSYRestVedioModel alloc] initWithParam:dict];
//                [vedioTemp addObject:vedioModel];
//            }
//        }
//        self.vedioModels = vedioTemp;
//    }
//    return self;
//}

- (instancetype)initWithDateStr:(NSString *)dateStr {
    self = [super initWithDateStr:dateStr];
    if (self) {
        self.cellModels = [[NSArray alloc] init];
        self.cellModels = [self.cellModels arrayByAddingObjectsFromArray:self.fulis];
        self.cellModels = [self.cellModels arrayByAddingObjectsFromArray:self.vedios];
    }
    return self;
}

@end
