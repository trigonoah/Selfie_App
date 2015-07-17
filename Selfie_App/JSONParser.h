//
//  JSONParser.h
//  Selfie_App
//
//  Created by Mac on 7/16/15.
//  Copyright (c) 2015 SamFan Creations. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JSONParserDelegate <NSObject>

-(void)parsingCompleted:(NSMutableArray *) arrSelfies;

@end

@interface JSONParser : NSObject

@property (weak, nonatomic) id <JSONParserDelegate> delegate;

-(void)parseRawDict:(NSDictionary *) jsonRawDict;

@end
