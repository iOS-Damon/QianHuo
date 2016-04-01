//
//  HSYRestDateModel.h
//  QianHuoClientIOS
//
//  Created by Sean on 16/4/1.
//  Copyright © 2016年 deeepthinking. All rights reserved.
//

#import "HSYBaseModel.h"
#import "HSYRestFuliModel.h"
#import "HSYRestVedioModel.h"

@interface HSYRestDateModel : HSYBaseModel

@property (nonatomic, strong) NSString *dateStr;
@property (nonatomic, strong) NSString *headerTitle;
@property (nonatomic, strong) NSArray *fuliModels;
@property (nonatomic, strong) NSArray *vedioModels;

- (instancetype)initWithParam:(NSDictionary*)param;

@end
