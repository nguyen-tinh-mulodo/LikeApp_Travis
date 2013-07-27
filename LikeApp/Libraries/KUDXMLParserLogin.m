//
//  KUDXMLParserLogin.m
//  LikeApp
//
//  Created by Nguyen Huu Tinh on 6/11/13.
//  Copyright (c) 2013 Mulodo Viet Nam. All rights reserved.
//

#import "KUDXMLParserLogin.h"

@implementation KUDXMLParserLogin
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName
	attributes:(NSDictionary *)attributeDict {
	
	if([elementName isEqualToString:@"response"]) {
        dataError  =  [[NSMutableArray alloc] init];
	}
	else if([elementName isEqualToString:@"error"]){
		error = [[KUDError alloc] init];
	}
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	if(!currentElementValue)
		currentElementValue = [[NSMutableString alloc] initWithString:string];
	else
		[currentElementValue appendString:string];
}
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if([elementName isEqualToString:@"response"])
		return;
	if([elementName isEqualToString:@"error"]) {
		[dataError addObject:error];
    }
	else {
        if([elementName isEqualToString:@"statusCode"]||[elementName isEqualToString:@"message"]||[elementName isEqualToString:@"token"]){
            [error setValue:currentElementValue forKey:elementName];
        }
	}
	currentElementValue = nil;
}
- (NSMutableArray *)parserDataPhoto:(NSMutableData *)data{
    NSString *response = [[NSString alloc]
                          initWithBytes: [data mutableBytes]
                          length:[data length]
                          encoding:NSUTF8StringEncoding];
    NSLog(@"Du lieu tra ve:%@", response);
    xmlParser = [[NSXMLParser alloc] initWithData: data];
    [xmlParser setDelegate:self];
    BOOL success =[xmlParser parse];
    if (success) {
        NSLog(@"count photo:%d",[dataError count]);
        for (error in dataError) {
            NSLog(@"error:%@",error.statusCode);
        }
        
    }
    return dataError;
    
}

@end
