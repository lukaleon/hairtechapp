//
//  CAShapeLayer+DotLayer.h
//  hairtech
//
//  Created by Alexander Prent on 20.01.2023.
//  Copyright © 2023 Admin. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface  DotLayer : CALayer
+(DotLayer*)addDotToFrame:(CGPoint)point;

@end

NS_ASSUME_NONNULL_END
