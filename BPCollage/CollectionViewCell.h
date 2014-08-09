//
//  CollectionViewCell.h
//  BPCollage
//
//  Created by Administrator on 08.08.14.
//  Copyright (c) 2014 Administrator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectButton.h"

@interface CollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet SelectButton *button;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end
