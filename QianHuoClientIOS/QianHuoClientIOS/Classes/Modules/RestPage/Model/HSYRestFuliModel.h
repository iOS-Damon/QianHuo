//
//  HSYRestCellModel.h
//  QianHuoClientIOS
//
//  Created by Sean on 16/4/1.
//  Copyright © 2016年 deeepthinking. All rights reserved.
//

#import "HSYBaseModel.h"

@interface HSYRestFuliModel : HSYBaseModel

@property (nonatomic, strong) NSString *url;

- (instancetype)initWithParam:(NSDictionary*)param;

@end
