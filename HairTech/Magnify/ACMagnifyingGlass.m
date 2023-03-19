//
//  ACMagnifyingGlass.m
//  MagnifyingGlass
//

#import "ACMagnifyingGlass.h"
#import <QuartzCore/QuartzCore.h>


static CGFloat const kACMagnifyingGlassDefaultRadius = 40;
static CGFloat const kACMagnifyingGlassDefaultOffset = -79;
static CGFloat const kACMagnifyingGlassDefaultScale = 1.2;

@interface ACMagnifyingGlass ()
@end

@implementation ACMagnifyingGlass

@synthesize viewToMagnify, touchPoint, touchPointOffset, scale, scaleAtTouchPoint;

- (id)init {
    self = [self initWithFrame:CGRectMake(0, 0, kACMagnifyingGlassDefaultRadius*2, kACMagnifyingGlassDefaultRadius*2)];
    return self;
}

- (id)initWithFrame:(CGRect)frame {
	
	if (self = [super initWithFrame:frame]) {
		self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
		self.layer.borderWidth = 1;
		self.layer.cornerRadius = frame.size.width / 2;
		self.layer.masksToBounds = YES;
		self.touchPointOffset = CGPointMake(0, kACMagnifyingGlassDefaultOffset);
		self.scale = kACMagnifyingGlassDefaultScale;
		self.viewToMagnify = nil;
		self.scaleAtTouchPoint = YES;
	}
	return self;
}

//- (void)setFrame:(CGRect)f {
//	super.frame = f;
//	self.layer.cornerRadius = f.size.width / 2;
//}

- (void)setTouchPoint:(CGPoint)point {
	touchPoint = point;
//    touchPoint = [self.viewToMagnify convertPoint:point toView:self];
	self.center = CGPointMake(point.x + touchPointOffset.x, point.y - 60);
    
    
    //    touchPoint = point;
    //    self.center = CGPointMake(point.x + touchPointOffset.x, point.y + touchPointOffset.y);
        
//        touchPoint = point;
//
//        CGPoint center = CGPointMake(touchPoint.x, self.center.y);
//        if (touchPoint.y > CGRectGetHeight(self.bounds) * 0.5) {
//            center.y = touchPoint.y -  CGRectGetHeight(self.bounds) / 2 ;
//        }
//
//
//        self.center = center;
    }

- (void)drawRect:(CGRect)rect {
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextTranslateCTM(context, self.frame.size.width/2, self.frame.size.height/2 );
	CGContextScaleCTM(context, scale, scale);
	CGContextTranslateCTM(context, -touchPoint.x , -touchPoint.y);
	[self.viewToMagnify.layer renderInContext:context];
}

@end
