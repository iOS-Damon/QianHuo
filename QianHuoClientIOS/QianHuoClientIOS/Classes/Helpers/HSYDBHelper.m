//
//  HSYDBHelper.m
//  QianHuoClientIOS
//
//  Created by Sean on 16/3/30.
//  Copyright © 2016年 deeepthinking. All rights reserved.
//

#import "HSYDBHelper.h"

static NSString * const HSYDBPath = @"QianHuoClient.db";

@interface HSYDBHelper ()

@end

@implementation HSYDBHelper

- (instancetype)init {
    self = [super init];
    if (self) {
        HSYDBHelper __weak *weakSelf = self;
        
        self.dbQueue = [FMDatabaseQueue databaseQueueWithPath:HSYDBPath];
        [self.dbQueue inDatabase:^(FMDatabase *db) {
            NSString *SQL = [weakSelf createTableSQL:[weakSelf tableName]];
            [db executeUpdate:SQL];
        }];
    }
    return self;
}

- (NSString*)tableName {
    return @"";
}

- (NSArray<HSYDBColumn*>*)columns {
    return @[];
}

- (void)insertWithObject:(id)object {

}

- (void)deleteWithObject:(id)object {

}

- (void)updateWithObject:(id)object {

}

- (id)selectWithObject:(id)object {
    return nil;
}

- (NSString*)createTableSQL:(NSString*)tableName {
    NSArray<HSYDBColumn*> *columns = [self columns];
    NSMutableString *SQL = [[NSMutableString alloc] initWithCapacity:5];
    [SQL appendFormat:@"CREATE TABLE IF NOT EXISTS %@", tableName];
    [SQL appendFormat:@"(id integer PRIMARY KEY AUTOINCREMENT, "];
    for (HSYDBColumn *column in columns) {
        [SQL appendFormat:@"%@ %@ NOT NULL,", column.name, column.type];
    }
    [SQL appendFormat:@");"];
    
    FYLog(@"%@", SQL);
    return SQL;
}

@end
