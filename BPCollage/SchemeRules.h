//
//  SchemeRules.h
//  BPCollage
//
//  Created by Administrator on 09.08.14.
//  Copyright (c) 2014 Administrator. All rights reserved.
//
//////////////////////////////////////////////////////////////////
//
//  SchemeRules class: Store frames(CGRect) for new collage via NSObject
//  It makes sense to create object only via initWithCountOfImages method
//
//////////////////////////////////////////////////////////////////

#import <Foundation/Foundation.h>

@interface SchemeRules : NSObject
@property (strong,nonatomic) NSArray *imageFrames;    //frames for all photos used in new collage
@property (strong,nonatomic) NSValue *collageFrame;   //frame of new collage

-(id)init;
-(SchemeRules *) initWithCountOfImages:(NSInteger) count andForWidth: (CGFloat) width;

@end
