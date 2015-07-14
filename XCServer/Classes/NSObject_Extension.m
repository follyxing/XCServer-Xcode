//
//  NSObject_Extension.m
//  XCServer
//
//  Created by shaimi on 15/7/8.
//  Copyright (c) 2015年 XingCheng. All rights reserved.
//


#import "NSObject_Extension.h"
#import "XCServer.h"

@implementation NSObject (Xcode_Plugin_Template_Extension)

+ (void)pluginDidLoad:(NSBundle *)plugin
{
    static dispatch_once_t onceToken;
    NSString *currentApplicationName = [[NSBundle mainBundle] infoDictionary][@"CFBundleName"];
    if ([currentApplicationName isEqual:@"Xcode"]) {
        dispatch_once(&onceToken, ^{
            sharedPlugin = [[XCServer alloc] initWithBundle:plugin];
        });
    }
}
@end
