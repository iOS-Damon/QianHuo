//
//  HSYLikeViewmodel.m
//  QianHuoClientIOS
//
//  Created by Sean on 16/4/19.
//  Copyright © 2016年 deeepthinking. All rights reserved.
//

#import "HSYLikeViewmodel.h"
#import "HSYLikeModel.h"

@interface HSYLikeViewmodel ()

@property (nonatomic, strong) HSYLikeModel *likeModel;

@end

@implementation HSYLikeViewmodel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.likeModel = [[HSYLikeModel alloc] init];
    }
    return self;
}

- (NSInteger)rowsCount {
    return self.likeModel.cellModels.count;
}

- (UIImage*)rowAvatarAtIndexPath:(NSIndexPath *)indexPath {
    HSYCommonModel *cellModel = self.likeModel.cellModels[indexPath.row];
    return [UIImage imageNamed:cellModel.avatarName];
}

- (NSString*)rowTitleAtIndexPath:(NSIndexPath *)indexPath {
    HSYCommonModel *cellModel = self.likeModel.cellModels[indexPath.row];
    return cellModel.type;
}

- (NSString*)rowDescAtIndexPath:(NSIndexPath *)indexPath {
    HSYCommonModel *cellModel = self.likeModel.cellModels[indexPath.row];
    return cellModel.desc;
}

- (NSString*)rowUrlAtIndexPath:(NSIndexPath *)indexPath {
    HSYCommonModel *cellModel = self.likeModel.cellModels[indexPath.row];
    return cellModel.url;
}

- (BOOL)rowHasRead:(NSIndexPath *)indexPath {
    HSYCommonModel *cellModel = self.likeModel.cellModels[indexPath.row];
    return cellModel.hasRead;
}

- (void)saveRowHasRead:(NSIndexPath *)indexPath {
    HSYCommonModel *cellModel = self.likeModel.cellModels[indexPath.row];
    cellModel.hasRead = YES;
    [cellModel update];
}

- (BOOL)rowIsLike:(NSIndexPath *)indexPath {
    HSYCommonModel *cellModel = self.likeModel.cellModels[indexPath.row];
    return cellModel.isLike;
}

- (void)saveRowIsLike:(BOOL)isLike indexPath:(NSIndexPath *)indexPath {
    HSYCommonModel *cellModel = self.likeModel.cellModels[indexPath.row];
    cellModel.isLike = isLike;
    [cellModel update];
}

- (void)refreshData {
    self.likeModel = [[HSYLikeModel alloc] init];
}

@end
