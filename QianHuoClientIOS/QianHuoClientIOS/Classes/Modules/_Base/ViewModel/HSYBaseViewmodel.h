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

//数据清单
@property (nonatomic, strong) NSArray *historys;
//页数
@property (nonatomic, assign) NSInteger page;
//KVO
@property (nonatomic, strong) FBKVOController *KVOController;
//请求错误
@property (nonatomic, strong) NSError *requestError;
//记录是否第一次加载
@property (nonatomic, assign) BOOL isFirstLoad;
//提示没有更多
@property (nonatomic, assign) BOOL noMore;
//是否正在加载新数据
@property (nonatomic, assign) BOOL isLoadingNew;
//是否加载更多数据
@property (nonatomic, assign) BOOL isLoadingMore;

- (void)savePage:(NSInteger)section;
- (NSInteger)loadPage;

- (void)saveOffsetY:(CGFloat)offsetY;
- (CGFloat)loadOffsetY;

- (void)saveCurrentSection:(NSInteger)section;
- (NSInteger)loadCurrentSection;

- (NSString*)formatWithYear:(NSString*)year month:(NSString*)month day:(NSString*)day;

@end
