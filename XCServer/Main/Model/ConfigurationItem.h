//
//  ConfigurationItem.h
//  XCServer
//
//  Created by shaimi on 15/7/13.
//  Copyright (c) 2015年 XingCheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConfigurationItem : NSObject
@property (nonatomic,assign) NSInteger ID;
@property (nonatomic,copy  ) NSString  *uri;
@property (nonatomic,copy  ) NSString  *responseType;
@property (nonatomic,copy  ) NSString  *responseContent;
@property (nonatomic,assign) NSInteger optDate;
@end
