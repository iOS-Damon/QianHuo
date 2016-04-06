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
#import "HSYCommonDBModel.h"

static NSString * const HSYLearningViewmodelSectionID = @"HSYLearningViewmodelSectionID";
static NSString * const HSYLearningViewmodelOffsetY = @"HSYLearningViewmodelOffsetY";
static NSString * const HSYLearningViewmodelHasReadID = @"HSYLearningViewmodelHasReadID";

@interface HSYLearningViewmodel () <HSYBindingParamProtocol>

@property (nonatomic, strong) FBKVOController *KVOController;
@property (nonatomic, strong) NSArray *historys;
@property (nonatomic, assign) int page;

@end

@implementation HSYLearningViewmodel

- (instancetype)init {
    self = [super init];
    if (self) {
        [self bindingParam];
        self.page = 0;
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
    HSYLearningCellModel *cellModel = dateModel.cellModels[indexPath.row];
    if ([cellModel.type isEqualToString:@"Android"]) {
        return [UIImage imageNamed:@"AvatarAndroid.png"];
    } else if([cellModel.type isEqualToString:@"iOS"]) {
        return [UIImage imageNamed:@"AvatarIOS.png"];
    } else if([cellModel.type isEqualToString:@"App"]) {
        return [UIImage imageNamed:@"AvatarApp.png"];
    } else if([cellModel.type isEqualToString:@"前端"]) {
        return [UIImage imageNamed:@"AvatarHtml.png"];
    } else if([cellModel.type isEqualToString:@"拓展资源"]) {
        return [UIImage imageNamed:@"AvatarResource.png"];
    } else if([cellModel.type isEqualToString:@"瞎推荐"]) {
        return [UIImage imageNamed:@"AvatarIntroduce.png"];
    } else {
        return [UIImage imageNamed:@""];
    }
    return [UIImage imageNamed:@""];
}

- (NSString*)rowDescAtIndexPath:(NSIndexPath *)indexPath {
    HSYLearningDateModel *dateModel = self.dateModels[indexPath.section];
    HSYLearningCellModel *cellModel = dateModel.cellModels[indexPath.row];
    return cellModel.desc;
}

- (NSString*)rowUrlAtIndexPath:(NSIndexPath *)indexPath {
    HSYLearningDateModel *dateModel = self.dateModels[indexPath.section];
    HSYLearningCellModel *cellModel = dateModel.cellModels[indexPath.row];
    return cellModel.url;
}

#pragma mark - override

- (void)saveSection:(NSInteger)section {
    [HSYUserDefaults setInteger:section forKey:HSYLearningViewmodelSectionID];
}

- (void)saveOffsetY:(CGFloat)offsetY {
    [HSYUserDefaults setFloat:offsetY forKey:HSYLearningViewmodelOffsetY];
}

- (CGFloat)loadOffsetY {
    CGFloat offsetY = [HSYUserDefaults floatForKey:HSYLearningViewmodelOffsetY];
    return offsetY;
}

- (void)saveHasReadIndexPath:(NSIndexPath *)path {
    NSString *pathID = [NSString stringWithFormat:@"%@%ld%ld", HSYLearningViewmodelHasReadID, (long)path.section, (long)path.row];
    [HSYUserDefaults setBool:YES forKey:pathID];
}

- (BOOL)indexPathHasRead:(NSIndexPath *)path {
    NSString *pathID = [NSString stringWithFormat:@"%@%ld%ld", HSYLearningViewmodelHasReadID, (long)path.section, (long)path.row];
    return [HSYUserDefaults BoolForKey:pathID];
}

#pragma mark - HSYLoadValueProtocol
- (void)loadFirstValue {
    
    NSArray *historys = [HSYUserDefaults objectForKey:HSYHistoryID];
    if (!FYEmpty(historys)) {
        self.historys = historys;
    } else {
        [self requestHistory];
    }
    self.isFirstLoad = YES;
}

- (void)loadNewValue {
    [self requestHistory];
}

- (void)loadMoreValue {
    [self loadMoreValueFromDB];
}

#pragma mark - HSYBindingParamProtocol
- (void)bindingParam {
    
    self.KVOController = [FBKVOController controllerWithObserver:self];
    [self.KVOController observe:self keyPath:@"historys" options:NSKeyValueObservingOptionNew block:^(HSYLearningViewmodel *observer, id object, NSDictionary *change) {
        
        [observer loadFirstValueFromDB];
    }];
}

#pragma mark - 获取网络数据
- (void)requestHistory {
    
    HSYLearningViewmodel __weak *weakSelf = self;
    
    NSURL *url = [NSURL URLWithString:HSYHistoryUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:url.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        
        NSDictionary *dict = responseObject;
        NSArray *results = dict[@"results"];
        
        weakSelf.historys = results;
        
        [HSYUserDefaults setObject:weakSelf.historys forKey:HSYHistoryID];
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        FYLog(@"Error: %@", error);
        weakSelf.requestError = error;
    }];
}

