//
//  HSYBaseTableController.h
//  QianHuoClientIOS
//
//  Created by Sean on 16/3/28.
//  Copyright © 2016年 deeepthinking. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSYBaseTableController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

- (void)pullDownRefresh:(id)sender;
- (void)pullUpRefresh:(id)sender;
- (void)endPullUpRefresh;

@end
