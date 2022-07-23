//
//  Ruler.m
//  hairtech
//
//  Created by Alexander Prent on 03.06.2022.
//  Copyright © 2022 Admin. All rights reserved.
//

#import "Ruler.h"

@interface Ruler ()
@property (strong, nonatomic) CALayer *contentLayer;

@end

@implementation Ruler

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
     
        NSLog(@"AXISAXISAXISS %f",self.x_axis);
        
        self.frame = CGRectMake(0, 0, self.frame.size.width*2, self.frame.size.height*2);
        
        self.backgroundColor = [UIColor clearColor];
        self.layer.borderWidth = 1;
        self.layer.borderColor = [[UIColor colorWithRed:19.0f/255.0f green:87.0f/255.0f blue:205.0f/255.0f alpha:0.0f] CGColor];
        self.layer.cornerRadius = 0;
        self.layer.masksToBounds = YES;
        self.windowLevel = UIWindowLevelAlert;
        
        self.contentLayer = [CALayer layer];
        self.contentLayer.frame = self.bounds;
        self.contentLayer.delegate = self;
        self.contentLayer.contentsScale = [[UIScreen mainScreen] scale];
        [self.layer addSublayer:self.contentLayer];
    
    }
    return self;
}

- (void)setPointToShowRuler:(CGPoint)pointToShowRuler
{
    _pointToShowRuler = pointToShowRuler;
    CGPoint center = CGPointMake(pointToShowRuler.x, pointToShowRuler.y);
    center.y = pointToShowRuler.y;
    center.x = pointToShowRuler.x;
    
    self.center = center;
    [self.contentLayer setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
  

    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    _thePointOfStart = appDelegate.theFirstPointForRuler;
    
    NSLog(@"AXISAXISAXISS %f",_pointToShowRuler.x);

    CGPoint startPoint;
    CGPoint endPoint;
    CGFloat f = [self pointPairToBearingDegrees:_pointToShowRuler secondPoint:_thePointOfStart];

    NSLog(@"ANGLE %f",f);
   
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 0.8);

    if((f >45 && f<135) || (f>225&&f<315)){
        
       
        CGContextSetStrokeColorWithColor(context,  [[UIColor colorWithRed:19.0f/255.0f green:87.0f/255.0f blue:205.0f/255.0f alpha:1.0f]CGColor]);
        startPoint.x = 0;
        startPoint.y =  CGRectGetHeight(self.bounds)/2;
        endPoint.x =  self.frame.size.width;
        endPoint.y =CGRectGetHeight(self.bounds)/2;
        
    }

 
    if ((f > 315 &&  f<360)|| (f>0&&f<45)|| (f>135&&f<225))    {
       
        CGContextRef context1 = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context1, 0.8);
        
        CGContextSetStrokeColorWithColor(context1,  [[UIColor colorWithRed:19.0f/255.0f green:87.0f/255.0f blue:205.0f/255.0f alpha:1.0f]CGColor]);
        
        startPoint.x = CGRectGetWidth(self.bounds)/2;
            startPoint.y = 0;
        endPoint.x =  CGRectGetWidth(self.bounds)/2;
        endPoint.y =self.frame.size.height;
      
    }
    CGContextMoveToPoint(context, startPoint.x, startPoint.y);
    CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
    CGContextStrokePath(context);
}

- (CGFloat) pointPairToBearingDegrees:(CGPoint)startingPoint secondPoint:(CGPoint) endingPoint
{
    CGPoint originPoint = CGPointMake(endingPoint.x - startingPoint.x, endingPoint.y - startingPoint.y); // get origin point to origin by subtracting end from start
    float bearingRadians = atan2f(originPoint.y, originPoint.x); // get bearing in radians
    float bearingDegrees = bearingRadians * (180.0 / M_PI); // convert to degrees
    bearingDegrees = (bearingDegrees > 0.0 ? bearingDegrees : (360.0 + bearingDegrees)); // correct discontinuity
    return bearingDegrees;
}


@end
