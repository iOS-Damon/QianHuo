//
//  HSYBaseViewmodel.h
//  QianHuoClientIOS
//
//  Created by Sean on 16/3/28.
//  Copyright © 2016年 deeepthinking. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSYLoadValueProtocol.h"
#import "HSYBindingParamProtocol.h"
#import "FBKVOController.h"

@interface HSYBaseViewmodel : NSObject <HSYBindingParamProtocol, HSYLoadValueProtocol>

//页数
@property (nonatomic, assign) NSNumber *page;
//请求错误
@property (nonatomic, strong) NSError *requestError;
//记录是否第一次加载
@property (nonatomic, assign) BOOL isFirstLoad;
//KVO
@property (nonatomic, strong) FBKVOController *KVOController;
//数据清单
@property (nonatomic, strong) NSArray *historys;
//记录当前请求数
@property (nonatomic, assign) NSNumber *requestCount;
//提示没有更多
@property (nonatomic, assign) BOOL noMore;

- (void)savePage:(NSInteger)section;
- (NSInteger)loadPage;

- (void)saveOffsetY:(CGFloat)offsetY;
- (CGFloat)loadOffsetY;

- (NSString*)formatWithYear:(NSString*)year month:(NSString*)month day:(NSString*)day;

- (void)addRequestCount;
- (void)decRequestCount;

@end
