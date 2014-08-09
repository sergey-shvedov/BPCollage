//
//  SchemeRules.h
//  BPCollage
//
//  Created by Administrator on 09.08.14.
//  Copyright (c) 2014 Administrator. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SchemeRules : NSObject
@property (strong,nonatomic) NSArray *imageFrames;
@property (strong,nonatomic) NSValue *collageFrame;
-(id)init;
-(SchemeRules *) initWithCountOfImages:(NSInteger) count andForWidth: (CGFloat) width;

@end
