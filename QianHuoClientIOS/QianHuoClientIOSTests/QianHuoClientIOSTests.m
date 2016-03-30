//
//  QianHuoClientIOSTests.m
//  QianHuoClientIOSTests
//
//  Created by Sean on 16/3/25.
//  Copyright © 2016年 deeepthinking. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "HSYLearningDateModel.h"
#import "NSString+FY.h"

@interface QianHuoClientIOSTests : XCTestCase

@property HSYLearningDateModel *dateModel;
@property NSMutableArray *dateModels;

@end

@implementation QianHuoClientIOSTests

- (void)setUp {
    [super setUp];
    self.dateModel = [[HSYLearningDateModel alloc] init];
    self.dateModels = [[NSMutableArray alloc] initWithCapacity:5];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    [self.dateModel loadNewValue];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
