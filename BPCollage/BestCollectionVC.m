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
@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonMakeCollage;
@property (strong,nonatomic) NSMutableSet *selectedIndexes;
@property (copy,nonatomic) UIImage *emptyImage;
@property (copy,nonatomic) UIImage *selectedImage;
@property (strong,nonatomic) NSMutableSet *imagesForCollage;
@property (strong,nonatomic) NSMutableDictionary *downloadImages;
@end

@implementation BestCollectionVC
-(void)setPhotos:(NSArray *)photos
{
    _photos=photos;
    self.imagesForCollage=nil;
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
-(void) checkCountOfSelectedImages
{
    if ([self.selectedIndexes count]) {
        [self.buttonMakeCollage setEnabled:YES];
    }else [self.buttonMakeCollage setEnabled:NO];
}
- (IBAction)tapCell:(id)sender
{
    if ([sender isKindOfClass:[SelectButton class]]) {
        SelectButton *button=(SelectButton *)sender;
        
        if ([button.superview.superview isKindOfClass:[CollectionViewCell class]]) {
            CollectionViewCell *cell=(CollectionViewCell *)button.superview.superview;
            NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
            
            if ([self.selectedIndexes member:[NSNumber numberWithInteger:indexPath.row]]) {
                 [button setImage:self.emptyImage forState:UIControlStateNormal];
                [self.selectedIndexes removeObject:[NSNumber numberWithInteger:indexPath.row]];
            }else{
                [button setImage:self.selectedImage forState:UIControlStateNormal];
                [self.selectedIndexes addObject:[NSNumber numberWithInteger:indexPath.row]];
            }
            NSLog(@"%@",self.selectedIndexes);
            [self checkCountOfSelectedImages];
        }

    }
}

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


    
    
        
        if ([self.downloadImages objectForKey:[NSNumber numberWithInteger:indexPath.row]]) {
            [cell.button setBackgroundImage:[self.downloadImages objectForKey:[NSNumber numberWithInteger:indexPath.row]] forState:UIControlStateNormal];
        }else{
            [cell.button setBackgroundImage:nil forState:UIControlStateNormal];
            [self downloadImageInCell:cell withIndexPath:indexPath];
        }
   
    
    
    if ([self.selectedIndexes member:[NSNumber numberWithInteger:indexPath.row]]) {
        [cell.button setImage:self.selectedImage forState:UIControlStateNormal];
    }else{
        [cell.button setImage:self.emptyImage forState:UIControlStateNormal];
    }
    Photo* photo=(Photo *)[self.photos objectAtIndex:indexPath.row];
    cell.label.text=[NSString stringWithFormat:@"%@", photo.likes];

    
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"PrepareForCollage"]) {
        if ([segue.destinationViewController isKindOfClass:[CollageVC class]]) {
            CollageVC *collageVC=(CollageVC *)segue.destinationViewController;
            collageVC.images=self.imagesForCollage;
        }
    }
}


-(void) downloadImageInCell:(UICollectionViewCell*) cell  withIndexPath:(NSIndexPath *)indexPath
{
    Photo* photo=(Photo *)[self.photos objectAtIndex:indexPath.row];
    if(photo.imageURL){
    
        
    
    NSURLRequest *request=[[NSURLRequest alloc] initWithURL:[[NSURL alloc]initWithString:photo.imageURL]];
    //NSLog(@"%@",photo.imageURL);
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




/*
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSArray *visibleCells = [self.collectionView visibleCells];
    [visibleCells enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CollectionViewCell *cell = (CollectionViewCell *)obj;
        
        NSNumber *index=[NSNumber numberWithInteger: [self.collectionView indexPathForCell:cell].row];
        if ([self.downloadImages objectForKey:index]) {
            [cell.button setBackgroundImage:[self.downloadImages objectForKey:[NSNumber numberWithInteger: [self.collectionView indexPathForCell:cell].row]] forState:UIControlStateNormal];
        }else{
            [self downloadImageInCell:cell withIndexPath:[self.collectionView indexPathForCell:cell]];
        }
        
    }];
}
 */

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
