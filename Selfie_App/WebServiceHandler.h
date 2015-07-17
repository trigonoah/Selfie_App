//
//  WebServiceHandler.h
//  Selfie_App
//
//  Created by Mac on 7/16/15.
//  Copyright (c) 2015 SamFan Creations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol WebServiceHandlerDelegate <NSURLSessionDataDelegate, NSURLSessionDelegate>

-(void)webServiceCallFinished:(NSDictionary *) jsonRawDict;
-(void)webServiceCallFinishedWithError:(NSError *) error;

@end

@interface WebServiceHandler : NSObject

@property (weak, nonatomic) id <WebServiceHandlerDelegate> delegate;

-(void)startServiceWithURL:(NSURL *) URL;

@end