- (void)requestFirstValue {
    
    if (FYEmpty(self.historys)) {
        return;
    }
    
    HSYLearningViewmodel __weak *weakSelf = self;
    
    NSString *dateStr = self.historys[0];
    NSArray *arr = [dateStr componentsSeparatedByString:@"-"];
    NSString *year = arr[0];
    NSString *month = arr[1];
    NSString *day = arr[2];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/%@/%@/%@", HSYBaseUrl, year, month, day];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:url.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        
        NSDictionary *jsonDict = responseObject;
        NSDictionary *results = jsonDict[@"results"];
        
        HSYLearningDateModel *dateModel = [[HSYLearningDateModel alloc] initWithParam:results];
        dateModel.dateStr = dateStr;
        dateModel.headerTitle = [weakSelf formatWithYear:year month:month day:day];
        weakSelf.dateModels = @[dateModel];
        
        //保存到数据库
        HSYCommonDBModel *dbModel = [[HSYCommonDBModel alloc] init];
        dbModel.dateStr = dateStr;
        dbModel.headerTitle = dateModel.headerTitle;
        dbModel.results = [FYUtils JSONStringWithDictionary:results];
        [dbModel saveOrUpdate];
        
        self.page = 1;
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        FYLog(@"Error: %@", error);
        self.requestError = error;
    }];
}

- (void)requestMoreValue {
    HSYLearningViewmodel __weak *weakSelf = self;
    
    if (self.page >= self.historys.count) {
        return;
    }
    
    NSString *dateStr = self.historys[self.page];
    NSArray *arr = [dateStr componentsSeparatedByString:@"-"];
    NSString *year = arr[0];
    NSString *month = arr[1];
    NSString *day = arr[2];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/%@/%@/%@", HSYBaseUrl, year, month, day];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:url.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        
        NSDictionary *jsonDict = responseObject;
        NSDictionary *results = jsonDict[@"results"];
        
        HSYLearningDateModel *dateModel = [[HSYLearningDateModel alloc] initWithParam:results];
        dateModel.dateStr = dateStr;
        dateModel.headerTitle = [weakSelf formatWithYear:year month:month day:day];
        
        //保存到数据库
        HSYCommonDBModel *dbModel = [[HSYCommonDBModel alloc] init];
        dbModel.dateStr = dateStr;
        dbModel.headerTitle = dateModel.headerTitle;
        dbModel.results = [FYUtils JSONStringWithDictionary:results];
        [dbModel saveOrUpdate];
        
        NSMutableArray *temp = [NSMutableArray arrayWithArray:weakSelf.dateModels];
        [temp addObject:dateModel];
        weakSelf.dateModels = temp;
        
        self.page = self.page + 1;
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        FYLog(@"Error: %@", error);
        self.requestError = error;
    }];
}

#pragma mark - 获取数据库数据

- (void)loadFirstValueFromDB {
    
    NSInteger page = [HSYUserDefaults integerForKey:HSYLearningViewmodelSectionID] + 1;
    NSArray *dbModels = [HSYCommonDBModel findWithFormat:@" LIMIT %ld", page];
    if (!FYEmpty(dbModels)) {
        NSMutableArray *temp = [[NSMutableArray alloc] initWithCapacity:5];
        
        for (HSYCommonDBModel *dbModel in dbModels) {
            NSDictionary *dictResult = [FYUtils dictionaryWithJSONString:dbModel.results];
            
            HSYLearningDateModel *dateModel = [[HSYLearningDateModel alloc] initWithParam:dictResult];
            dateModel.dateStr = dbModel.dateStr;
            dateModel.headerTitle = dbModel.headerTitle;
            
            [temp addObject:dateModel];
        }
        
        self.dateModels = temp;
    } else {
        [self requestFirstValue];
    }
    
    self.page = (int)page;
}

- (void)loadMoreValueFromDB {
    
    if (self.page >= self.historys.count) {
        return;
    }
    
    NSString *dateStr = self.historys[self.page];
    HSYCommonDBModel *dbModel = [HSYCommonDBModel findFirstWithFormat:@" WHERE %@ = '%@'", @"dateStr", dateStr];
    
    if (dbModel) {
        NSDictionary *dictResult = [FYUtils dictionaryWithJSONString:dbModel.results];
        
        HSYLearningDateModel *dateModel = [[HSYLearningDateModel alloc] initWithParam:dictResult];
        dateModel.dateStr = dbModel.dateStr;
        dateModel.headerTitle = dbModel.headerTitle;
        
        NSMutableArray *temp = [NSMutableArray arrayWithArray:self.dateModels];
        [temp addObject:dateModel];
        self.dateModels = temp;
        
        self.page = self.page + 1;
    } else {
        [self requestMoreValue];
    }
}

#pragma mark - 获取headerTitle
- (NSString*)formatWithYear:(NSString*)year month:(NSString*)month day:(NSString*)day {
    return [NSString stringWithFormat:@"%@年%@月%@日", year, month, day];
}

@end
