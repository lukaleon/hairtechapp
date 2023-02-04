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
+(DotLayer*)addDotToFrame:(CGPoint)point height:(CGFloat)height imageName:(NSString*)imgName color:(UIColor*)color scale:(CGFloat)scaleFactor;
- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize scale:(CGFloat)scale;
-(UIImage *) getImageWithTintedColor:(UIImage *)image withTint:(UIColor *)color withIntensity:(float)alpha;
@property NSString * imageName;
@end

NS_ASSUME_NONNULL_END
