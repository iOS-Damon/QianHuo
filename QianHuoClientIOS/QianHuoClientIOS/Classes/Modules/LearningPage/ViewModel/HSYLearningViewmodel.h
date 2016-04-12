//
//  HSYLearningTimeViewmodel.h
//  QianHuoClientIOS
//
//  Created by Sean on 16/3/28.
//  Copyright © 2016年 deeepthinking. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSYBaseViewmodel.h"
#import "HSYLoadValueProtocol.h"

@interface HSYLearningViewmodel : HSYBaseViewmodel <HSYLoadValueProtocol>

@property (nonatomic, strong) NSArray *dateModels;

- (NSInteger)sectionsCount;
- (NSString*)headerTitleInSection:(NSInteger)section;
- (NSInteger)rowsCountInSection:(NSInteger)section;
- (UIImage*)rowAvatarAtIndexPath:(NSIndexPath *)indexPath;
- (NSString*)rowDescAtIndexPath:(NSIndexPath *)indexPath;
- (NSString*)rowUrlAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)rowHasRead:(NSIndexPath *)indexPath;
- (void)saveRowHasRead:(NSIndexPath *)indexPath;

@end
