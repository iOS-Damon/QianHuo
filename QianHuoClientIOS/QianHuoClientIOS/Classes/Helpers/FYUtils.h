//
//  NBUtils.h
//
//  Created by 曹燃 on 15-1-23.
//  Copyright (c) 2015年 feiyu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AdSupport/ASIdentifierManager.h>
#import <UIKit/UIKit.h>

@interface FYUtils : NSObject

// 获取当前屏幕显示的viewcontroller
+ (UIViewController *)currentViewController;

// 获取最上层
+ (UIView*)topWindow;

// URL解码
+ (NSString*)URLDecode:(NSString*)string;

// URL编码
+ (NSString*)URLEncode:(NSString*)string;

// URL参数字符串解析成dictionary
+ (NSDictionary*)dictionaryWithURLParameters:(NSString*)string;

//dictionary转成URL参数字符串
+ (NSString*)URLParametersWithDictionary:(NSDictionary*)dict;

// 1.dictionary按key排序 2.组合URL参数字符串 3.URL编码 4.生成签名
+ (NSString*)signWithDictionary:(NSDictionary*)dict secret:(NSString *)secret;

// MD5
+ (NSString*)MD5Encrypt:(NSString*)string;

// 屏幕截图
+ (void)screenShot;

// JSON解析成NSDictionary
+ (NSDictionary*)dictionaryWithJSONString:(NSString*)string;

// Dictionary解析成JSON
+ (NSString*)JSONStringWithDictionary:(NSDictionary*)dic;

// JSON解析成Array
+ (NSArray*)arrayWithJSONString:(NSString*)string;

// Array解析成JSON
+ (NSString*)JSONStringWithArray:(NSArray*)arr;

//获取时间戳
+ (NSString*)timeStamp;

//获取系统时间(yyyyMMddHHmmss)
+ (NSString*)systemTime;

//获取年月日(xxxx年xx月xx日)
+ (NSString*)stringWithDate:(NSDate*)date;

//获取当前 年
+ (NSInteger)year;

//获取当前 月
+ (NSInteger)month;

//获取当前 日
+ (NSInteger)day;

//数组排序
+ (NSArray*)sortArray:(NSArray*)array;

//测试注册的邮箱或者电话号码是否符合要求
+ (BOOL)validateEmailAndTel:(NSString*)string;

// 获取IDFA
+ (NSString*)deviceIDFA;

// 获取IDFV
+ (NSString*)deviceIDFV;

// 生成设备ID
+ (NSString*)deviceID;

@end
