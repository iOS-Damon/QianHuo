//
//  HSYRestViewmodel.h
//  QianHuoClientIOS
//
//  Created by Sean on 16/4/1.
//  Copyright © 2016年 deeepthinking. All rights reserved.
//

#import "HSYBaseViewmodel.h"

@interface HSYRestViewmodel : HSYBaseViewmodel 

@property (nonatomic, strong) NSArray *dateModels;

- (NSInteger)sectionsCount;
- (NSString*)headerTitleInSection:(NSInteger)section;
- (NSInteger)rowsCountInSection:(NSInteger)section;
- (NSInteger)rowsFuliCountInSection:(NSInteger)section;
- (NSInteger)rowsVedioCountInSection:(NSInteger)section;

- (UIImage*)rowAvatarAtIndexPath:(NSIndexPath *)indexPath;
- (NSString*)rowTitleAtIndexPath:(NSIndexPath *)indexPath;
- (NSString*)rowDescAtIndexPath:(NSIndexPath *)indexPath;
- (NSString*)rowUrlAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)rowHasRead:(NSIndexPath *)indexPath;
- (void)saveRowHasRead:(NSIndexPath *)indexPath;
- (BOOL)rowIsLike:(NSIndexPath *)indexPath;
- (void)saveRowIsLike:(BOOL)isLike indexPath:(NSIndexPath *)indexPath;

@end
