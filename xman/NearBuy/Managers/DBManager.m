//
//  DBManager.m
//  NearBuy
//
//  Created by URoad_MP on 15/6/19.
//  Copyright (c) 2015年 nearbuy. All rights reserved.
//

#import "DBManager.h"
#import <sqlite3.h>
@interface DBManager()

@end

@implementation DBManager
{
    sqlite3 *db;
}
DEF_SINGLETON(DBManager);

- (id)init{
    self = [super init];
    if (self) {
        NSString *resourcPath = [[NSBundle mainBundle]pathForResource:@"country" ofType:@"db"];
        if (sqlite3_open([resourcPath UTF8String], &db) !=SQLITE_OK) {
            sqlite3_close(db);
            NSLog(@"country.db open fail");
        }
    }
    return self;
}


- (void)getAllCountry:(LoadServerDataFinishedBlock)block{
    NSString *sql = @"select name from country";
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(db , [sql UTF8String], -1, &statement, nil) ==SQLITE_OK) {
        NSMutableArray *result = [NSMutableArray array];
        while (sqlite3_step(statement) == SQLITE_ROW) {
            NSString *name = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 0)];
            [result addObject:name];
        }
        block(result,YES);
    }else{
        block(nil,NO);
    }
}

- (void)getCountryCodeByName:(NSString *)name completed:(LoadServerDataFinishedBlock)block{
    NSString *sql = [NSString stringWithFormat:@"select num from country where name = '%@'",name];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(db , [sql UTF8String], -1, &statement, nil) ==SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            NSString *code = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 0)];
            block(code,YES);
        }
    }else{
        block(nil,NO);
    }
}

@end
