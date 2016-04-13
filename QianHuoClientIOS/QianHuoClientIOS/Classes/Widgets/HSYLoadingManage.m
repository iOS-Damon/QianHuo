//
//  HSYLoadingManage.m
//  TestHSYLoading
//
//  Created by Sean on 15/12/4.
//  Copyright (c) 2015年 seanhuang1661. All rights reserved.
//

#import "HSYLoadingManage.h"
#import "HSYLoading.h"
#import "UIView+FY.h"
#import "FYUtils.h"

static NSString *const kHSYTopWindowLoading = @"kHSYTopWindowLoading";

@interface HSYLoadingManage ()

@property (nonatomic, strong) NSMutableDictionary *loadings;

@end

@implementation HSYLoadingManage

+ (instancetype)sharedInstance {
    static HSYLoadingManage* instance = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        instance = [[HSYLoadingManage alloc] init];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        self.loadings = [[NSMutableDictionary alloc] initWithCapacity:3];
    }
    return self;
}

- (void)showLoadingForWindow {
    [self showLoadingForParentView:[FYUtils topWindow] withKey:kHSYTopWindowLoading];
}

- (void)hideLoadingForWindow {
    [self hideLoadingWithKey:kHSYTopWindowLoading];
}

- (void)showLoadingForParentView:(UIView *)parentView withKey:(NSString*)key {
    for (UIView *subview in parentView.subviews) {
        if ([subview isKindOfClass:[HSYLoading class]]) {
            NSLog(@"---This view has already contain loading view!---");
            return;
        }
    }
    if (!key) {
        NSLog(@"---The key for loading not be nil!---");
        return;
    }
    HSYLoading *loading = [[HSYLoading alloc] initWithFrame:CGRectMake(0, 0, parentView.frameWidth, parentView.frameHeight)];
    [parentView addSubview:loading];
    [self.loadings setObject:loading forKey:key];
}

- (void)showLoadingForParentView:(UIView *)parentView withKey:(NSString*)key backgroundColor:(UIColor*)color {
    [self showLoadingForParentView:parentView withKey:key];
    HSYLoading *loading = [self.loadings objectForKey:key];
    loading.backgroundColor = color;
}

- (void)hideLoadingWithKey:(NSString*)key {
    HSYLoading *loading = [self.loadings objectForKey:key];
    if (!loading) {
        NSLog(@"---This loading does not exist!---");
        return;
    }
    [loading removeFromSuperview];
    [self.loadings removeObjectForKey:key];
}

@end
