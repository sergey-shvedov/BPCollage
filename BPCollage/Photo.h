//
//  Photo.h
//  BPCollage
//
//  Created by Administrator on 09.08.14.
//  Copyright (c) 2014 Administrator. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Photo : NSObject
@property (strong,nonatomic) NSString *imageURL;
@property (strong,nonatomic) NSNumber *likes;
- (NSComparisonResult) photoCompare:(Photo *)otherPhoto;
@end
