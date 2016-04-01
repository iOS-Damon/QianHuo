//
//  HSYConstant.h
//  QianHuoClientIOS
//
//  Created by Sean on 16/3/28.
//  Copyright © 2016年 deeepthinking. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSYConstant : NSObject

//主标题
extern NSString * const HSYRootTitle;

//数据api接口
extern NSString * const HSYBaseUrl;

//数据清单api接口
extern NSString * const HSYHistoryUrl;

//数据清单的UserDefult标识
extern NSString * const HSYHistoryID;

//网络有问题的提示语
extern NSString * const HSYNetworkErrorHint;

//提示语显示的时间
extern int const HSYHintDuration;

//通用列表的高度比例（与屏幕长边相乘）
extern CGFloat const HSYCommonCellHeightScale;

//通用表头的高度比例（与屏幕长边相乘）
extern CGFloat const HSYCommonHeaderHeightScale;

@end
