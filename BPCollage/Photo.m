//
//  Photo.m
//  BPCollage
//
//  Created by Administrator on 09.08.14.
//  Copyright (c) 2014 Administrator. All rights reserved.
//

#import "Photo.h"

@implementation Photo
-(NSComparisonResult)photoCompare:(Photo *)otherPhoto
{
    return [otherPhoto.likes compare:self.likes];
}
@end
