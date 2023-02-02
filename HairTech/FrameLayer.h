//
//  CAShapeLayer+FrameLayer.h
//  hairtech
//
//  Created by Alexander Prent on 19.01.2023.
//  Copyright © 2023 Admin. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface FrameLayer : CAShapeLayer

+(FrameLayer*)addFrameToPoint:(CGPoint)point endPoint:(CGPoint)endPoint scaleFactor:(CGFloat)scaleFactor;

+(FrameLayer*)addFrameToText:(CGPoint)point size:(CGRect)frame scaleFactor:(CGFloat)scaleFactor;

+ (CGFloat)distanceBetweenStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;

@end

NS_ASSUME_NONNULL_END
