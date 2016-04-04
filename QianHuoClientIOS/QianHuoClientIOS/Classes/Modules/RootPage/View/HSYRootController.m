//
//  RootViewController.m
//  QianHuoClientIOS
//
//  Created by Sean on 16/3/28.
//  Copyright © 2016年 deeepthinking. All rights reserved.
//

#import "HSYRootController.h"
#import "HSYNavigationController.h"
#import "HSYLearningController.h"
#import "HSYRestController.h"

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
    HSYLearningController *learningVC = [[HSYLearningController alloc] initWithStyle:UITableViewStylePlain];
    HSYNavigationController *learningNav = [[HSYNavigationController alloc] initWithRootViewController:learningVC];
    [self addChildViewController:learningNav];
    
    HSYRestController *restVC = [[HSYRestController alloc] initWithStyle:UITableViewStylePlain];
    HSYNavigationController *restNav = [[HSYNavigationController alloc] initWithRootViewController:restVC];
    [self addChildViewController:restNav];
}

- (void)setupUI {
    UITabBar *tabBar = self.tabBar;
    tabBar.tintColor = FYColorSub;
    NSArray *items = [tabBar items];
    
    UITabBarItem *item0 = items[0];
    item0.title = @"学习时间";
    item0.image = [UIImage imageNamed:@"TabbarLearn.png"];

    UITabBarItem *item1 = items[1];
    item1.title = @"休息时间";
    item1.image = [UIImage imageNamed:@"TabbarRest.png"];
}

@end
