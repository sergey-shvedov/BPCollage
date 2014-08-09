//
//  CollageVC.h
//  BPCollage
//
//  Created by Administrator on 08.08.14.
//  Copyright (c) 2014 Administrator. All rights reserved.
//
//////////////////////////////////////////////////////////////////
//
//  CollageVCB from estCollectionVC
//  -> IN:  -UIImages set of dowloaded photos
//  <- OUT: -ready collage UIImage for mail delegate
//
//  - geting set of UIImages used for our collage
//  - create new SchemeRules with frames for all images using number of images and collage width
//  - create collage UIImage using SchemeRules
//  - send this image via email using MFMailComposeViewControllerDelegate
//
//////////////////////////////////////////////////////////////////

#import <UIKit/UIKit.h>

@interface CollageVC : UIViewController
@property (strong,nonatomic) NSSet *images;
@end
