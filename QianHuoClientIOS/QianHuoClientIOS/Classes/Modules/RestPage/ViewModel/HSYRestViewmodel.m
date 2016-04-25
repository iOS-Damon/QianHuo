//
//  HSYRestViewmodel.m
//  QianHuoClientIOS
//
//  Created by Sean on 16/4/1.
//  Copyright © 2016年 deeepthinking. All rights reserved.
//

#import "HSYRestViewmodel.h"
#import "FYUtils.h"
#import "HSYRestDateModel.h"
#import "AFNetworking.h"
#import "HSYUserDefaults.h"
#import <SDWebImage/UIImageView+WebCache.h>


static NSString * const HSYRestViewmodelOffsetY = @"HSYRestViewmodelOffsetY";
static NSString * const HSYRestViewmodelCurrentSectionID = @"HSYRestViewmodelCurrentSectionID";
static NSString * const HSYRestViewmodelPageID = @"HSYRestViewmodelPageID";
static int const HSYRestViewmodelPageStep = 10;

@interface HSYRestViewmodel ()

@property (atomic, strong) NSArray *tempModels;
@property (nonatomic, assign) NSInteger tempCount;

@end

@implementation HSYRestViewmodel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.dateModels = [[NSArray alloc] init];
        self.tempModels = [[NSArray alloc] init];
        self.tempCount = 0;
    }
    return self;
}


- (NSInteger)sectionsCount {
    return self.dateModels.count;
}

- (NSString*)headerTitleInSection:(NSInteger)section {
    HSYRestDateModel *dateModel = self.dateModels[section];
    return dateModel.headerTitle;
}

- (NSInteger)rowsCountInSection:(NSInteger)section {
    HSYRestDateModel *dateModel = self.dateModels[section];
    return dateModel.cellModels.count;
}

- (NSInteger)rowsFuliCountInSection:(NSInteger)section {
    HSYRestDateModel *dateModel = self.dateModels[section];
    return dateModel.fulis.count;
}

- (NSInteger)rowsVedioCountInSection:(NSInteger)section {
    HSYRestDateModel *dateModel = self.dateModels[section];
    return dateModel.vedios.count;
}

- (UIImage*)rowAvatarAtIndexPath:(NSIndexPath *)indexPath {
    HSYRestDateModel *dateModel = self.dateModels[indexPath.section];
    HSYCommonModel *cellModel = dateModel.cellModels[indexPath.row];
    return [UIImage imageNamed:cellModel.avatarName];
}

- (NSString*)rowTitleAtIndexPath:(NSIndexPath *)indexPath {
    HSYRestDateModel *dateModel = self.dateModels[indexPath.section];
    HSYCommonModel *cellModel = dateModel.cellModels[indexPath.row];
    return cellModel.type;
}

- (NSString*)rowDescAtIndexPath:(NSIndexPath *)indexPath {
    HSYRestDateModel *dateModel = self.dateModels[indexPath.section];
    HSYCommonModel *cellModel = dateModel.cellModels[indexPath.row];
    return cellModel.desc;
}

- (NSString*)rowUrlAtIndexPath:(NSIndexPath *)indexPath {
    HSYRestDateModel *dateModel = self.dateModels[indexPath.section];
    HSYCommonModel *cellModel = dateModel.cellModels[indexPath.row];
    return cellModel.url;
}

- (BOOL)rowHasRead:(NSIndexPath *)indexPath {
    HSYRestDateModel *dateModel = self.dateModels[indexPath.section];
    HSYCommonModel *cellModel = dateModel.cellModels[indexPath.row];
    return cellModel.hasRead;
}

- (void)saveRowHasRead:(NSIndexPath *)indexPath {
    HSYRestDateModel *dateModel = self.dateModels[indexPath.section];
    HSYCommonModel *cellModel = dateModel.cellModels[indexPath.row];
    cellModel.hasRead = YES;
    [cellModel update];
}

- (BOOL)rowIsLike:(NSIndexPath *)indexPath {
    HSYRestDateModel *dateModel = self.dateModels[indexPath.section];
    HSYCommonModel *cellModel = dateModel.cellModels[indexPath.row];
    return cellModel.isLike;
}

- (void)saveRowIsLike:(BOOL)isLike indexPath:(NSIndexPath *)indexPath {
    HSYRestDateModel *dateModel = self.dateModels[indexPath.section];
    HSYCommonModel *cellModel = dateModel.cellModels[indexPath.row];
    cellModel.isLike = isLike;
    [cellModel update];
}

#pragma mark - Override
- (void)savePage:(NSInteger)section {
    [HSYUserDefaults setInteger:section forKey:HSYRestViewmodelPageID];
}

- (NSInteger)loadPage {
    return [HSYUserDefaults integerForKey:HSYRestViewmodelPageID];
}

- (void)saveOffsetY:(CGFloat)offsetY {
    [HSYUserDefaults setFloat:offsetY forKey:HSYRestViewmodelOffsetY];
}

- (CGFloat)loadOffsetY {
    return [HSYUserDefaults floatForKey:HSYRestViewmodelOffsetY];
}

