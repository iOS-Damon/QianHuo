//
//  HSYContentController.h
//  QianHuoClientIOS
//
//  Created by Sean on 16/3/31.
//  Copyright © 2016年 deeepthinking. All rights reserved.
//

#import "HSYBaseController.h"
#import "HSYLikeButtonDelegate.h"

@interface HSYContentController : HSYBaseController

@property (nonatomic, copy) NSString *urlStr;
@property (nonatomic, assign) BOOL isLike;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, weak) id<HSYLikeButtonDelegate> delegate;

- (instancetype)initWithUrl:(NSString*)url;

@end
