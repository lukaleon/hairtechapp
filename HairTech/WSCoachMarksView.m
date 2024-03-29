//
//  WSCoachMarksView.m
//  Version 0.2
//
//  Created by Dimitry Bentsionov on 4/1/13.
//  Copyright (c) 2013 Workshirt, Inc. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "WSCoachMarksView.h"
#import "UIBezierPath+Arrowhead.h"
static const CGFloat kAnimationDuration = 0.1f;
static const CGFloat kCutoutRadius = 2.0f;
static const CGFloat kMaxLblWidth = 230.0f;
static const CGFloat kLblSpacing = 35.0f;
static const BOOL kEnableContinueLabel = NO;
static const BOOL kEnableSkipButton = YES;

@implementation WSCoachMarksView {
    CAShapeLayer *mask;
    NSUInteger markIndex;
    UILabel *lblContinue;
    UIButton *btnSkipCoach;
}

#pragma mark - Properties

@synthesize delegate;
@synthesize coachMarks;
@synthesize lblCaption;
@synthesize maskColor = _maskColor;
@synthesize animationDuration;
@synthesize cutoutRadius;
@synthesize maxLblWidth;
@synthesize lblSpacing;
@synthesize enableContinueLabel;
@synthesize enableSkipButton;

#pragma mark - Methods

- (id)initWithFrame:(CGRect)frame coachMarks:(NSArray *)marks  startPoint:(CGPoint)startPoint labelStrt:(CGFloat)lblStart{
    self = [super initWithFrame:frame];
    if (self) {
        // Save the coach marks
        self.coachMarks = marks;
        arrowHeadPoint = startPoint;
        labelStart = lblStart;
        // Setup
        [self setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Setup
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Setup
        [self setup];
    }
    return self;
}

- (void)setup {
    // Default
    self.animationDuration = kAnimationDuration;
    self.cutoutRadius = kCutoutRadius;
    self.maxLblWidth = kMaxLblWidth;
    self.lblSpacing = kLblSpacing;
    self.enableContinueLabel = kEnableContinueLabel;
    self.enableSkipButton = kEnableSkipButton;
    
    // Shape layer mask
    mask = [CAShapeLayer layer];
    [mask setFillRule:kCAFillRuleEvenOdd];
    [mask setFillColor:[[UIColor colorWithHue:0.0f saturation:0.0f brightness:0.0f alpha:0.9f] CGColor]];
    [self.layer addSublayer:mask];
    
    // Capture touches
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userDidTap:)];
    [self addGestureRecognizer:tapGestureRecognizer];
    
    // Captions
    self.lblCaption = [[UILabel alloc] initWithFrame:(CGRect){{0.0f, 0.0f}, {self.maxLblWidth, 0.0f}}];
    self.lblCaption.backgroundColor = [UIColor clearColor];
    self.lblCaption.textColor = [UIColor whiteColor];
    self.lblCaption.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:17];
    self.lblCaption.lineBreakMode = NSLineBreakByWordWrapping;
    self.lblCaption.numberOfLines = 0;
    self.lblCaption.textAlignment = NSTextAlignmentCenter;
    self.lblCaption.alpha = 0.0f;
    [self addSubview:self.lblCaption];
    
    [self.layer addSublayer:[self addArrow]]
    ;
    // Hide until unvoked
    self.hidden = YES;
}

#pragma mark - Cutout modify

- (void)setCutoutToRect:(CGRect)rect withShape:(NSString *)shape{
    // Define shape
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRect:self.bounds];
    UIBezierPath *cutoutPath;
    
    if ([shape isEqualToString:@"circle"])
        cutoutPath = [UIBezierPath bezierPathWithOvalInRect:rect];
    else if ([shape isEqualToString:@"square"])
        cutoutPath = [UIBezierPath bezierPathWithRect:rect];
    else
        cutoutPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:self.cutoutRadius];
    
    
    [maskPath appendPath:cutoutPath];
    
    // Set the new path
    mask.path = maskPath.CGPath;
}

