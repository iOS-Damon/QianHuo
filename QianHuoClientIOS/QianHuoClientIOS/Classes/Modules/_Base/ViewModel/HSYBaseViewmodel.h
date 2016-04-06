//
//  HSYBaseViewmodel.h
//  QianHuoClientIOS
//
//  Created by Sean on 16/3/28.
//  Copyright © 2016年 deeepthinking. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSYBaseViewmodel : NSObject

//请求错误
@property (nonatomic, strong) NSError *requestError;
//记录是否第一次加载
@property (nonatomic, assign) BOOL isFirstLoad;
//是否所有数据已经加载完毕，不能再下拉
@property (nonatomic, assign) BOOL noMore;

- (void)saveSection:(NSInteger)section;
- (void)saveOffsetY:(CGFloat)offsetY;
- (CGFloat)loadOffsetY;
- (void)saveHasReadIndexPath:(NSIndexPath*)path;
- (BOOL)indexPathHasRead:(NSIndexPath*)path;

@end
