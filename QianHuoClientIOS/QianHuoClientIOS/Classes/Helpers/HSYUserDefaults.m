//
//  HSYUserDefaults.m
//  QianHuoClientIOS
//
//  Created by Sean on 16/3/30.
//  Copyright © 2016年 deeepthinking. All rights reserved.
//

#import "HSYUserDefaults.h"

@implementation HSYUserDefaults

+ (void)setObject:(id)object forKey:(NSString*)key {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:object forKey:key];
    [ud synchronize];
}

+ (id)objectForKey:(NSString*)key {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    return [ud objectForKey:key];
}

+ (void)setInteger:(NSInteger)integer forKey:(NSString*)key {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setInteger:integer forKey:key];
    [ud synchronize];
}

+ (NSInteger)integerForKey:(NSString*)key {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    return [ud integerForKey:key];
}

+ (void)setFloat:(CGFloat)sFloat forKey:(NSString*)key {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setFloat:sFloat forKey:key];
    [ud synchronize];
}

+ (CGFloat)floatForKey:(NSString*)key {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    return [ud floatForKey:key];
}

+ (void)setBool:(BOOL)b forKey:(NSString*)key {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setBool:b forKey:key];
    [ud synchronize];
}

+ (BOOL)BoolForKey:(NSString*)key {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    return [ud boolForKey:key];
}

@end
