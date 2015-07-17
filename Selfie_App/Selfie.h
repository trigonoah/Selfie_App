//
//  Selfie.h
//  Selfie_App
//
//  Created by Mac on 7/16/15.
//  Copyright (c) 2015 SamFan Creations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Selfie : NSObject

@property (strong, nonatomic) NSString * low_resolutionURL;
@property (strong, nonatomic) NSString * standard_resolutionURL;
@property (strong, nonatomic) NSString * thumbnailURL;
@property (strong, nonatomic) UIImage * image;

-(id)initWithDictionary:(NSDictionary *)aSelfieDict;

@end
