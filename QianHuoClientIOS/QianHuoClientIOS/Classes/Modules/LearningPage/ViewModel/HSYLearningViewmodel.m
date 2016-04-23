//
//  HSYLearningTimeViewmodel.m
//  QianHuoClientIOS
//
//  Created by Sean on 16/3/28.
//  Copyright © 2016年 deeepthinking. All rights reserved.
//

#import "HSYLearningViewmodel.h"
#import "HSYBindingParamProtocol.h"
#import "HSYLearningDateModel.h"
#import "FBKVOController.h"
#import "FYUtils.h"
#import "AFNetworking.h"
#import "HSYUserDefaults.h"
#import "HSYCommenDateModel.h"

static NSString * const HSYLearningViewmodelOffsetY = @"HSYLearningViewmodelOffsetY";
static NSString * const HSYLearningViewmodelPageID = @"HSYLearningViewmodelPageID";
static int const HSYLearningViewmodelPageStep = 10;

@interface HSYLearningViewmodel ()

@property (atomic, strong) NSArray *tempModels;
@property (nonatomic, assign) NSInteger tempCount;

@end

@implementation HSYLearningViewmodel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.dateModels = [[NSArray alloc] init];
        self.tempModels = [[NSArray alloc] init];
        self.tempCount = 0;
    }
    return self;
}

#pragma mark - 让view获取数据
- (NSInteger)sectionsCount {
    return self.dateModels.count;
}

- (NSString*)headerTitleInSection:(NSInteger)section {
    HSYLearningDateModel *dateModel = self.dateModels[section];
    return dateModel.headerTitle;
}

- (NSInteger)rowsCountInSection:(NSInteger)section {
    HSYLearningDateModel *dateModel = self.dateModels[section];
    return dateModel.cellModels.count;
}

- (UIImage*)rowAvatarAtIndexPath:(NSIndexPath *)indexPath {
    HSYLearningDateModel *dateModel = self.dateModels[indexPath.section];
    HSYCommonModel *cellModel = dateModel.cellModels[indexPath.row];
    return [UIImage imageNamed:cellModel.avatarName];
}

- (NSString*)rowTitleAtIndexPath:(NSIndexPath *)indexPath {
    HSYLearningDateModel *dateModel = self.dateModels[indexPath.section];
    HSYCommonModel *cellModel = dateModel.cellModels[indexPath.row];
    return cellModel.type;
}

- (NSString*)rowDescAtIndexPath:(NSIndexPath *)indexPath {
    HSYLearningDateModel *dateModel = self.dateModels[indexPath.section];
    HSYCommonModel *cellModel = dateModel.cellModels[indexPath.row];
    return cellModel.desc;
}

- (NSString*)rowUrlAtIndexPath:(NSIndexPath *)indexPath {
    HSYLearningDateModel *dateModel = self.dateModels[indexPath.section];
    HSYCommonModel *cellModel = dateModel.cellModels[indexPath.row];
    return cellModel.url;
}

- (BOOL)rowHasRead:(NSIndexPath *)indexPath {
    HSYLearningDateModel *dateModel = self.dateModels[indexPath.section];
    HSYCommonModel *cellModel = dateModel.cellModels[indexPath.row];
    return cellModel.hasRead;
}

- (void)saveRowHasRead:(NSIndexPath *)indexPath {
    HSYLearningDateModel *dateModel = self.dateModels[indexPath.section];
    HSYCommonModel *cellModel = dateModel.cellModels[indexPath.row];
    cellModel.hasRead = YES;
    [cellModel update];
}

- (BOOL)rowIsLike:(NSIndexPath *)indexPath {
    HSYLearningDateModel *dateModel = self.dateModels[indexPath.section];
    HSYCommonModel *cellModel = dateModel.cellModels[indexPath.row];
    return cellModel.isLike;
}

- (void)saveRowIsLike:(BOOL)isLike indexPath:(NSIndexPath *)indexPath {
    HSYLearningDateModel *dateModel = self.dateModels[indexPath.section];
    HSYCommonModel *cellModel = dateModel.cellModels[indexPath.row];
    cellModel.isLike = isLike;
    [cellModel update];
}

