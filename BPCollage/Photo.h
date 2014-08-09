//
//  Photo.h
//  BPCollage
//
//  Created by Administrator on 09.08.14.
//  Copyright (c) 2014 Administrator. All rights reserved.
//
//////////////////////////////////////////////////////////////////
//
//  Photo class: Describe photo information via NSObject
//  -storing URL of the photo and number of its "likes"
//  -can compare two photos via "likes"
//
//////////////////////////////////////////////////////////////////

#import <Foundation/Foundation.h>

@interface Photo : NSObject
@property (strong,nonatomic) NSString *imageURL;
@property (strong,nonatomic) NSNumber *likes;

- (NSComparisonResult) photoCompare:(Photo *)otherPhoto;
@end
