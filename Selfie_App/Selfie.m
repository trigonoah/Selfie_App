//
//  Selfie.m
//  Selfie_App
//
//  Created by Mac on 7/16/15.
//  Copyright (c) 2015 SamFan Creations. All rights reserved.
//

#import "Selfie.h"

@implementation Selfie

-(id)initWithDictionary:(NSDictionary *)aSelfieDict
{
    self = [super init];
    
    if (self)
    {
        //Configure the selfie object from the dictionary
        self.low_resolutionURL = [[[aSelfieDict objectForKey:@"images" ] objectForKey:@"low_resolution"] objectForKey:@"url"];
        self.standard_resolutionURL = [[[aSelfieDict objectForKey:@"images"] objectForKey:@"standard_resolution"] objectForKey:@"url"];
        self.thumbnailURL = [[[aSelfieDict objectForKey:@"images"] objectForKey:@"thumbnail"] objectForKey:@"url"];
    }
    
    return self;
}

@end
