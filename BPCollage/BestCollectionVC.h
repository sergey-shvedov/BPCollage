//
//  BestCollectionVC.h
//  BPCollage
//
//  Created by Administrator on 08.08.14.
//  Copyright (c) 2014 Administrator. All rights reserved.
//
//////////////////////////////////////////////////////////////////
//
//  BestCollectionVC from NicknameVC
//  -> IN:  -sorted array of Photo* objects (with URL and "like" count)
//  <- OUT: -set of UIImages of dowloaded photos to next CollageVC via PUSH SEGUE
//
//  - geting array of Photo* objects and handling it with UICollectionView methods
//  - sendind internet request for downloading images of photo for cells
//  - parsing data and get set images in cells
//  - storing user choices in set of selected indexes (selectedIndexes)
//  - create set of selected photos (imagesForCollage) using (selectedIndexes) and downloadedImages and send it to the next VC
//
//////////////////////////////////////////////////////////////////

#import <UIKit/UIKit.h>
#import "Const.h"

@interface BestCollectionVC : UICollectionViewController
@property (strong,nonatomic) NSArray *photos;
@end
