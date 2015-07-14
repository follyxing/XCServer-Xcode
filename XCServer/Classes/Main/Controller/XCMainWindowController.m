//
//  XCMainWindowController.m
//  XCServer
//
//  Created by shaimi on 15/7/9.
//  Copyright (c) 2015年 XingCheng. All rights reserved.
//

#import "XCMainWindowController.h"
#import "GCDWebServer.h"
#import "GCDWebServerRequest.h"
#import "GCDWebServerDataResponse.h"
#import "ConfigurationItems.h"
#import "ConfigurationItem.h"
#import "TestWindow.h"
static GCDWebServer * server;
@interface XCMainWindowController ()<NSTableViewDelegate,NSTableViewDataSource>
@property (weak) IBOutlet NSImageView *statusImageV;
@property (weak) IBOutlet NSTextField *portTF;
@property (nonatomic,assign) NSInteger port;
@property (weak) IBOutlet NSTableView *testTabelView;
@property (nonatomic,strong)TestWindow *tv;
@end

@implementation XCMainWindowController
-(GCDWebServer *)server{
    if (!server) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            server = [[GCDWebServer alloc]init];
            [server addDefaultHandlerForMethod:@"GET" requestClass:[GCDWebServerRequest class] processBlock:^GCDWebServerResponse *(GCDWebServerRequest *request) {
                return [GCDWebServerDataResponse responseWithText:@"{\"XCServer\":\"helloworld\"}"];
            }];
            [self initData];
        });
     }
    return server;
}
- (IBAction)addResopnseBtnClicked:(id)sender {
     self.tv= [[TestWindow alloc]initWithWindowNibName:@"TestWindow"];
    [self.tv showWindow:self.tv];
}

-(void)initData{
    NSArray * confArr = ConfigurationItems.allIteams;
    for (ConfigurationItem * item in confArr) {
        [self addHandlerWithMethod:@"GET" uri:item.uri responseDataType:item.responseType andResponseData:item.responseContent];
    }
}
-(void)addHandlerWithMethod:(NSString *)method uri:(NSString *)uri responseDataType:(NSString *)type andResponseData:(NSString *)data{
    if (!([method isEqualToString:@"GET"]||[method isEqualToString:@"POST"]))return;
    
    [server addHandlerForMethod:method path:uri requestClass:[GCDWebServerRequest class] processBlock:^GCDWebServerResponse *(GCDWebServerRequest *request) {
        if([type isEqualToString:@"TEXT"]){
            return [GCDWebServerDataResponse responseWithText:data];
        }else{
            return [GCDWebServerDataResponse responseWithHTML:data];
        }
    }];
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
                if(![self.server startWithPort:self.port bonjourName:@"XCServer"]){
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


- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    return [ConfigurationItems.allIteams count];
}
-(CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row{
    return 30;
}
-(NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
     NSTableCellView *cellView = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];
    NSArray * itemsArr = ConfigurationItems.allIteams;
    ConfigurationItem *item = [itemsArr objectAtIndex:row];
    if ([tableColumn.title isEqualToString:@"Uri"]) {
        [cellView.textField setStringValue:item.uri];
    }
    if ([tableColumn.title isEqualToString:@"ResponseType"]) {
        [cellView.textField setStringValue:item.responseType];
    }
    if ([tableColumn.title isEqualToString:@"ResponseContent"]) {
        [cellView.textField setStringValue:item.responseContent];
    }
    
    return cellView;
}
@end
