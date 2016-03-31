//
//  HSYUserDefaults.h
//  QianHuoClientIOS
//
//  Created by Sean on 16/3/30.
//  Copyright © 2016年 deeepthinking. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSYUserDefaults : NSObject

+ (void)setObject:(id)object forKey:(NSString*)key;
+ (id)objectForKey:(NSString*)key;

@end