- (void)animateCutoutToRect:(CGRect)rect withShape:(NSString *)shape{
    // Define shape
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRect:self.bounds];
    UIBezierPath *cutoutPath;

    if ([shape isEqualToString:@"circle"])
        cutoutPath = [UIBezierPath bezierPathWithOvalInRect:rect];
    else if ([shape isEqualToString:@"square"])
        cutoutPath = [UIBezierPath bezierPathWithRect:rect];
    else
        cutoutPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:self.cutoutRadius];
    
    
    [maskPath appendPath:cutoutPath];
    
    // Animate it
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"path"];
    anim.delegate = self;
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    anim.duration = self.animationDuration;
    anim.removedOnCompletion = NO;
    anim.fillMode = kCAFillModeForwards;
    anim.fromValue = (__bridge id)(mask.path);
    anim.toValue = (__bridge id)(maskPath.CGPath);
    [mask addAnimation:anim forKey:@"path"];
    mask.path = maskPath.CGPath;
}

#pragma mark - Mask color

- (void)setMaskColor:(UIColor *)maskColor {
    _maskColor = maskColor;
    [mask setFillColor:[maskColor CGColor]];
}

#pragma mark - Touch handler

- (void)userDidTap:(UITapGestureRecognizer *)recognizer {
    // Go to the next coach mark
    [self goToCoachMarkIndexed:(markIndex+1)];
}

#pragma mark - Navigation

- (void)start {
    // Fade in self
    self.alpha = 0.0f;
    self.hidden = NO;
    [UIView animateWithDuration:self.animationDuration
                     animations:^{
                         self.alpha = 1.0f;
                     }
                     completion:^(BOOL finished) {
                         // Go to the first coach mark
                         [self goToCoachMarkIndexed:0];
                     }];
}

- (void)skipCoach {
    [self goToCoachMarkIndexed:self.coachMarks.count];
}

- (void)goToCoachMarkIndexed:(NSUInteger)index {
    // Out of bounds
    if (index >= self.coachMarks.count) {
        [self cleanup];
        return;
    }
    
    // Current index
    markIndex = index;
    
    // Coach mark definition
    NSDictionary *markDef = [self.coachMarks objectAtIndex:index];
    NSString *markCaption = [markDef objectForKey:@"caption"];
    CGRect markRect = [[markDef objectForKey:@"rect"] CGRectValue];
    
    NSString *shape = @"other";
    if([[markDef allKeys] containsObject:@"shape"])
        shape = [markDef objectForKey:@"shape"];
    
    // Delegate (coachMarksView:willNavigateTo:atIndex:)
    if ([self.delegate respondsToSelector:@selector(coachMarksView:willNavigateToIndex:)]) {
        [self.delegate coachMarksView:self willNavigateToIndex:markIndex];
    }
    
    // Calculate the caption position and size
    self.lblCaption.alpha = 0.0f;
    self.lblCaption.frame = (CGRect){{0.0f, 0.0f}, {self.maxLblWidth, 0.0f}};
    self.lblCaption.text = markCaption;
    [self.lblCaption sizeToFit];
    
    CGFloat lableIndex;
    if (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad){
        lableIndex = 70;
    }else{
        lableIndex = 50;
        
    }
    
    
    CGFloat y = markRect.origin.y + markRect.size.height + self.lblSpacing + lableIndex;
    CGFloat bottomY = y + self.lblCaption.frame.size.height + self.lblSpacing;
    if (bottomY > self.bounds.size.height) {
        y = markRect.origin.y - self.lblSpacing - self.lblCaption.frame.size.height;
    }
    CGFloat x = floorf((self.bounds.size.width - self.lblCaption.frame.size.width) / 2.0f - (labelStart * 2));
    
    // Animate the caption label
    self.lblCaption.frame = (CGRect){{x, y}, self.lblCaption.frame.size};
    
    [UIView animateWithDuration:0.3f animations:^{
        self.lblCaption.alpha = 1.0f;
    }];
    
    // If first mark, set the cutout to the center of first mark
    if (markIndex == 0) {
        CGPoint center = CGPointMake(floorf(markRect.origin.x + (markRect.size.width / 2.0f)), floorf(markRect.origin.y + (markRect.size.height / 2.0f)));
        CGRect centerZero = (CGRect){center, CGSizeZero};
        [self setCutoutToRect:centerZero withShape:shape];
    }
    
    // Animate the cutout
    [self animateCutoutToRect:markRect withShape:shape];
    
    CGFloat lblContinueWidth = self.enableSkipButton ? (70.0/100.0) * self.bounds.size.width : self.bounds.size.width;
    CGFloat btnSkipWidth = self.bounds.size.width - lblContinueWidth;
    
    // Show continue lbl if first mark
    if (self.enableContinueLabel) {
        if (markIndex == 0) {
            lblContinue = [[UILabel alloc] initWithFrame:(CGRect){{0, self.bounds.size.height - 30.0f}, {lblContinueWidth, 30.0f}}];
            lblContinue.font = [UIFont boldSystemFontOfSize:13.0f];
            lblContinue.textAlignment = NSTextAlignmentCenter;
            lblContinue.text = @"Tap to continue";
            lblContinue.alpha = 0.0f;
            lblContinue.backgroundColor = [UIColor whiteColor];
            [self addSubview:lblContinue];
            [UIView animateWithDuration:0.3f delay:1.0f options:0 animations:^{
                lblContinue.alpha = 1.0f;
            } completion:nil];
        } else if (markIndex > 0 && lblContinue != nil) {
            // Otherwise, remove the lbl
            [lblContinue removeFromSuperview];
            lblContinue = nil;
        }
    }
    
    if (self.enableSkipButton) {
                
        btnSkipCoach =  [UIButton buttonWithType:UIButtonTypeCustom];
        btnSkipCoach.frame = (CGRect){{lblContinueWidth, self.bounds.size.height - 300.0f}, {self.bounds.size.width/5 , 30.0f}};
        CGPoint newCenter = CGPointMake(self.center.x, self.bounds.size.height - 500.0f);
        
        [btnSkipCoach addTarget:self action:@selector(skipCoach) forControlEvents:UIControlEventTouchUpInside];
        [btnSkipCoach setTitle:@"Got It" forState:UIControlStateNormal];
        btnSkipCoach.titleLabel.font = [UIFont fontWithName:@"AvenirNext-Bold" size:14];
        btnSkipCoach.alpha = 0.0f;
        btnSkipCoach.tintColor = [UIColor whiteColor];
        btnSkipCoach.backgroundColor = [UIColor colorNamed:@"orange"];
        btnSkipCoach.center = newCenter;
        [btnSkipCoach.layer setCornerRadius:btnSkipCoach.frame.size.height / 2];
        [btnSkipCoach.layer setMasksToBounds:YES];
        
      //  [self addSubview:btnSkipCoach];
        [UIView animateWithDuration:0.1f delay:0.0f options:0 animations:^{
            btnSkipCoach.alpha = 1.0f;
        } completion:nil];
    }
}

