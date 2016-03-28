//
//  HSYLearningTimeViewmodel.h
//  QianHuoClientIOS
//
//  Created by Sean on 16/3/28.
//  Copyright © 2016年 deeepthinking. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSYBaseViewmodel.h"

@interface HSYLearningTimeViewmodel : HSYBaseViewmodel

- (NSInteger)numberOfSectionsInTableView;
- (NSString*)titleForHeaderInSection:(NSInteger)section;
- (NSInteger)numberOfRowsInSection:(NSInteger)section;
- (UIImage*)cellAvatarForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSString*)cellTitleForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
