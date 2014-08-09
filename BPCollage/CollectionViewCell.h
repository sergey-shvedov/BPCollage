//
//  CollectionViewCell.h
//  BPCollage
//
//  Created by Administrator on 08.08.14.
//  Copyright (c) 2014 Administrator. All rights reserved.
//
//////////////////////////////////////////////////////////////////
//
//  Custom reusable cell for BestCollectionVC
//  Used via Storyboard
//
//////////////////////////////////////////////////////////////////

#import <UIKit/UIKit.h>
#import "SelectButton.h"

@interface CollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet SelectButton *button;       //button contains photo in "backgroundimage" and alphaSelectIndicator in "image"
@property (weak, nonatomic) IBOutlet UILabel *label;             //label for represent photo "likes" in cell

@end
