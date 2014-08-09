//
//  NicknameVC.h
//  BPCollage
//
//  Created by Administrator on 08.08.14.
//  Copyright (c) 2014 Administrator. All rights reserved.
//
//////////////////////////////////////////////////////////////////
//
//  RootVC: NicknameVC
//  -> IN:
//  <- OUT: -sorted array of Photo* objects (with URL and "like" count) to next BestCollectionVC via PUSH SEGUE
//
//  - geting user request for search "nickname" in Instagram
//  - sendind internet request for search "nickname" and get userID
//  - sending internet request for search photos by userID
//  - parsing data and get photos URLs and number of "like"
//  - creating array of Photo*, sorting, limiting
//  - sending array to next VC
//
//////////////////////////////////////////////////////////////////

#import <UIKit/UIKit.h>
#import "Const.h"

@interface NicknameVC : UIViewController

@end
