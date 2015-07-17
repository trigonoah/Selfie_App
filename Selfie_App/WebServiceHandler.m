//
//  WebServiceHandler.m
//  Selfie_App
//
//  Created by Mac on 7/16/15.
//  Copyright (c) 2015 SamFan Creations. All rights reserved.
//

#import "WebServiceHandler.h"
#import "JSONParser.h"

@implementation WebServiceHandler

-(void)startServiceWithURL:(NSURL *) URL
{
//    dispatch_queue_t myQueue = dispatch_queue_create("myQueue", nil);
    
    NSURLSession *mySession = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *myTask = [mySession dataTaskWithURL:URL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
    {
        //Get the http response code
        NSHTTPURLResponse * httpResponse = (NSHTTPURLResponse*)response;
        int responseStatusCode = (int) [httpResponse statusCode];
        
        if (error)
        {
            //Do something to signify error
            NSLog(@"There was an error with the url session data task. Description: %@", [error localizedDescription]);
            [self.delegate webServiceCallFinishedWithError:error];
        }
        else if (responseStatusCode == 200)
        {
           //Execute on the main queue
            dispatch_async(dispatch_get_main_queue(), ^{
                NSDictionary *jsonRawDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                NSLog(@"We have the json data");
                //Pass the data to the parent for parsing
                [self.delegate webServiceCallFinished:jsonRawDict];
            });
        }
        else
        {
            NSLog(@"There was an error in the response code");
            dispatch_async(dispatch_get_main_queue(), ^{
                //Execute on the main queue
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR" message:@"That tag search is not allowed" delegate:self cancelButtonTitle:@"Return" otherButtonTitles:nil];
                [alert show];
            });
           
        }
    }];
    
    [myTask resume];
}

@end
