//
//  FYLog.h
//  TestFYLog
//
//  Created by Sean on 15/9/22.
//  Copyright (c) 2015年 FeiYu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define FYLogSwitch 1

#define FYLog(format, ...) do {\
                                if (FYLogSwitch) {\
                                        fprintf(stderr, "========================FYLog======================\n");\
                                        fprintf(stderr, "<%s : %d> %s\n",\
                                        [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],\
                                        __LINE__, __func__);\
                                        (NSLog)((format), ##__VA_ARGS__);\
                                        fprintf(stderr, "===================================================\n");\
                                }\
                            } while (0)


@interface FYLog : NSObject

@end
