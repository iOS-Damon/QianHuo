//
//  HSYLearningTimeCell.h
//  QianHuoClientIOS
//
//  Created by Sean on 16/3/28.
//  Copyright © 2016年 deeepthinking. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSYBaseTableCell.h"
#import "HSYLikeButtonDelegate.h"

@interface HSYCommonCell : HSYBaseTableCell

@property (nonatomic, strong) UIImage *avatarImage;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, assign) BOOL hasRead;
@property (nonatomic, assign) BOOL isLike;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, weak) id<HSYLikeButtonDelegate> delegate;

@end
