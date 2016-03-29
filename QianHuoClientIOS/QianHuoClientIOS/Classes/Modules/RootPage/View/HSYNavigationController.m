//
//  HSYNavigationController.m
//  QianHuoClientIOS
//
//  Created by Sean on 16/3/28.
//  Copyright © 2016年 deeepthinking. All rights reserved.
//

#import "HSYNavigationController.h"

@interface HSYNavigationController ()

@end

@implementation HSYNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: FYColorSub};
    self.navigationBar.tintColor = FYColorSub;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