#pragma mark - Cleanup

- (void)cleanup {
    // Delegate (coachMarksViewWillCleanup:)
    if ([self.delegate respondsToSelector:@selector(coachMarksViewWillCleanup:)]) {
        [self.delegate coachMarksViewWillCleanup:self];
    }
    
    // Fade out self
    [UIView animateWithDuration:self.animationDuration
                     animations:^{
                         self.alpha = 0.0f;
                     }
                     completion:^(BOOL finished) {
                         // Remove self
                         [self removeFromSuperview];
                         
                         // Delegate (coachMarksViewDidCleanup:)
                         if ([self.delegate respondsToSelector:@selector(coachMarksViewDidCleanup:)]) {
                             [self.delegate coachMarksViewDidCleanup:self];
                         }
                     }];
}

#pragma mark - Animation delegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    // Delegate (coachMarksView:didNavigateTo:atIndex:)
    if ([self.delegate respondsToSelector:@selector(coachMarksView:didNavigateToIndex:)]) {
        [self.delegate coachMarksView:self didNavigateToIndex:markIndex];
    }
}


#pragma mark - Add arrow line
-(CAShapeLayer*)addArrow
{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    Arrowhead *path = [Arrowhead bezierPath];
    [path moveToPoint:arrowHeadPoint];
   
    [path addQuadCurveToPoint:CGPointMake(self.frame.size.width/2 - (labelStart * 2), 170 - (labelStart / 2)) controlPoint:CGPointMake(self.frame.size.width/2-10 - (labelStart * 2), 80 - (labelStart /2))];
    [path moveToPoint:arrowHeadPoint];

    [path addArrowheadToPoint:arrowHeadPoint tipLength:10.0f tipAngle:M_PI_4 ];
    shapeLayer.path = path.CGPath;
    shapeLayer.strokeColor = [UIColor whiteColor].CGColor;
    shapeLayer.lineWidth = 2.0f;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    
    return shapeLayer;
}
@end
