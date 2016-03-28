//
//  NBPlatformConfig.h
//  NBPlatformExample
//
//  Created by Sean on 15/6/13.
//  Copyright (c) 2015年 FeiYu. All rights reserved.
//

#define FYIsPad ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)

#define FYIsLessIos9 ([[[UIDevice currentDevice] systemVersion] floatValue] < 9.0)

#define FYIsLessIos8 ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0)

#define FYIsLessIos7 ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0)

#define FYIsLandscape ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight)

#define FYIsPortrait ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)

#define FYBundle(bundleName, fileName) [NSString stringWithFormat:@"%@.bundle/%@", bundleName, fileName]

#import "UIColor+FY.h"
#define FYColorGary [UIColor colorWithHexString:@"424242" alpha:1.0]
#define FYColorLightGary [UIColor colorWithHexString:@"DCDCDC" alpha:1.0]
#define FYColorMain [UIColor colorWithHexString:@"03A9F4" alpha:1.0]

#define FYLabSize1 (FYIsPad ? 15 : 10)
#define FYLabSize2 (FYIsPad ? 18 : 13)
#define FYLabSize3 (FYIsPad ? 21 : 16)
#define FYLabSize4 (FYIsPad ? 24 : 19)
#define FYLabSize5 (FYIsPad ? 27 : 22)
