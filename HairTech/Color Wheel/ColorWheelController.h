//
//  UIViewController+ColorWheelController.h
//  hairtech
//
//  Created by Alexander Prent on 12.01.2023.
//  Copyright © 2023 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISColorWheel.h"
NS_ASSUME_NONNULL_BEGIN


@protocol ColorWheelControllerDelegate
-(void)disableDismissalRecognizers;
@end
@interface ColorWheelController : UIViewController <ISColorWheelDelegate,UIGestureRecognizerDelegate, UIAdaptivePresentationControllerDelegate>
{
    ISColorWheel * _colorWheel;
    UISlider* _brightnessSlider;
    UIView* _wellView;
    UIButton * colorButton;
    CAShapeLayer *line;
    CGPoint initialTouchPoint;
    CGPoint touchBegin;
    CGRect btnRect;
    CGRect newSliderRect;

}
@property BOOL isIpad;
@property (strong, nonatomic) IBOutlet UIButton * applyBtn;
@property (weak, nonatomic) id<ColorWheelControllerDelegate> delegate;
@property UIColor * startColor;
@property NSMutableArray * colorCollection;
@property(nonatomic, strong) NSMutableArray *buttonCollection;

@end

NS_ASSUME_NONNULL_END
