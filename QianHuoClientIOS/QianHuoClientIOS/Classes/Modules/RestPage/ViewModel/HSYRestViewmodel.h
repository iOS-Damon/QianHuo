//
//  HSYRestViewmodel.h
//  QianHuoClientIOS
//
//  Created by Sean on 16/4/1.
//  Copyright © 2016年 deeepthinking. All rights reserved.
//

#import "HSYBaseViewmodel.h"
#import "HSYLoadValueProtocol.h"

@interface HSYRestViewmodel : HSYBaseViewmodel <HSYLoadValueProtocol>

@property (nonatomic, strong) NSArray *dateModels;

- (NSInteger)sectionsCount;
- (NSString*)headerTitleInSection:(NSInteger)section;
- (NSInteger)rowsCountInSection:(NSInteger)section;
- (NSInteger)rowsFuliCountInSection:(NSInteger)section;
- (NSInteger)rowsVedioCountInSection:(NSInteger)section;

- (UIImage*)rowAvatarAtIndexPath:(NSIndexPath *)indexPath;
- (NSString*)rowDescAtIndexPath:(NSIndexPath *)indexPath;
- (NSString*)rowUrlAtIndexPath:(NSIndexPath *)indexPath;
- (UIImage*)rowImageAtIndexPath:(NSIndexPath*)indexPath;

- (NSIndexSet*)sectionShouldRefresh;

@end
