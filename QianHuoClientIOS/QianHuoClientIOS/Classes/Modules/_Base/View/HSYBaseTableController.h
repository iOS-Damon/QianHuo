//
//  HSYBaseTableController.h
//  QianHuoClientIOS
//
//  Created by Sean on 16/3/28.
//  Copyright © 2016年 deeepthinking. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSYBaseTableController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

- (void)pullRefreshAction:(id)sender;

@end
