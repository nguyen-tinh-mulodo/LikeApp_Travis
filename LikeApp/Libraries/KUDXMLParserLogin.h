//
//  KUDXMLParserLogin.h
//  LikeApp
//
//  Created by Nguyen Huu Tinh on 6/11/13.
//  Copyright (c) 2013 Mulodo Viet Nam. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "KUDError.h"
@interface KUDXMLParserLogin : NSObject<NSXMLParserDelegate>{
    KUDError *error;
    NSMutableString *currentElementValue;
    NSXMLParser *xmlParser;
    NSMutableArray *dataError;
}
- (NSMutableArray *)parserDataPhoto:(NSMutableData *)data;
@end
