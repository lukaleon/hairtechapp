//
//  CAShapeLayer+CirclePoint.m
//  hairtech
//
//  Created by Alexander Prent on 01.08.2022.
//  Copyright © 2022 Admin. All rights reserved.
//

#import "CAShapeLayer+CirclePoint.h"




@implementation Circle 

@dynamic  x;
@dynamic  y;


- (id)init {
    if ((self = [super init])) {
        //self.backgroundColor = [UIColor blueColor].CGColor;
        
      /*  self.fillColor =[UIColor clearColor].CGColor;
        self.opacity = 1.0;
        self.lineWidth=2;
        self.strokeColor = [UIColor lightGrayColor].CGColor;*/
        self.fillColor = [UIColor colorWithRed:4.0f/255.0f green:119.0f/255.0f blue:190.0f/255.0f alpha:1.0f].CGColor;
    }
    return self;
}


@end
