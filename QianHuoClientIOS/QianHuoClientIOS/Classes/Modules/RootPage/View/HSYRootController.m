//
//  RootViewController.m
//  QianHuoClientIOS
//
//  Created by Sean on 16/3/28.
//  Copyright © 2016年 deeepthinking. All rights reserved.
//

#import "HSYRootController.h"
#import "HSYNavigationController.h"
#import "HSYLearningTimeController.h"
#import "HSYRestTimeController.h"

@interface HSYRootController ()

@end

@implementation HSYRootController

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupVC];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 布局

- (void)setupVC {
    HSYLearningTimeController *learningTimeVC = [[HSYLearningTimeController alloc] init];
    HSYNavigationController *learningTimeNav = [[HSYNavigationController alloc] initWithRootViewController:learningTimeVC];
    [self addChildViewController:learningTimeNav];
    
    HSYRestTimeController *restTimeVC = [[HSYRestTimeController alloc] init];
    HSYNavigationController *restTimeNav = [[HSYNavigationController alloc] initWithRootViewController:restTimeVC];
    [self addChildViewController:restTimeNav];
}

- (void)setupUI {
    UITabBar *tabBar = self.tabBar;
    tabBar.tintColor = [UIColor redColor];
    NSArray *items = [tabBar items];
    
    UITabBarItem *item1 = items[0];
    item1.title = @"学习时间";
    item1.image = [UIImage imageNamed:@"TabbarLearnTime.png"];
    
    UITabBarItem *item2 = items[1];
    item2.title = @"休息时间";
    item2.image = [UIImage imageNamed:@"TabbarRestTime.png"];
}

@end
