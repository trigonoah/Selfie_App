//
//  ViewController.h
//  Selfie_App
//
//  Created by Mac on 7/16/15.
//  Copyright (c) 2015 SamFan Creations. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebServiceHandler.h"
#import "JSONParser.h"
#import "Selfie.h"

@interface ViewController : UIViewController <WebServiceHandlerDelegate, JSONParserDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UICollectionView *collView;
@property (strong, nonatomic) IBOutlet UITextField *txtTagSearch;

@end