- (void)saveCurrentSection:(NSInteger)section {
    [HSYUserDefaults setInteger:section forKey:HSYRestViewmodelCurrentSectionID];
}

- (NSInteger)loadCurrentSection {
    return [HSYUserDefaults integerForKey:HSYRestViewmodelCurrentSectionID];
}

#pragma HSYLoadValueProtocol
- (void)loadFirstValue {
    self.isLoadingNew = YES;
    self.historys = [HSYUserDefaults objectForKey:HSYHistoryID];
    if (FYEmpty(self.historys)) {
        [self loadNewValue];
    } else {
        self.page = [self loadPage];
        if (self.page == 0) {
            [self loadNewValue];
        } else {
            [self takeValueWithPage:0 length:self.page + HSYRestViewmodelPageStep];
        }
    }
}

- (void)loadNewValue {
    self.isLoadingNew = YES;
    self.page = 0;
    self.dateModels = [[NSArray alloc] init];
    [self requestHistory];
    [self savePage:self.page];
}

- (void)loadMoreValue {
    self.isLoadingMore = YES;
    [self takeValueWithPage:self.page length:HSYRestViewmodelPageStep];
    [self savePage:self.page];
}

#pragma HSYBindingParamProtocol
- (void)bindingParam {
    self.KVOController = [FBKVOController controllerWithObserver:self];
    
    [self.KVOController observe:self keyPath:@"tempModels" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld block:^(HSYRestViewmodel *observer, id object, NSDictionary *change) {
        // 如果临时数组都组装好了（组装后的个数等于组装前预计的个数）
        if (observer.tempCount > 0 && observer.tempModels.count == observer.tempCount) {
            
            // 排序
            NSSortDescriptor *dateStrDesc = [NSSortDescriptor sortDescriptorWithKey:@"dateStr" ascending:NO];
            NSArray *tempArr = [observer.tempModels sortedArrayUsingDescriptors:@[dateStrDesc]];
            
            observer.dateModels = [observer.dateModels arrayByAddingObjectsFromArray:tempArr];
            
            // page 步数增加
            observer.page = observer.page + HSYRestViewmodelPageStep;
            
            observer.isLoadingNew = NO;
            observer.isLoadingMore = NO;
        }
    }];
}

#pragma mark - 获取数据
- (void)requestHistory {
    
    FYWeakSelf(weakSelf);
    
    NSURL *url = [NSURL URLWithString:HSYHistoryUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:url.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        
        NSDictionary *dict = responseObject;
        NSArray *results = dict[@"results"];
        
        weakSelf.historys = results;
        // 保存
        [HSYUserDefaults setObject:weakSelf.historys forKey:HSYHistoryID];
        
        [weakSelf takeValueWithPage:weakSelf.page length:HSYRestViewmodelPageStep];

    } failure:^(NSURLSessionTask *operation, NSError *error) {
        FYLog(@"Error: %@", error);
        weakSelf.requestError = error;
    }];
}

- (void)takeValueWithPage:(NSInteger)page length:(NSInteger)length {
    // 判断数组越界
    if (page > self.historys.count) {
        self.noMore = YES;
        return;
    }
    
    NSInteger tempPage = page + length;
    if (tempPage > self.historys.count) {
        length = length - (tempPage - self.historys.count);
    }
    
    NSArray *tempHistoary = [self.historys subarrayWithRange:NSMakeRange(page, length)];
    
    // 清空临时model 数组
    self.tempModels = [[NSArray alloc] init];
    self.tempCount = length;
    
    for (NSString *dateStr in tempHistoary) {
        
        if (![HSYRestDateModel hasValueWithDateStr:dateStr]) {
            //请求新数据
            [self requestValueWithDateStr:dateStr];
        } else {
            //从数据库获取
            [self loadValueWithDateStr:dateStr];
        }
    }
}

- (void)requestValueWithDateStr:(NSString*)dateStr {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSArray *arr = [dateStr componentsSeparatedByString:@"-"];
    NSString *year = arr[0];
    NSString *month = arr[1];
    NSString *day = arr[2];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/%@/%@/%@", HSYBaseUrl, year, month, day];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    FYWeakSelf(weakSelf);
    [manager GET:url.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        
        NSDictionary *jsonDict = responseObject;
        NSDictionary *results = jsonDict[@"results"];
        
        HSYRestDateModel *dateModel = [[HSYRestDateModel alloc] initWithDateStr:dateStr params:results];
        weakSelf.tempModels = [weakSelf.tempModels arrayByAddingObject:dateModel];
        
        // 开启线程 保存
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [HSYRestDateModel saveWithParams:results dateStr:dateStr];
        });
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        
        weakSelf.requestError = error;
        FYLog(@"Error: %@", error);
    }];
}

- (void)loadValueWithDateStr:(NSString*)dateStr {
    FYWeakSelf(weakSelf);
    dispatch_async(dispatch_get_main_queue(), ^{
        HSYRestDateModel *dateModel = [[HSYRestDateModel alloc] initWithDateStr:dateStr];
        weakSelf.tempModels = [weakSelf.tempModels arrayByAddingObject:dateModel];
    });
}

@end
