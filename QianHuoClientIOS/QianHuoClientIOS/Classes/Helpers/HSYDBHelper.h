//
//  HSYDBHelper.h
//  QianHuoClientIOS
//
//  Created by Sean on 16/3/30.
//  Copyright © 2016年 deeepthinking. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
#import "HSYDBColumn.h"

@interface HSYDBHelper : NSObject

@property (nonatomic, strong) FMDatabaseQueue *dbQueue;

- (NSString*)tableName;
- (NSArray<HSYDBColumn*>*)columns;

- (void)insertWithObject:(id)object;
- (void)deleteWithObject:(id)object;
- (void)updateWithObject:(id)object;
- (id)selectWithObject:(id)object;

@end
