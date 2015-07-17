//
//  JSONParser.m
//  Selfie_App
//
//  Created by Mac on 7/16/15.
//  Copyright (c) 2015 SamFan Creations. All rights reserved.
//

#import "JSONParser.h"
#import "Selfie.h"

@implementation JSONParser

-(void)parseRawDict:(NSDictionary *)jsonRawDict
{
    //Parse the data
    NSArray *arrJSONData = [jsonRawDict objectForKey:@"data"];
    
    //Create an array to store each individual selfie object
    NSMutableArray *arrSelfies = [[NSMutableArray alloc] init];

    for (NSDictionary *aSelfieDict in arrJSONData) {
        //Create and configure the selfie object
        Selfie *aSelfie = [[Selfie alloc] initWithDictionary:aSelfieDict];
        
        //Add the selfie object to the array
        [arrSelfies addObject:aSelfie];
    }
    
    //Add the next url from the pagination schema as the 21st element of the array
    [arrSelfies addObject:[[jsonRawDict objectForKey:@"pagination"] objectForKey:@"next_url"]];
    
    //Let the parent know parsing is completed
    [self.delegate parsingCompleted:arrSelfies];
}

@end
