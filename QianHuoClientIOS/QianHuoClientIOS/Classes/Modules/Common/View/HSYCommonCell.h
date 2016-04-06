//
//  HSYLearningTimeCell.h
//  QianHuoClientIOS
//
//  Created by Sean on 16/3/28.
//  Copyright © 2016年 deeepthinking. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSYBaseTableCell.h"

@interface HSYCommonCell : HSYBaseTableCell

@property (nonatomic, strong) UIImage *avatarImage;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) BOOL hasRead;

@end
