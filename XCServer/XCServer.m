//
//  XCServer.m
//  XCServer
//
//  Created by shaimi on 15/7/8.
//  Copyright (c) 2015年 XingCheng. All rights reserved.
//

#import "XCServer.h"
#import "XCMainWindowController.h"
@interface XCServer()
@property (nonatomic, strong, readwrite) NSBundle *bundle;
@property (nonatomic, strong) XCMainWindowController * mainVC;
@end

@implementation XCServer

+ (instancetype)sharedPlugin
{
    return sharedPlugin;
}

- (id)initWithBundle:(NSBundle *)plugin
{
    if (self = [super init]) {
        // reference to plugin's bundle, for resource access
        self.bundle = plugin;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didApplicationFinishLaunchingNotification:)
                                                     name:NSApplicationDidFinishLaunchingNotification
                                                   object:nil];
    }
    return self;
}

- (void)didApplicationFinishLaunchingNotification:(NSNotification*)noti{
    //removeObserver
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSApplicationDidFinishLaunchingNotification object:nil];
    
    // Create menu items, initialize UI, etc.
    // Sample Menu Item:
    NSMenuItem *menuItem = [[NSApp mainMenu] itemWithTitle:@"Window"];
    if (menuItem) {
        [[menuItem submenu] addItem:[NSMenuItem separatorItem]];
        NSMenuItem *actionMenuItem = [[NSMenuItem alloc] initWithTitle:@"XCServer" action:@selector(showMainVC) keyEquivalent:@""];
        [actionMenuItem setTarget:self];
        [[menuItem submenu] addItem:actionMenuItem];
    }
}
- (void)showMainVC{
    self.mainVC = [[XCMainWindowController alloc]initWithWindowNibName:@"XCMainWindowController"];
    [self.mainVC showWindow:self.mainVC];
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
