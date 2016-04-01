//
//  WFLaunchController.m
//  WFZhihuDaily
//
//  Created by wfh on 16/1/29.
//  Copyright © 2016年 xiupintech. All rights reserved.
//

#import "WFLaunchController.h"

@interface WFLaunchController ()
{
    UIImageView *_firstLaunchView;
    UIImageView *_secondLaunchView;
}
@end

@implementation WFLaunchController

#pragma mark - View Load
- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self configUI];
    [self showLaunchAnimation];
  
}

#pragma mark - View
#pragma mark - View factory
- (void)configUI{
    
    _secondLaunchView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _secondLaunchView.contentMode = UIViewContentModeScaleAspectFill;
    _secondLaunchView.image = [UIImage imageNamed:@"LaunchSecond.png"];
    [self.view addSubview:_secondLaunchView];
    
    _firstLaunchView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _firstLaunchView.contentMode = UIViewContentModeScaleAspectFill;
    _firstLaunchView.image = [UIImage imageNamed:@"LaunchFirst.png"];
    [self.view addSubview:_firstLaunchView];

}

- (void)showLaunchAnimation{

    [UIView animateWithDuration:2.f animations:^{
        
        _firstLaunchView.alpha = 0.f;
        _secondLaunchView.transform = CGAffineTransformMakeScale(1.1f, 1.1f);
        
    } completion:^(BOOL finished) {
        
        [_firstLaunchView removeFromSuperview];
        
        [UIView animateWithDuration:0.4 animations:^{
            _secondLaunchView.alpha = 0.f;
        } completion:^(BOOL finished) {
            [_secondLaunchView removeFromSuperview];
            [self.view removeFromSuperview];
        }];
        
    }];
}


@end
