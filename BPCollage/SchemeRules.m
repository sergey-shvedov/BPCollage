//
//  SchemeRules.m
//  BPCollage
//
//  Created by Administrator on 09.08.14.
//  Copyright (c) 2014 Administrator. All rights reserved.
//

#import "SchemeRules.h"

@implementation SchemeRules
-(id)init
{
    return [self initWithCountOfImages:0 andForWidth:0.0];
}
-(id)initWithCountOfImages:(NSInteger)count andForWidth:(CGFloat)width
{
    self = [super init];
    if (self){
        [self createArrayWithCountOfImages:count andForWidth:width] ;
    }
    return self;
}
-(void) createArrayWithCountOfImages:(NSInteger)count andForWidth:(CGFloat)width
{
    self.imageFrames=[[NSMutableArray alloc]init];
    
    NSMutableArray *newArray=[[NSMutableArray alloc]init];
    
    if (count) {
        
        
        int lastPart = (count>6) ? count%6 : count;
        float hSize = 0;
        int maxSteps=count/6;
        if (count/6>0 && 0==count%6) {
            maxSteps--;
        }
        for (int steps=0; steps<=maxSteps; steps++) {
            NSInteger toAdd = lastPart;
            if (steps<maxSteps || 0==lastPart) {
                toAdd = 6;
            }
            
            switch (toAdd) {
                case 1:
                    [newArray addObject:[NSValue valueWithCGRect:CGRectMake( 0.0*width , (0.0+steps)*width, 1.0*width , 1.0*width )]];
                    hSize+=1.0;
                    break;
                case 2:
                    [newArray addObject:[NSValue valueWithCGRect:CGRectMake( 0.0*width , (0.0+steps)*width, 0.6*width , 1.0*width )]];
                    [newArray addObject:[NSValue valueWithCGRect:CGRectMake( 0.6*width , (0.0+steps)*width, 0.4*width , 1.0*width )]];
                    hSize+=1.0;
                    break;
                case 3:
                    [newArray addObject:[NSValue valueWithCGRect:CGRectMake( 0.0*width , (0.0+steps)*width, 1.0*width , 1.0*width )]];
                    [newArray addObject:[NSValue valueWithCGRect:CGRectMake( 0.0*width , (1.0+steps)*width, 0.5*width , 0.5*width )]];
                    [newArray addObject:[NSValue valueWithCGRect:CGRectMake( 0.5*width , (1.0+steps)*width, 0.5*width , 0.5*width )]];
                    hSize+=1.5;
                    break;
                case 4:
                    [newArray addObject:[NSValue valueWithCGRect:CGRectMake( 0.0*width , (0.0+steps)*width, 0.5*width , 0.5*width )]];
                    [newArray addObject:[NSValue valueWithCGRect:CGRectMake( 0.5*width , (0.0+steps)*width, 0.5*width , 0.5*width )]];
                    [newArray addObject:[NSValue valueWithCGRect:CGRectMake( 0.0*width , (0.5+steps)*width, 0.5*width , 0.5*width )]];
                    [newArray addObject:[NSValue valueWithCGRect:CGRectMake( 0.5*width , (0.5+steps)*width, 0.5*width , 0.5*width )]];
                    hSize+=1.0;
                    break;
                case 5:
                    [newArray addObject:[NSValue valueWithCGRect:CGRectMake( 0.0*width , (0.0+steps)*width, 0.5*width , 0.5*width )]];
                    [newArray addObject:[NSValue valueWithCGRect:CGRectMake( 0.5*width , (0.0+steps)*width, 0.5*width , 0.5*width )]];
                    [newArray addObject:[NSValue valueWithCGRect:CGRectMake( 0.0*width , (0.5+steps)*width, 0.33*width , 0.33*width )]];
                    [newArray addObject:[NSValue valueWithCGRect:CGRectMake( 0.33*width , (0.5+steps)*width, 0.33*width , 0.33*width )]];
                    [newArray addObject:[NSValue valueWithCGRect:CGRectMake( 0.66*width , (0.5+steps)*width, 0.34*width , 0.33*width )]];
                    hSize+=0.83;
                    break;
                case 6:
                    [newArray addObject:[NSValue valueWithCGRect:CGRectMake( 0.0*width , (0.0+steps)*width, 0.66*width , 0.66*width )]];
                    [newArray addObject:[NSValue valueWithCGRect:CGRectMake( 0.66*width , (0.0+steps)*width, 0.34*width , 0.33*width )]];
                    [newArray addObject:[NSValue valueWithCGRect:CGRectMake( 0.66*width , (0.33+steps)*width, 0.34*width , 0.33*width )]];
                    [newArray addObject:[NSValue valueWithCGRect:CGRectMake( 0.0*width , (0.66+steps)*width, 0.33*width , 0.34*width )]];
                    [newArray addObject:[NSValue valueWithCGRect:CGRectMake( 0.33*width , (0.66+steps)*width, 0.33*width , 0.34*width )]];
                    [newArray addObject:[NSValue valueWithCGRect:CGRectMake( 0.66*width , (0.66+steps)*width, 0.34*width , 0.34*width )]];
                    hSize+=1.0;
                    break;
                case 0:
                default:
                    break;
            }
        }//end for
        self.imageFrames=newArray;
        NSLog(@"%@",newArray);
        self.collageFrame=[NSValue valueWithCGRect:CGRectMake( 0.0 , 0.0, width , hSize*width )];
    }
    
    
}

@end
