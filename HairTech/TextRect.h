//
//  CAShapeLayer+textRect.h
//  hairtech
//
//  Created by Alexander Prent on 03.09.2022.
//  Copyright © 2022 Admin. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface TextRect : CAShapeLayer 
+(TextRect*)addRect:(CGRect)rect centerPoint:(CGPoint)centerPoint;

@end

NS_ASSUME_NONNULL_END
