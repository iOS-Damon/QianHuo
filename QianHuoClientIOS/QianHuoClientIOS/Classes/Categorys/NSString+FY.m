//
//  NSString+FY.m
//  ThePainter
//
//  Created by Sean on 15/11/5.
//  Copyright (c) 2015年 FeiYu. All rights reserved.
//

#import "NSString+FY.h"

@implementation NSString (FY)

- (NSString*)clearNil {
    return self == nil ? @"" : self;
}

//去除string中的空格
- (NSString*)removeWhiteSpace {
    return [self stringByReplacingOccurrencesOfString:@"\\s" withString:@""
                                              options:NSRegularExpressionSearch
                                                range:NSMakeRange(0, [self length])];
}

//判断有没有空格
- (BOOL)hasWhiteSpace {
    NSRange range = [self rangeOfString:@" "];
    if (range.location != NSNotFound) {
        return YES;
    }else {
        return NO;
    }
}

//限制字符串长度
- (NSString*)limitStringWithLength:(int)length {
    
    if (self.length > length) {
        NSString *temp = [self substringWithRange:NSMakeRange(0, length)];
        return [NSString stringWithFormat:@"%@...", temp];
    } else {
        return self;
    }
}

@end
