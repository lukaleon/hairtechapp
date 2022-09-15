//
//  CAShapeLayer+Circle.h
//  hairtech
//
//  Created by Alexander Prent on 26.08.2022.
//  Copyright © 2022 Admin. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface CircleLayer : CAShapeLayer

+(CircleLayer*)addCircleToPoint:(CGPoint)point scaleFactor:(CGFloat)scaleFactor;
//-(void)circlePosition:(CGPoint)point array:(NSMutableArray*)array atIndex:(int)idx;

@end

NS_ASSUME_NONNULL_END
