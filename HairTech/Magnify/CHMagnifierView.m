//
//  CHMagnifierView.m
//  Magnifier
//
//  Created by Chenhao on 14-2-25.
//  Copyright (c) 2014年 Chenhao. All rights reserved.
//

#import "CHMagnifierView.h"

@interface CHMagnifierView ()

@property (strong, nonatomic) CALayer *contentLayer;

@end

@implementation CHMagnifierView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, 60, 60);
        self.backgroundColor = [UIColor clearColor];
        self.layer.borderWidth = 1;
        self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        self.layer.cornerRadius = 30;
        self.layer.masksToBounds = YES;
     //   self.windowLevel = UIWindowLevelAlert;
        
//        self.contentLayer = [CALayer layer];
//        self.contentLayer.frame = self.bounds;
//        self.contentLayer.delegate = self;
//        self.contentLayer.contentsScale = [[UIScreen mainScreen] scale];
//        [self.layer addSublayer:self.contentLayer];
    }
    
    return self;
}

- (void)setPointToMagnify:(CGPoint)pointToMagnify
{
    _pointToMagnify = pointToMagnify;
    
    CGPoint center = CGPointMake(pointToMagnify.x, self.center.y);
    if (pointToMagnify.y > CGRectGetHeight(self.bounds) * 0.5) {
        center.y = pointToMagnify.y -  CGRectGetHeight(self.bounds) / 2;
    }
    
    self.center = center;
//    [self.contentLayer setNeedsDisplay];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
 
}
*/

- (void)drawRect:(CGRect)rect {
        NSLog(@"Draw layer");

    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextTranslateCTM(context, self.frame.size.width/2, self.frame.size.height/2 );
    CGContextScaleCTM(context, 1.2, 1.2);
    CGContextConcatCTM(context, [self transform]);

    CGContextTranslateCTM(context, -self.pointToMagnify.x, -self.pointToMagnify.y  );

    [self.viewToMagnify.layer renderInContext:context];
}
//
//- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
//{
//    NSLog(@"Draw layer");
////    if (!CGRectContainsPoint(self.viewToMagnify.bounds, self.pointToMagnify)) {
////        NSLog(@"Invalid pointToMagnify!");
////        return;
////    }
//
//    CGContextTranslateCTM(ctx, self.frame.size.width * 0.5, self.frame.size.height * 0.5);
//	CGContextScaleCTM(ctx, 1.2, 1.2);
//	CGContextTranslateCTM(ctx, -1 * self.pointToMagnify.x, -1 * self.pointToMagnify.y);
//	[self.viewToMagnify.layer renderInContext:ctx];
//}

@end
