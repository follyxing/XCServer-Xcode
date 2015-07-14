//
//  XCServer.h
//  XCServer
//
//  Created by shaimi on 15/7/8.
//  Copyright (c) 2015年 XingCheng. All rights reserved.
//

#import <AppKit/AppKit.h>

@class XCServer;

static XCServer *sharedPlugin;

@interface XCServer : NSObject

+ (instancetype)sharedPlugin;
- (id)initWithBundle:(NSBundle *)plugin;

@property (nonatomic, strong, readonly) NSBundle* bundle;
@end