#pragma mark - override
- (void)savePage:(NSInteger)section {
    [HSYUserDefaults setInteger:section forKey:HSYLearningViewmodelPageID];
}

- (NSInteger)loadPage {
    return [HSYUserDefaults integerForKey:HSYLearningViewmodelPageID];
}

- (void)saveOffsetY:(CGFloat)offsetY {
    [HSYUserDefaults setFloat:offsetY forKey:HSYLearningViewmodelOffsetY];
}

- (CGFloat)loadOffsetY {
    return [HSYUserDefaults floatForKey:HSYLearningViewmodelOffsetY];
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
            [self takeValueWithPage:0 length:self.page + HSYLearningViewmodelPageStep];
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
    
    [self takeValueWithPage:self.page length:HSYLearningViewmodelPageStep];
    [self savePage:self.page];
}

#pragma HSYBindingParamProtocol
- (void)bindingParam {
    
    [self.KVOController observe:self keyPath:@"tempModels" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld block:^(HSYLearningViewmodel *observer, id object, NSDictionary *change) {
        if (observer.tempCount > 0 && observer.tempModels.count == observer.tempCount) {
            
            // 排序
            NSSortDescriptor *dateStrDesc = [NSSortDescriptor sortDescriptorWithKey:@"dateStr" ascending:NO];
            NSArray *tempArr = [observer.tempModels sortedArrayUsingDescriptors:@[dateStrDesc]];
            
            observer.dateModels = [observer.dateModels arrayByAddingObjectsFromArray:tempArr];
            observer.page = observer.page + HSYLearningViewmodelPageStep;
            
            if (!observer.isFirstLoad) {
                observer.isFirstLoad = YES;
            }
            
            self.isLoadingNew = NO;
            self.isLoadingMore = NO;
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
        [HSYUserDefaults setObject:weakSelf.historys forKey:HSYHistoryID];
        
        [weakSelf takeValueWithPage:weakSelf.page length:HSYLearningViewmodelPageStep];
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        FYLog(@"Error: %@", error);
        weakSelf.requestError = error;
    }];
}

- (void)takeValueWithPage:(NSInteger)page length:(NSInteger)length {
    if (page > self.historys.count) {
        self.noMore = YES;
        return;
    }
    
    NSInteger tempPage = page + length;
    if (tempPage > self.historys.count) {
        length = length - (tempPage - self.historys.count);
    }
    
    NSArray *tempHistoary = [self.historys subarrayWithRange:NSMakeRange(page, length)];
    
    self.tempModels = [[NSArray alloc] init];
    self.tempCount = length;
    
    for (NSString *dateStr in tempHistoary) {
        
        if (![HSYLearningDateModel hasValueWithDateStr:dateStr]) {
            //请求新数据
            [self requestValueWithDateStr:dateStr];
        } else {
            //从数据库获取
            [self loadValueWithDateStr:dateStr];
        }
    }
}

- (void)requestValueWithDateStr:(NSString*)dateStr {
    
    FYWeakSelf(weakSelf);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSArray *arr = [dateStr componentsSeparatedByString:@"-"];
    NSString *year = arr[0];
    NSString *month = arr[1];
    NSString *day = arr[2];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/%@/%@/%@", HSYBaseUrl, year, month, day];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    [manager GET:url.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        
        NSDictionary *jsonDict = responseObject;
        NSDictionary *results = jsonDict[@"results"];
        
        HSYLearningDateModel *dateModel = [[HSYLearningDateModel alloc] initWithDateStr:dateStr params:results];
        weakSelf.tempModels = [weakSelf.tempModels arrayByAddingObject:dateModel];
        
        // 保存
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [HSYLearningDateModel saveWithParams:results dateStr:dateStr];
        });
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        
        weakSelf.requestError = error;
        FYLog(@"Error: %@", error);
    }];
}

- (void)loadValueWithDateStr:(NSString*)dateStr {
    HSYLearningDateModel *dateModel = [[HSYLearningDateModel alloc] initWithDateStr:dateStr];
    self.tempModels = [self.tempModels arrayByAddingObject:dateModel];
}

@end
