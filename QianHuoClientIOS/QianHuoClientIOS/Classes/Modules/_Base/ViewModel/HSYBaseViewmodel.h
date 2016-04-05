//
//  HSYBaseViewmodel.h
//  QianHuoClientIOS
//
//  Created by Sean on 16/3/28.
//  Copyright © 2016年 deeepthinking. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSYBaseViewmodel : NSObject

//记录是否第一次加载
@property (nonatomic, assign) BOOL isFirstLoad;

- (void)saveSection:(NSInteger)section;
- (void)saveOffsetY:(CGFloat)offsetY;
- (CGFloat)loadOffsetY;

@end
