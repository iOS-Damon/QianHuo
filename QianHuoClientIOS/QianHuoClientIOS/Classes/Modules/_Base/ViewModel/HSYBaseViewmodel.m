//
//  HSYBaseViewmodel.m
//  QianHuoClientIOS
//
//  Created by Sean on 16/3/28.
//  Copyright © 2016年 deeepthinking. All rights reserved.
//

#import "HSYBaseViewmodel.h"

@implementation HSYBaseViewmodel

- (instancetype)init {
    if (self = [super init]) {
        self.isFirstLoad = NO;
        [self bindingParam];
    }
    return self;
}
#pragma mark - 需要覆写的方法
#pragma 页数存取
- (void)savePage:(NSInteger)section {

}

- (NSInteger)loadPage {
    return 0;
}

#pragma 记录当前正在浏览的位置
- (void)saveOffsetY:(CGFloat)offsetY {
}

- (CGFloat)loadOffsetY {
    return 0;
}

#pragma 标记已读
- (BOOL)rowHasRead:(NSIndexPath *)indexPath {
    return NO;
}

- (void)saveRowHasRead:(NSIndexPath *)indexPath {

}

#pragma HSYLoadValueProtocol
- (void)loadFirstValue {

}

- (void)loadNewValue {

}

- (void)loadMoreValue {

}

#pragma HSYBindingParamProtocol
- (void)bindingParam {
    
}

#pragma mark - 请求数加减
- (void)addRequestCount {
    int tempCount = [self.requestCount intValue] + 1;
    self.requestCount = FYNum(tempCount);
}

- (void)decRequestCount {
    int tempCount = [self.requestCount intValue] - 1;
    self.requestCount = FYNum(tempCount);
}

#pragma mark - 获取headerTitle
- (NSString*)formatWithYear:(NSString*)year month:(NSString*)month day:(NSString*)day {
    return [NSString stringWithFormat:@"%@年%@月%@日", year, month, day];
}

@end
