//
//  HSYCommenDateModel.h
//  QianHuoClientIOS
//
//  Created by Sean on 16/4/17.
//  Copyright © 2016年 deeepthinking. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSYCommonModel.h"

@interface HSYCommenDateModel : NSObject

@property (nonatomic, copy) NSString *headerTitle;
@property (nonatomic, strong) NSArray <HSYCommonModel*> *androids;
@property (nonatomic, strong) NSArray <HSYCommonModel*> *ioses;
@property (nonatomic, strong) NSArray <HSYCommonModel*> *appes;
@property (nonatomic, strong) NSArray <HSYCommonModel*> *htmls;
@property (nonatomic, strong) NSArray <HSYCommonModel*> *resources;
@property (nonatomic, strong) NSArray <HSYCommonModel*> *introduces;
@property (nonatomic, strong) NSArray <HSYCommonModel*> *vedios;
@property (nonatomic, strong) NSArray <HSYCommonModel*> *fulis;

- (void)saveWithParams:(NSDictionary*)params dateStr:(NSString*)dateStr;
- (void)loadWithDateStr:(NSString*)dateStr;

@end
