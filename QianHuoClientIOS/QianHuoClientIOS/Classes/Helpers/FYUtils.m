//
//  FyUtils.m
//  fydata_demo
//
//  Created by 曹燃 on 15-1-23.
//  Copyright (c) 2015年 feiyu.com. All rights reserved.
//

#import "CommonCrypto/CommonDigest.h"
#import "FYUtils.h"

@implementation FYUtils

// 获取当前屏幕显示的viewcontroller
+ (UIViewController *)currentViewController {
    
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        result = nextResponder;
    } else {
        result = window.rootViewController;
    }
    
    return result;
}

// 获取最上层
+ (UIView*)topWindow {
    return [[UIApplication sharedApplication] keyWindow];
}

// URL解码
+ (NSString*)URLDecode:(NSString*)string {
    NSString *result = [string stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return result;
}

// URL编码
+ (NSString*)URLEncode:(NSString*)string {
    CFStringRef escaped =
    CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                            (CFStringRef)string,
                                            NULL,
                                            (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                            kCFStringEncodingUTF8);
    return (__bridge_transfer NSString *)(escaped);
}

// URL参数字符串解析成dictionary
+ (NSDictionary*)dictionaryWithURLParameters:(NSString*)str {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:3];
    
    NSArray *urlComps = [str componentsSeparatedByString:@"&"];
    
    if([urlComps count]) {
        NSArray *parameterComps = nil;
        for (NSString *parameterStr in urlComps) {
            parameterComps = [parameterStr componentsSeparatedByString:@"="];
            NSString *key = [FYUtils URLDecode:[parameterComps objectAtIndex:0]];
            NSString *value = [FYUtils URLDecode:[parameterComps objectAtIndex:1]];
            [parameters setObject:value forKey:key];
        }
        return parameters;
    } else {
        return nil;
    }
}

// dictionary转成URL参数字符串
+ (NSString*)URLParametersWithDictionary:(NSDictionary*)dict {
    
    NSMutableString *mtStr = [NSMutableString stringWithCapacity:3];
    NSArray *arr =  [[dict allKeys] sortedArrayUsingSelector:@selector(localizedStandardCompare:)];
    
    for (NSString *key in arr) {
        [mtStr appendString:key];
        [mtStr appendString:@"="];
        [mtStr appendString:dict[key]];
        if ([arr indexOfObject:key] < (arr.count - 1)) {
            [mtStr appendString:@"&"];
        }
    }
    
    return mtStr;
}

// 1.dictionary按key排序 2.组合URL参数字符串 3.URL编码 4.生成签名
+ (NSString*)signWithDictionary:(NSDictionary *)dict secret:(NSString *)secret {
    
    NSMutableString *mtStr = [NSMutableString stringWithCapacity:3];
    NSArray *arr =  [[dict allKeys] sortedArrayUsingSelector:@selector(localizedStandardCompare:)];
    
    for (NSString *key in arr) {
        [mtStr appendString:key];
        [mtStr appendString:@"="];
        [mtStr appendString:dict[key]];
        if ([arr indexOfObject:key] < (arr.count - 1)) {
            [mtStr appendString:@"&"];
        }
    }
    
    NSString *str = [NSString stringWithFormat:@"%@&%@", [FYUtils URLEncode:mtStr], secret];
    return [FYUtils MD5Encrypt:str];
}

// MD5
+ (NSString*)MD5Encrypt:(NSString *)string {
    
    const char *cStr = [string UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
}

//屏幕截图
+ (void)screenShot {
    
    UIViewController *currentVC = [FYUtils currentViewController];
    
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]){
        UIGraphicsBeginImageContextWithOptions(currentVC.view.bounds.size, NO, [UIScreen mainScreen].scale);
    } else {
        UIGraphicsBeginImageContext(currentVC.view.bounds.size);
    }
    
    [currentVC.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
}

