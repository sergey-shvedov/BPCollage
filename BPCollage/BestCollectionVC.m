//
//  BestCollectionVC.m
//  BPCollage
//
//  Created by Administrator on 08.08.14.
//  Copyright (c) 2014 Administrator. All rights reserved.
//

#import "BestCollectionVC.h"
#import "CollectionViewCell.h"
#import "SelectButton.h"
#import "CollageVC.h"
#import "Photo.h"

@interface BestCollectionVC ()

///////////////////////////////////////////
///////////////////////////////////////////

@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonMakeCollage;

@property (strong,nonatomic) NSMutableSet *selectedIndexes;       //indexes of user's selected photos in cells
@property (copy,nonatomic) UIImage *emptyImage;                   //alphaTopImage for indicate UNSELECTED state for photo in cell
@property (copy,nonatomic) UIImage *selectedImage;                //alphaTopImage with blue "check" icon for indicate SELECTED state for photo in cell
@property (strong,nonatomic) NSMutableSet *imagesForCollage;      //UIImages for next VC
@property (strong,nonatomic) NSMutableDictionary *downloadImages; //All downloaded images with keys depend on indexes of income array
@end

///////////////////////////////////////////
///////////////////////////////////////////

@implementation BestCollectionVC

///////////////////////////////////////////
#pragma mark - Getters AND Setters
///////////////////////////////////////////

-(void)setPhotos:(NSArray *)photos
{
    _photos=photos;
    self.imagesForCollage=nil;       //clear old data when come new array of Photo* objects
    self.downloadImages=nil;
    [self.collectionView reloadData];
}

-(NSMutableDictionary *)downloadImages
{
    if(!_downloadImages){
        _downloadImages=[[NSMutableDictionary alloc]init];
    }
    return _downloadImages;
}

-(UIImage *)emptyImage{
    if (!_emptyImage) {
        _emptyImage=[UIImage imageNamed:@"emptyImage100"];
    }
    return _emptyImage;
}

-(UIImage *)selectedImage{
    if (!_selectedImage) {
        _selectedImage=[UIImage imageNamed:@"selectedImage100"];
    }
    return _selectedImage;
}

-(NSMutableSet *)selectedIndexes
{
    if (!_selectedIndexes){
        _selectedIndexes=[[NSMutableSet alloc]init];
    }
    return _selectedIndexes;
}

////////////////////////////////////////////////////////////////// Get all collage images in set
-(NSMutableSet *)imagesForCollage
{
    NSMutableSet *set=[[NSMutableSet alloc]init];
    for (NSNumber *index in self.selectedIndexes)
    {
        if ([[self.downloadImages objectForKey:index]isKindOfClass:[UIImage class]]) {
            UIImage *image=(UIImage *)[self.downloadImages objectForKey:index];
            [set addObject:image];
        }
    }
        _imagesForCollage=set;
    return _imagesForCollage;
}


///////////////////////////////////////////
#pragma mark - IBAction
///////////////////////////////////////////

- (IBAction)tapCell:(id)sender
{
    if ([sender isKindOfClass:[SelectButton class]]) {
        SelectButton *button=(SelectButton *)sender;
        
        if ([button.superview.superview isKindOfClass:[CollectionViewCell class]]) {           // get access to cell
            CollectionViewCell *cell=(CollectionViewCell *)button.superview.superview;
            NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
            
            if ([self.selectedIndexes member:[NSNumber numberWithInteger:indexPath.row]]) {
                 [button setImage:self.emptyImage forState:UIControlStateNormal];                // UNSELECT image out of the collection
                [self.selectedIndexes removeObject:[NSNumber numberWithInteger:indexPath.row]];  // remove index of this image from array (selectedIndexes)
            }else{                                                                               // SELECT image in the collection
                [button setImage:self.selectedImage forState:UIControlStateNormal];              // add index of this image from array (selectedIndexes)
                [self.selectedIndexes addObject:[NSNumber numberWithInteger:indexPath.row]];
            }
            [self checkCountOfSelectedImages];                                                   // check enable status of button for create collage
        }
    }
}

////////////////////////////////////////////////////////////////// Check enable status of button for create collage
-(void) checkCountOfSelectedImages
{
    if ([self.selectedIndexes count]) {
        [self.buttonMakeCollage setEnabled:YES];
    }else [self.buttonMakeCollage setEnabled:NO];
}


///////////////////////////////////////////
#pragma mark - UICollectionView methods
///////////////////////////////////////////

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.photos count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier=@"CollectionCell";
    
    CollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
        
        if ([self.downloadImages objectForKey:[NSNumber numberWithInteger:indexPath.row]]) {         //IF image for cell already downloaded then take them fom dictionary
            [cell.button setBackgroundImage:[self.downloadImages objectForKey:[NSNumber numberWithInteger:indexPath.row]] forState:UIControlStateNormal];
        }else{
            [cell.button setBackgroundImage:nil forState:UIControlStateNormal];
            [self downloadImageInCell:cell withIndexPath:indexPath];                                 //ELSE start downloading
        }
   
    if ([self.selectedIndexes member:[NSNumber numberWithInteger:indexPath.row]]) {                  //Set top image for indicate selected status
        [cell.button setImage:self.selectedImage forState:UIControlStateNormal];
    }else{
        [cell.button setImage:self.emptyImage forState:UIControlStateNormal];
    }
    
    Photo* photo=(Photo *)[self.photos objectAtIndex:indexPath.row];
    cell.label.text=[NSString stringWithFormat:@"%@", photo.likes];                                  //print number of "like" in cell label

    return cell;
}

///////////////////////////////////////////
#pragma mark - PrepareForSegue
///////////////////////////////////////////

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"PrepareForCollage"]) {
        if ([segue.destinationViewController isKindOfClass:[CollageVC class]]) {
            CollageVC *collageVC=(CollageVC *)segue.destinationViewController;
            collageVC.images=self.imagesForCollage;                                                  //send set of images to next VC
        }
    }
}


///////////////////////////////////////////
#pragma mark - Downloading
///////////////////////////////////////////

-(void) downloadImageInCell:(UICollectionViewCell*) cell  withIndexPath:(NSIndexPath *)indexPath
{
    Photo* photo=(Photo *)[self.photos objectAtIndex:indexPath.row];
    if(photo.imageURL){
    
    NSURLRequest *request=[[NSURLRequest alloc] initWithURL:[[NSURL alloc]initWithString:photo.imageURL]];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request
                                                    completionHandler:^(NSURL *localFile, NSURLResponse *response, NSError *error) {
                                                        
                                                        if (!error){
                                                            if ([request.URL isEqual: [[NSURL alloc]initWithString:photo.imageURL]]){
                                                                UIImage *image=[UIImage imageWithData:[NSData dataWithContentsOfURL:localFile]];
                                                                if (image) {
                                                                    
                                                                
                                                                [self.downloadImages setObject:image forKey:[NSNumber numberWithInteger:indexPath.row]];
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    //set downloaded image in cell
                                                                    [((CollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath]).button setBackgroundImage:image forState:UIControlStateNormal];
                                                                    [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
                                                                });
                                                                }
                                                            }
                                                        }
                                                    }];
    [task resume];
    }
}


///////////////////////////////////////////
#pragma mark - View Methods
///////////////////////////////////////////

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

///////////////////////////////////////////
///////////////////////////////////////////
@end
///////////////////////////////////////////
///////////////////////////////////////////
