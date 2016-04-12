//
//  HSYRestVedioModel.h
//  QianHuoClientIOS
//
//  Created by Sean on 16/4/1.
//  Copyright © 2016年 deeepthinking. All rights reserved.
//

#import "HSYBaseModel.h"

@interface HSYRestVedioModel : HSYBaseModel

@property (nonatomic, strong) NSString *cellId;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, assign) BOOL hasRead;

- (instancetype)initWithParam:(NSDictionary*)param;

@end
