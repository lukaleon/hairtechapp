//
//  CAShapeLayer+DotLayer.m
//  hairtech
//
//  Created by Alexander Prent on 20.01.2023.
//  Copyright © 2023 Admin. All rights reserved.
//

#import "DotLayer.h"

@implementation DotLayer

- (instancetype)init:(CGPoint)point {
    if (self = [super init]) {
        
    }
    return self;
}

+(DotLayer*)addDotToFrame:(CGPoint)point;
{
    DotLayer * layer = [[[self class] alloc] init];

//    UIBezierPath *dotPath=[UIBezierPath bezierPath];
//    dotPath = [UIBezierPath bezierPathWithRect:CGRectMake(point.x-30, point.y-30, 60 , 60 )];
   
    layer.bounds = CGRectMake(point.x-30, point.y-30, 60 , 60 ); 
    layer.position = point;
   //layer.fillColor = [UIColor redColor].CGColor;
    layer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"star.fill"].CGImage);
    
   
    return layer;
}




@end


