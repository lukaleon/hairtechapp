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

+(FrameLayer*)addCircleToPoint:(CGPoint)point scaleFactor:(CGFloat)scaleFactor;

@end

NS_ASSUME_NONNULL_END
