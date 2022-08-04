//
//  CAShapeLayer+CirclePoint.h
//  hairtech
//
//  Created by Alexander Prent on 01.08.2022.
//  Copyright © 2022 Admin. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface Circle : CAShapeLayer 

@property (assign) CGFloat x;
@property (assign) CGFloat y;

//-(id)initStart: (CGFloat) x andEnd: (CGFloat) y;

//-(void)setStartPoint:(CGPoint * _Nonnull)startPoint;
//-(void)setEndPoint:(CGPoint * _Nonnull)endPoint;

@end

NS_ASSUME_NONNULL_END
