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

@end
