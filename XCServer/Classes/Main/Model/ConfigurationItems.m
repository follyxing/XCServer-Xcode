//
//  ConfigurationItems.m
//  XCServer
//
//  Created by shaimi on 15/7/13.
//  Copyright (c) 2015年 XingCheng. All rights reserved.
//

#import "ConfigurationItems.h"
#import "FMDB.h"
#import "ConfigurationItem.h"
@implementation ConfigurationItems
+(NSArray *)allIteams{
    NSString* path = [[NSBundle bundleForClass:[self class]]pathForResource:@"XCServer.db" ofType:nil];
    FMDatabase * db = [FMDatabase databaseWithPath:path];
    [db open];
    FMResultSet * resultSet = [db executeQuery:@"SELECT id,uri,responseType,responseContent,opt_date from conf_item"];
    NSMutableArray * itemsArr =[NSMutableArray array];
    while ([resultSet next]) {
        ConfigurationItem * item = [[ConfigurationItem alloc]init];
        item.ID = [resultSet intForColumn:@"id"];
        item.uri = [resultSet stringForColumn:@"uri"];
        item.responseType  =[ resultSet stringForColumn:@"responseType"];
        item.responseContent = [resultSet stringForColumn:@"responseContent"];
        item.optDate = [resultSet intForColumn:@"opt_date"];
        [itemsArr addObject:item];
    }
    [db close];
    return itemsArr;

}
@end
