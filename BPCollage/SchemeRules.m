//
//  SchemeRules.m
//  BPCollage
//
//  Created by Administrator on 09.08.14.
//  Copyright (c) 2014 Administrator. All rights reserved.
//

#import "SchemeRules.h"

@implementation SchemeRules

///////////////////////////////////////////
#pragma mark - initialization
///////////////////////////////////////////

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

///////////////////////////////////////////
#pragma mark - Creation frames using rules
///////////////////////////////////////////

-(void) createArrayWithCountOfImages:(NSInteger)count andForWidth:(CGFloat)width
{
    self.imageFrames=[[NSMutableArray alloc]init];
    
    NSMutableArray *newArray=[[NSMutableArray alloc]init]; //temp array for filling
    
    if (count) {
        
        ///////////////////////////////////////////
        //
        // Model of collage based on blocks with MAX 6 photos
        // If there are more then one block (more then 6 photos) we need several cycles
        // block with 1..6 photos implements via switch
        // Each swith represent a schema of photo's places in block and depends on method argument "width"(of collage image)
        //
        ///////////////////////////////////////////
        
        int lastPart = (count>6) ? count%6 : (int)count; //last block photo counter
        float hSize = 0;                                 //factor for collage height (depends of number of blocks)
        int maxSteps=((int)count)/6;                     //steps (cycles) for blocks
        if (count/6>0 && 0==count%6) {                   //customize state of 6 photos in block (--steps)
            maxSteps--;
        }
        
        for (int steps=0; steps<=maxSteps; steps++) {    //cycle for blocks
            
            NSInteger toAdd = lastPart;                  //define number of photos in block
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
            }//end switch
        }//end for
        
        self.imageFrames=newArray; //set photos frames for new collage
        self.collageFrame=[NSValue valueWithCGRect:CGRectMake( 0.0 , 0.0, width , hSize*width )]; //set frame for new collage
        
    }//end if(count)
    
}

@end
