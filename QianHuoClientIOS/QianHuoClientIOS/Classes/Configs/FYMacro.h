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

#define FYClearNil(text) text == nil ? @"" : text 

#define FYNull(a) [a isEqual:[NSNull null]]

#define FYEmpty(a) (a == nil || [a isEqual:[NSNull null]] || a.count == 0)

#import "UIColor+FY.h"
#define FYColorBlack [UIColor colorWithHexString:@"212121" alpha:1.0]
#define FYColorGary [UIColor colorWithHexString:@"BDBDBD" alpha:1.0]
#define FYColorLightGary [UIColor colorWithHexString:@"f5f5f5" alpha:1.0]
#define FYColorLightBlue [UIColor colorWithHexString:@"BBC8E6" alpha:1.0]
#define FYColorSteelBlue [UIColor colorWithHexString:@"4682b4" alpha:1.0]
#define FYColorMain [UIColor colorWithHexString:@"ffffff" alpha:1.0]
#define FYColorSub [UIColor colorWithHexString:@"00afcc" alpha:1.0]
#define FYColorShadow [UIColor colorWithHexString:@"000000" alpha:0.65]
#define FYColorLightShadow [UIColor colorWithHexString:@"CFD8DC" alpha:0.65]

#define FYLabSize1 (FYIsPad ? 15 : 10)
#define FYLabSize2 (FYIsPad ? 18 : 13)
#define FYLabSize3 (FYIsPad ? 21 : 16)
#define FYLabSize4 (FYIsPad ? 24 : 19)
#define FYLabSize5 (FYIsPad ? 27 : 22)

#define FYWeakSelf(weakSelf)  __weak __typeof(&*self)weakSelf = self;
