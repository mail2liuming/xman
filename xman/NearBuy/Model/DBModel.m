//
//  DBModel.m
//  NearBuy
//
//  Created by URoad_MP on 15/9/24.
//  Copyright © 2015年 nearbuy. All rights reserved.
//

#import "DBModel.h"
#import <sqlite3.h>

#define CREATE_NEW_COMMENT_TABLE @"CREATE TABLE IF NOT EXISTS COMMENTTABLE (ID INTEGER PRIMARY KEY AUTOINCREMENT ,ADID TEXT,COMMENTCOUNT TEXT,ADTYPE TEXT)"


@implementation DBModel
{
    sqlite3 *db;
}
DEF_SINGLETON(DBModel)



- (id)init{
    self = [super init];
    if (self) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *cache = paths[0];
        NSString *db_path = [cache stringByAppendingPathComponent:@"NearByDB.sqlite"];
        if (sqlite3_open([db_path UTF8String], &db)!=SQLITE_OK) {
            sqlite3_close(db);
            NSLog(@"sqte ");
        }else{
            [self createTable];
        }
    }
    return self;
}


-(void)execSql:(NSString *)sql completed:(void(^)(bool result))completedBlock;
{
    char *err;
    if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) {
        sqlite3_close(db);
        if (completedBlock) {
            completedBlock(NO);
        }
    }else{
        if (completedBlock) {
            completedBlock(YES);
        }
    }
}
- (void)createTable{

    [self execSql:CREATE_NEW_COMMENT_TABLE completed:^(bool result) {
        
    }];

}

- (void)updateAd:(EtyAd *)ad toType:(NSString *)type{
    NSString *searchSql = [NSString stringWithFormat:@"select count(*) from COMMENTTABLE where ADID = '%@' and ADTYPE= '%@'",ad.ad_id,type];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(db, [searchSql UTF8String], -1, &statement, nil)==SQLITE_OK) {
        if (sqlite3_step(statement) == SQLITE_ROW) {
            int allcount = sqlite3_column_int(statement, 0);
            if (allcount>0) {
                NSString *sql = [NSString stringWithFormat:@"update COMMENTTABLE set COMMENTCOUNT='%@' where ADID = '%@' and ADTYPE= '%@'",ad.commentcount,ad.ad_id,type];
                [self execSql:sql completed:^(bool result) {
                    
                }];
            }else{
                NSString*sql = [NSString stringWithFormat:@"insert into COMMENTTABLE('ADID','COMMENTCOUNT','ADTYPE')values('%@','%@','%@')",ad.ad_id,ad.commentcount,type];
                [self execSql:sql completed:^(bool result) {
                    if (result) {

                    }else{
                        
                        
                    }
                }];
            }
            
        }else{
            NSString*sql = [NSString stringWithFormat:@"insert into COMMENTTABLE('ADID','COMMENTCOUNT','ADTYPE')values('%@','%@','%@')",ad.ad_id,ad.commentcount,type];
            [self execSql:sql completed:^(bool result) {
                if (result) {
                    
                }else{
                    
                    
                }
            }];
            
        }
    }else{
        NSString*sql = [NSString stringWithFormat:@"insert into COMMENTTABLE('ADID','COMMENTCOUNT','ADTYPE')values('%@','%@','%@')",ad.ad_id,ad.commentcount,type];
        [self execSql:sql completed:^(bool result) {
            if (result) {
                
            }else{
                
                
            }
        }];
        
    }
}

- (NSString *)queryCommentCount:(EtyAd *)ad byType:(NSString *)type{
    NSString *sql = [NSString stringWithFormat:@"select COMMENTCOUNT from COMMENTTABLE where ADID = '%@' and ADTYPE='%@'",ad.ad_id,type];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, nil)==SQLITE_OK) {
        if (sqlite3_step(statement) == SQLITE_ROW) {
            NSString *place_name = [[NSString alloc]initWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
            return place_name;
        }else{
            return @"0";
        }
    }else{
        return @"0";
    }

}

@end
