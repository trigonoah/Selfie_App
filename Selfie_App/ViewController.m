//
//  ViewController.m
//  Selfie_App
//
//  Created by Mac on 7/16/15.
//  Copyright (c) 2015 SamFan Creations. All rights reserved.
//

#import "ViewController.h"


@interface ViewController () 

@property (strong, nonatomic) WebServiceHandler *wsh;
@property (strong, nonatomic) JSONParser *jsonParser;
@property (strong, nonatomic) NSString *nextURL;
@property (strong, nonatomic) NSMutableArray *arrSelfiesCleaned;
@property (strong, nonatomic) dispatch_queue_t myQueue;

@end

static NSString const *selfieURL = @"https://api.instagram.com/v1/tags/selfie/media/recent?client_id=d2531b2128ab42ecb91c1f9e6f2ff341";

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //Create and configure objects
    self.wsh = [[WebServiceHandler alloc] init];
    self.wsh.delegate = self;
    
    self.jsonParser = [[JSONParser alloc] init];
    self.jsonParser.delegate = self;
    
    self.myQueue = dispatch_queue_create("myQueue", nil);
    
    self.arrSelfiesCleaned = [[NSMutableArray alloc] init];
    
    //Start the webservice
    [self.wsh startServiceWithURL:[NSURL URLWithString:selfieURL]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - WebService Handler delegate methods
-(void)webServiceCallFinished:(NSDictionary *)jsonRawDict
{
    //Start the JSON parser with the raw JSON data
    [self.jsonParser parseRawDict:jsonRawDict];
}

-(void)webServiceCallFinishedWithError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR" message:@"There was an error with the webservice call" delegate:self cancelButtonTitle:@"Return" otherButtonTitles:nil];
    [alert show];
}

#pragma mark - JSON Parser delegate methods
-(void)parsingCompleted:(NSMutableArray *)arrSelfies
{
    NSLog(@"Time to do something with the array of selfies");
    
    //Remove the next url string for later use
    self.nextURL = [[arrSelfies lastObject] copy];
    [arrSelfies removeLastObject];
    
    //Copy the selfie array to the parent's variable
    [self.arrSelfiesCleaned addObjectsFromArray:arrSelfies];
    
    //Reload the data in the collection view
    [self.collView reloadData];
}

#pragma mark - Collection View delegate and datasource methods
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.arrSelfiesCleaned count];
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //Set the image to be large if it is the third of the collection
    if (indexPath.row % 3 == 0)
    {
        return CGSizeMake(320, 320);
    }
    //Otherwise make it small
    else
    {
        return CGSizeMake(150, 150);
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    //Get the selfie object corresponding to the indexpath from th collection
    Selfie *aSelfie = [_arrSelfiesCleaned objectAtIndex:indexPath.row];
    
    //Configure the cell
    cell.alpha = 0.0;
    
    //If the selfie object's image has already been downloaded, display it immediately.
    if (aSelfie.image)
    {
        cell.backgroundView = [[UIImageView alloc] initWithImage:aSelfie.image];
        //Animate the cell's appearance
        [UIView animateWithDuration:0.5 animations:^{
            cell.alpha = 1.0;
        }];
    }
    else
    {
        //Run a background thread to download the image
        dispatch_async(_myQueue, ^{
            aSelfie.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:aSelfie.low_resolutionURL]]];
            //Update the cell on the main thread
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.backgroundView = [[UIImageView alloc] initWithImage:aSelfie.image];
            });
        });
        
        //Animate the cell's appearance
        [UIView animateWithDuration:0.5 animations:^{
            cell.alpha = 1.0;
        }];
    }
    
    //Enable infinite scrolling
    if (indexPath.item == [_arrSelfiesCleaned count] -1)
    {
        NSLog(@"We've reached the bottom. Load the next page of data");
        [self.wsh startServiceWithURL:[NSURL URLWithString:self.nextURL]];
    }
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //Dismiss the keyboard
    [self.txtTagSearch resignFirstResponder];
}

#pragma mark - Text field delegate methods
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //Dismiss the keyboard
    [textField resignFirstResponder];
    
    if (textField.text.length > 0)
    {
        //Search for the entered tag
        NSString *tagSearch = [NSString stringWithFormat:@"https://api.instagram.com/v1/tags/%@/media/recent?client_id=d2531b2128ab42ecb91c1f9e6f2ff341", textField.text];
        
        //Clear the collection of current objects
        [self.arrSelfiesCleaned removeAllObjects];
        
        //Restart the web service
        [self.wsh startServiceWithURL:[NSURL URLWithString:tagSearch]];
        
    }
    
    return YES;
}

-(BOOL)prefersStatusBarHidden {
    return YES;
}

@end
