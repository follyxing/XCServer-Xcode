//
//  XCMainWindowController.m
//  XCServer
//
//  Created by shaimi on 15/7/9.
//  Copyright (c) 2015年 XingCheng. All rights reserved.
//

#import "XCMainWindowController.h"
#import "OCFWebServer.h"
#import "OCFWebServerRequest.h"
#import "OCFWebServerResponse.h"
static OCFWebServer * server;
@interface XCMainWindowController ()
@property (weak) IBOutlet NSImageView *statusImageV;
@property (weak) IBOutlet NSTextField *portTF;
@property (nonatomic,assign) NSInteger port;
@end

@implementation XCMainWindowController
-(OCFWebServer *)server{
    if (!server) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            server = [[OCFWebServer alloc]init];
            [server addDefaultHandlerForMethod:@"GET"
                                  requestClass:[OCFWebServerRequest class]
                                  processBlock:^void(OCFWebServerRequest *request) {
                                      OCFWebServerResponse *response = [OCFWebServerDataResponse responseWithText:@"{\"XCServer\":\"Hello World\"}"];
                                      [request respondWith:response];
                                  }];
        });
     }
    return server;
}
-(void)windowWillLoad{
    [super windowWillLoad];

}
- (void)windowDidLoad {
    [super windowDidLoad];
    [self serverIsRunning:[self.server isRunning]];
}
- (IBAction)startService:(id)sender {
    if (![self.server isRunning]) {
        if([self isAvailablePort:self.portTF.stringValue]){
            self.port = [self.portTF.stringValue integerValue];
            [self serverIsRunning:YES];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                if(![self.server runWithPort:self.port]){
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [self serverIsRunning:NO];
                        [self alertWithContent:@"start faild!"];
                    });
                    
                }
            });
        }else{
            [self alertWithContent:@"Port Error!"];
        }
        
    }
}
- (IBAction)stopService:(id)sender {
    if([self.server isRunning]){
        [self.server stop];
        [self serverIsRunning:NO];
    }else{
        [self alertWithContent:@"already stopped!"];
    }
    
}
-(void)alertWithContent:(NSString *)content{
    NSAlert * alert = [[NSAlert alloc]init];
    [alert setMessageText:content];
    [alert runModal];

}
-(BOOL)isAvailablePort:(NSString *)port{
    NSScanner* scan = [NSScanner scannerWithString:port];
    int val;
    if ([port integerValue]>=0&&[port integerValue]<=65535&&[scan scanInt:&val]) {
        return YES;
    }
    return NO;
}

-(void)serverIsRunning:(BOOL)isRunning{
    if (isRunning) {
        [self.statusImageV setImage:[NSImage imageNamed:NSImageNameStatusAvailable]];
    }else{
        [self.statusImageV setImage:[NSImage imageNamed:NSImageNameStatusUnavailable]];
    }
}
@end
