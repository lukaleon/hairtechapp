//
//  CAShapeLayer+Line.h
//  hairtech
//
//  Created by Alexander Prent on 02.08.2022.
//  Copyright © 2022 Admin. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface Line : CAShapeLayer{
    CGPathRef linePath;
    NSMutableArray * arrayOfCircles;
}
@property (assign) CGPoint startPoint;
@property (assign) CGPoint endPoint;

-(void)drawCirclesX:(CGFloat)x circleY:(CGFloat)y currentLayer:(CAShapeLayer*)firstLayer ;
-(void)removeCircles;
-(BOOL)pointInside:(CGPoint)point path:(CGPathRef)newPath;

@property (assign) CGPathRef pathOfLine;

@end

NS_ASSUME_NONNULL_END
