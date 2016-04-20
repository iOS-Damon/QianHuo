//
//  HSYLikeViewmodel.h
//  QianHuoClientIOS
//
//  Created by Sean on 16/4/19.
//  Copyright © 2016年 deeepthinking. All rights reserved.
//

#import "HSYBaseViewmodel.h"

@interface HSYLikeViewmodel : HSYBaseViewmodel

- (NSInteger)rowsCount;
- (UIImage*)rowAvatarAtIndexPath:(NSIndexPath *)indexPath;
- (NSString*)rowTitleAtIndexPath:(NSIndexPath *)indexPath;
- (NSString*)rowDescAtIndexPath:(NSIndexPath *)indexPath;
- (NSString*)rowUrlAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)rowHasRead:(NSIndexPath *)indexPath;
- (void)saveRowHasRead:(NSIndexPath *)indexPath;
- (BOOL)rowIsLike:(NSIndexPath *)indexPath;
- (void)saveRowIsLike:(BOOL)isLike indexPath:(NSIndexPath *)indexPath;
- (void)refreshData;


@end