// JSON-->NSDictionary
+ (NSDictionary*)dictionaryWithJSONString:(NSString *)string {
    
    NSData *data= [string dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    id JSONObject = [NSJSONSerialization JSONObjectWithData:data
                                                    options:NSJSONReadingAllowFragments error:&error];
    if (error == nil && [JSONObject isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dictionary = (NSDictionary *)JSONObject;
        return dictionary;
    }
    return nil;
}

//Dictionary-->JSON
+ (NSString*)JSONStringWithDictionary:(NSDictionary *)dic {
    
    if (!dic) {
        return @"";
    }
    NSData *JSONData = [NSJSONSerialization dataWithJSONObject:dic
                                                       options:kNilOptions
                                                         error:nil];
    if (JSONData) {
        return [[NSString alloc] initWithData:JSONData encoding:NSUTF8StringEncoding];
    }
    return @"";
}

// Json--> Array
+ (NSArray*)arrayWithJSONString:(NSString*)string {
    
    NSData *data= [string dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data
                                                    options:NSJSONReadingAllowFragments error:&error];
    if (error == nil && [jsonObject isKindOfClass:[NSArray class]]) {
        NSArray *array = (NSArray *)jsonObject;
        return array;
    }
    return nil;
}

// Array解析成JSON
+ (NSString*)JSONStringWithArray:(NSArray*)arr {
    
    if (!arr) {
        return @"";
    }
    NSData *JSONData = [NSJSONSerialization dataWithJSONObject:arr
                                                       options:kNilOptions
                                                         error:nil];
    if (JSONData) {
        return [[NSString alloc] initWithData:JSONData encoding:NSUTF8StringEncoding];
    }
    return @"";
}

//获取时间戳
+ (NSString*)timeStamp {
    
    return [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970] * 1000];
}

//获取系统时间(yyyyMMddHHmmss)
+ (NSString*)systemTime {
    
    NSDate *currentTime = [NSDate date];
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *dateString = [formatter stringFromDate:currentTime];
    return dateString;
}

//获取年月日(xxxx年xx月xx日)
+ (NSString*)stringWithDate:(NSDate*)date {
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    NSInteger day = [components day];
    NSInteger month = [components month];
    NSInteger year = [components year];
    
    return [NSString stringWithFormat:@"%ld年%ld月%ld日", (long)year, (long)month, (long)day];
}

//数组排序
+ (NSArray*)sortArray:(NSArray*)array {
    
    NSComparator cmptr = ^(id obj1, id obj2){
        if ([obj1 longLongValue] < [obj2 longLongValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    };
    return [array sortedArrayUsingComparator:cmptr];
}

//测试注册的邮箱或者电话号码是否符合要求
+ (BOOL)validateEmailAndTel:(NSString*) inputText {
    NSString *patternTel = @"^1[0-9]{10}$";
    NSString *patternEmail = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSError *err = nil;
    NSRegularExpression *telExp = [NSRegularExpression regularExpressionWithPattern:patternTel options:NSRegularExpressionCaseInsensitive error:&err];
    NSRegularExpression *emailExp =[NSRegularExpression regularExpressionWithPattern:patternEmail options:0 error:&err];
    
    NSTextCheckingResult * isMatchTel = [telExp firstMatchInString:inputText options:0 range:NSMakeRange(0, [inputText length])];
    NSTextCheckingResult *isMatchEmail = [emailExp firstMatchInString:inputText options:0 range:NSMakeRange(0, [inputText length])];
    
    if (isMatchEmail||isMatchTel) {
        return YES;
    }
    return NO;
}

// 获取IDFA
+ (NSString*) deviceIDFA {
#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
    if (NSClassFromString(@"ASIdentifierManager")) {
        if(ASIdentifierManager.sharedManager.isAdvertisingTrackingEnabled) {
            NSString *idfa = ASIdentifierManager.sharedManager.advertisingIdentifier.UUIDString;
            return idfa == nil? @"": idfa;
        }
    }
#endif
    return @"";
}

// 获取IDFV
+ (NSString*) deviceIDFV {
#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
    if([[UIDevice currentDevice] respondsToSelector:@selector(identifierForVendor)]) {
        NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        return idfv == nil? @"": idfv;
    }
#endif
    return @"";
}

// 生成设备ID
+ (NSString*) deviceID {
    
    NSString *deviceId = [FYUtils deviceIDFA];
    
    if (deviceId != nil && deviceId.length > 0) {
        return deviceId;
    }
    
    deviceId = [FYUtils deviceIDFA];
    
    if (deviceId != nil && deviceId.length > 0) {
        return deviceId;
    }
    
    deviceId = (NSString*)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, CFUUIDCreate(kCFAllocatorDefault)));
    
    return deviceId;
}

@end


