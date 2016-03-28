//
//  NSString+FY.h
//  ThePainter
//
//  Created by Sean on 15/11/5.
//  Copyright (c) 2015年 FeiYu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (FY)

- (NSString*)clearNil;

//去除string中的空格
- (NSString*)removeWhiteSpace;

//判断有没有空格
- (BOOL)hasWhiteSpace;

//限制字符串长度
- (NSString*)limitStringWithLength:(int)length;

@end
