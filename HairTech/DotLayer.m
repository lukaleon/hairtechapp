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

+(DotLayer*)addDotToFrame:(CGPoint)point scale:(CGFloat)scaleFactor
{
    DotLayer * layer = [[[self class] alloc] init];

//    UIBezierPath *dotPath=[UIBezierPath bezierPath];
//    dotPath = [UIBezierPath bezierPathWithRect:CGRectMake(point.x-30, point.y-30, 60 , 60 )];
   
    layer.bounds = CGRectMake(point.x-30, point.y-30, 60 , 60 ); 
    layer.position = point;
   //layer.fillColor = [UIColor redColor].CGColor;
    UIImage * img = [UIImage imageNamed:@"dotitem"];
    UIImage * newImg = [layer imageWithImage:img scaledToSize:layer.bounds.size scale:scaleFactor];

    layer.contents = (__bridge id _Nullable)(newImg.CGImage);
    return layer;
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize scale:(CGFloat)scale {
    
    CGSize scaledSize = CGSizeMake(newSize.width * scale, newSize.height * scale);
    NSLog(@"zooming scale");
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(scaledSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, scaledSize.width, scaledSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end


