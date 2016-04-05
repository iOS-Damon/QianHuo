//
//  HSYRestViewmodel.m
//  QianHuoClientIOS
//
//  Created by Sean on 16/4/1.
//  Copyright © 2016年 deeepthinking. All rights reserved.
//

#import "HSYRestViewmodel.h"
#import "HSYBindingParamProtocol.h"
#import "FBKVOController.h"
#import "HSYCommonDBModel.h"
#import "FYUtils.h"
#import "HSYRestDateModel.h"
#import "AFNetworking.h"
#import "HSYUserDefaults.h"

static NSString * const HSYRestViewmodelSectionID = @"HSYRestViewmodelSectionID";
static NSString * const HSYRestViewmodelOffsetY = @"HSYRestViewmodelOffsetY";

@interface HSYRestViewmodel () <HSYBindingParamProtocol>

@property (nonatomic, strong) FBKVOController *KVOController;
@property (nonatomic, strong) NSArray *historys;
@property (nonatomic, assign) int page;

@end

@implementation HSYRestViewmodel

- (instancetype)init {
    self = [super init];
    if (self) {
        [self bindingParam];
        self.page = 0;
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
    return dateModel.fuliModels.count + dateModel.vedioModels.count;
}

- (NSInteger)rowsFuliCountInSection:(NSInteger)section {
    HSYRestDateModel *dateModel = self.dateModels[section];
    return dateModel.fuliModels.count;
}

- (NSInteger)rowsVedioCountInSection:(NSInteger)section {
    HSYRestDateModel *dateModel = self.dateModels[section];
    return dateModel.vedioModels.count;
}

- (UIImage*)rowAvatarAtIndexPath:(NSIndexPath *)indexPath {
    
    HSYRestDateModel *dateModel = self.dateModels[indexPath.section];
    
    if (indexPath.row >= dateModel.fuliModels.count) {
        NSInteger vedioIndex = indexPath.row - dateModel.fuliModels.count;
        HSYRestVedioModel *vedioModel = dateModel.vedioModels[vedioIndex];
        if ([vedioModel.type isEqualToString:@"休息视频"]) {
            return [UIImage imageNamed:@"AvatarVedio.png"];
        }
    }
    return nil;
}

- (NSString*)rowDescAtIndexPath:(NSIndexPath *)indexPath {
    
    HSYRestDateModel *dateModel = self.dateModels[indexPath.section];
    if (indexPath.row >= dateModel.fuliModels.count) {
        NSInteger vedioIndex = indexPath.row - dateModel.fuliModels.count;
        HSYRestVedioModel *vedioModel = dateModel.vedioModels[vedioIndex];
        return vedioModel.desc;
    }
    return @"";
}

- (NSString*)rowUrlAtIndexPath:(NSIndexPath *)indexPath {
    
    HSYRestDateModel *dateModel = self.dateModels[indexPath.section];
    if (indexPath.row < dateModel.fuliModels.count) {
        HSYRestFuliModel *fuliModel = dateModel.fuliModels[indexPath.row];
        return fuliModel.url;
    } else {
        NSInteger vedioIndex = indexPath.row - dateModel.fuliModels.count;
        HSYRestVedioModel *vedioModel = dateModel.vedioModels[vedioIndex];
        return vedioModel.url;
    }
    return @"";
}

- (void)saveSection:(NSInteger)section {
    [HSYUserDefaults setInteger:section forKey:HSYRestViewmodelSectionID];
}

- (void)saveOffsetY:(CGFloat)offsetY {
    [HSYUserDefaults setFloat:offsetY forKey:HSYRestViewmodelOffsetY];
}

- (CGFloat)loadOffsetY {
    CGFloat offsetY = [HSYUserDefaults floatForKey:HSYRestViewmodelOffsetY];
    return offsetY;
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
    [self loadFirstValueFromDB];
}

- (void)loadMoreValue {
    [self loadMoreValueFromDB];
}

#pragma mark - HSYBindingParamProtocol
- (void)bindingParam {
    self.KVOController = [FBKVOController controllerWithObserver:self];
    [self.KVOController observe:self keyPath:@"historys" options:NSKeyValueObservingOptionNew block:^(HSYRestViewmodel *observer, id object, NSDictionary *change) {
        
        [observer loadFirstValueFromDB];
    }];
}

#pragma mark - 获取网络数据
- (void)requestHistory {
    
    NSURL *url = [NSURL URLWithString:HSYHistoryUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:url.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        
        NSDictionary *dict = responseObject;
        NSArray *results = dict[@"results"];
        
        self.historys = results;
        
        [HSYUserDefaults setObject:self.historys forKey:HSYHistoryID];
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        FYLog(@"Error: %@", error);
        self.requestError = error;
    }];
}

- (void)requestFirstValue {
    
    HSYRestViewmodel __weak *weakSelf = self;
    
    if (FYEmpty(self.historys)) {
        return;
    }
    
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
        
        HSYRestDateModel *dateModel = [[HSYRestDateModel alloc] initWithParam:results];
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
    HSYRestViewmodel __weak *weakSelf = self;
    
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
        
        HSYRestDateModel *dateModel = [[HSYRestDateModel alloc] initWithParam:results];
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
    
    NSInteger page = [HSYUserDefaults integerForKey:HSYRestViewmodelSectionID] + 1;
    NSArray *dbModels = [HSYCommonDBModel findWithFormat:@" LIMIT %ld", page];
    if (!FYEmpty(dbModels)) {
        NSMutableArray *temp = [[NSMutableArray alloc] initWithCapacity:5];
        
        for (HSYCommonDBModel *dbModel in dbModels) {
            NSDictionary *dictResult = [FYUtils dictionaryWithJSONString:dbModel.results];
            
            HSYRestDateModel *dateModel = [[HSYRestDateModel alloc] initWithParam:dictResult];
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
        self.noMore = YES;
        return;
    }
    
    NSString *dateStr = self.historys[self.page];
    HSYCommonDBModel *dbModel = [HSYCommonDBModel findFirstWithFormat:@" WHERE %@ = '%@'", @"dateStr", dateStr];
    
    if (dbModel) {
        NSDictionary *dictResult = [FYUtils dictionaryWithJSONString:dbModel.results];
        
        HSYRestDateModel *dateModel = [[HSYRestDateModel alloc] initWithParam:dictResult];
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
