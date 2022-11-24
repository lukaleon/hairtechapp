//
//  HMPopUpView.m
//  HMPopUp
//
//  Created by Himal Madhushan on 12/16/14.
//  Copyright (c) 2014 Himal Madhushan. All rights reserved.
//

#import "HMPopUpView.h"

#define DEFAULT_BORDER_WIDTH 2
#define DEFAULT_PRESENTATION_ANIMATION_DURATION 0.4
#define DEFAULT_DISMISS_ANIMATION_DURATION 0.4

@interface HMPopUpView (){
    UIView *HUD, *containerView, *separatorView, *buttonView, *middleView;
    UILabel *lblTitle, *lblMessage;
    UIButton *btnOk, *btnCancel;
    UITextField *txtField;
    NSTimeInterval presentDuration, dismissDuration;
}

@end

@implementation HMPopUpView

@synthesize hmDelegate = _hmDelegate, transitionType, dismissType;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

-(id)initWithTitle:(NSString *)title okButtonTitle:(NSString *)okBtnTtl cancelButtonTitle:(NSString *)cnclBtnTtl okBtnColor:(UIColor*)clr delegate:(id<HMPopUpViewDelegate>)delegate {
    
    
    CGRect rect = CGRectMake([[UIScreen mainScreen] bounds].origin.x, [[UIScreen mainScreen] bounds].origin.y - 50, [[UIScreen mainScreen] bounds].size.width,[[UIScreen mainScreen] bounds].size.height);
    
    
    self = [super initWithFrame:rect];
    
    if (self) {
        _hmDelegate = delegate;
        
        self.backgroundColor = [UIColor clearColor];
        HUD = [[UIView alloc] initWithFrame:self.bounds];
        HUD.backgroundColor = [UIColor grayColor];
        HUD.alpha = 0.7;
        [self addSubview:HUD];
        
        //Creating the view which contains all UI components
        containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 170)];
        containerView.backgroundColor = [UIColor blackColor];
        containerView.layer.cornerRadius = 15;
        containerView.clipsToBounds = YES;
        
        CGRect cnvwFrame = containerView.bounds;
        cnvwFrame.origin.x = self.frame.size.width / 2 - (cnvwFrame.size.width / 2);
        cnvwFrame.origin.y = self.frame.size.height / 2 - (cnvwFrame.size.height / 2);
        containerView.frame = cnvwFrame;
        [self addSubview:containerView];
        
        CGRect cvFrame = containerView.bounds;
        
        //Separator View creation
        separatorView = [[UIView alloc] initWithFrame:CGRectMake(cvFrame.origin.x, cvFrame.origin.y + 45, cvFrame.size.width, 1)];
        separatorView.backgroundColor = [UIColor colorNamed:@"textWhiteDeepBlue"];
        separatorView.alpha = 0.0;
        [containerView addSubview:separatorView];
        
        //Title label
        lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(cvFrame.origin.x + 20, cvFrame.origin.y + 15, cvFrame.size.width - 40, 22)];
        lblTitle.numberOfLines = 1;
        lblTitle.text = title;
        lblTitle.textColor =[UIColor colorNamed:@"textWhiteDeepBlue"];
        lblTitle.textAlignment = NSTextAlignmentCenter;
        lblTitle.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:18];
        [containerView addSubview:lblTitle];
        
        //TextField for user inputs
        txtField = [[UITextField alloc] initWithFrame:CGRectMake(cvFrame.origin.x + 40, cvFrame.origin.y + 70, cvFrame.size.width - 80, 30)];
        [[UITextField appearance] setTintColor:[UIColor colorNamed:@"orange"]];
        txtField.textAlignment = NSTextAlignmentCenter;
        txtField.backgroundColor = [UIColor colorWithRed:215.0/255.0 green:213.0/255.0 blue:215.0/255.0 alpha:1.0];
        txtField.borderStyle = UITextBorderStyleRoundedRect;
       // txtField.layer.borderColor = [UIColor colorNamed:@"orange"].CGColor;
       // txtField.layer.borderWidth=1.0;

        txtField.layer.cornerRadius = 3;
        txtField.clipsToBounds = YES;
        txtField.textColor =  [UIColor colorNamed:@"textWhiteDeepBlue"];
       // txtField.tintColor = [UIColor blackColor];
        txtField.font = [UIFont fontWithName:@"AvenirNext-Medium" size:13];
        txtField.delegate = self;
        [containerView addSubview:txtField];
        
        //Button view creation
        buttonView = [[UIView alloc] initWithFrame:CGRectMake(cvFrame.origin.x , cvFrame.origin.y + 115, cvFrame.size.width, cvFrame.size.height - 130)];
        buttonView.backgroundColor = [UIColor whiteColor];
        [containerView addSubview:buttonView];
        
        //Action button creation
        btnOk = [[UIButton alloc] initWithFrame:CGRectMake(cvFrame.origin.x , cvFrame.origin.y + 115, cvFrame.size.width / 2 - 1, 39)];
        [btnOk setTitle:okBtnTtl forState:UIControlStateNormal];
        [btnOk setTitleColor:[UIColor colorNamed:@"orange"] forState:UIControlStateNormal];

        btnOk.backgroundColor = [UIColor colorNamed:@"grey"];
        btnOk.titleLabel.textColor =clr;
        btnOk.titleLabel.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:15];
        btnOk.enabled = NO;
        btnOk.alpha = 1;
        [containerView addSubview:btnOk];
        [btnOk addTarget:self action:@selector(acceptAction) forControlEvents:UIControlEventTouchUpInside];
        
        btnCancel = [[UIButton alloc] initWithFrame:CGRectMake(btnOk.frame.origin.x + btnOk.frame.size.width + 1, cvFrame.origin.y + 115, cvFrame.size.width / 2, 39)];
        [btnCancel setTitle:cnclBtnTtl forState:UIControlStateNormal];
        
        [btnCancel setTitleColor:[UIColor colorNamed:@"textWhiteDeepBlue"] forState:UIControlStateNormal];

        btnCancel.backgroundColor = [UIColor colorNamed:@"grey"];
        btnCancel.titleLabel.textColor = [UIColor colorNamed:@"textWhiteDeepBlue"];
        btnCancel.titleLabel.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:15];
        [containerView addSubview:btnCancel];
        [btnCancel addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
        
        middleView = [[UIView alloc] initWithFrame:CGRectMake(cvFrame.origin.x, separatorView.frame.origin.y + separatorView.frame.size.height, cvFrame.size.width, btnOk.frame.origin.y)];
        middleView.backgroundColor = [UIColor colorNamed:@"grey"];
        [containerView insertSubview:middleView belowSubview:txtField];
        
        presentDuration = DEFAULT_PRESENTATION_ANIMATION_DURATION;
        dismissDuration = DEFAULT_DISMISS_ANIMATION_DURATION;
        
    }
    
    return self;
}




- (void)setTextFieldText:(NSString *)textFieldTxt{
    
    
    txtField.text = textFieldTxt;
}




-(void)configureHMPopUpViewWithBGColor:(UIColor *)BGColor titleColor:(UIColor *)ttlColor buttonViewColor:(UIColor *)btnViewColor buttonBGColor:(UIColor *)btnBGColor buttonTextColor:(UIColor *)btnTxtColor {
    
    containerView.backgroundColor = BGColor;
    lblTitle.textColor = ttlColor;
    buttonView.backgroundColor = btnViewColor;
   // btnOk.backgroundColor = btnBGColor;
   // btnCancel.backgroundColor = btnBGColor;
   // [btnOk setTitleColor: [UIColor colorNamed:@"orange"] forState:UIControlStateNormal | UIControlStateHighlighted | UIControlStateSelected];
   // btnOk.titleLabel.textColor = [UIColor colorNamed:@"orange"];

//    [btnCancel setTitleColor:ttlColor forState:UIControlStateNormal | UIControlStateHighlighted | UIControlStateSelected];
//   btnCancel.titleLabel.textColor = ttlColor;//[UIColor colorWithRed:0.64 green:0.64 blue:0.64 alpha:1.000];
    
}

-(void)setMiddleViewBGColor:(UIColor *)middleViewBGColor {
    
    middleView.backgroundColor = middleViewBGColor;
    
}

-(void)setTextFieldFont:(UIFont *)textFieldFont {
    
    txtField.font = textFieldFont;
    
}

-(void)setTitleFont:(UIFont *)titleFont {
    
    lblTitle.font = titleFont;
    
}

-(void)setBorderColor:(UIColor *)borderColor {
    
    containerView.layer.borderWidth = DEFAULT_BORDER_WIDTH;
    containerView.layer.borderColor = borderColor.CGColor;
    
}

-(void)setTitleSeparatorColor:(UIColor *)titleSeparatorColor {
    
    separatorView.backgroundColor = titleSeparatorColor;
    
}

-(void)setButtonViewBGColor:(UIColor *)buttonViewBGColor {
    
    buttonView.backgroundColor = buttonViewBGColor;
    
}

-(void)setTextFieldBGColor:(UIColor *)textFieldBGColor {
    
    txtField.backgroundColor = textFieldBGColor;
    
}

-(void)setTextFieldTextColor:(UIColor *)textFieldTextColor {
    
    txtField.textColor = textFieldTextColor;
    
}

-(void)setTextFieldBoarderWidth:(CGFloat)textFieldBoarderWidth {
    
    txtField.layer.borderWidth = textFieldBoarderWidth;
    
}

-(void)setTextFieldBoarderColor:(UIColor *)textFieldBoarderColor {
    
    txtField.layer.borderColor = textFieldBoarderColor.CGColor;
    
}

-(void)setBorderWidth:(float)borderWidth {
    
    containerView.layer.borderWidth = borderWidth;
    
}

-(void)setOkButtonTextColor:(UIColor *)okButtonTextColor{
    
    btnOk.titleLabel.textColor = [UIColor colorNamed:@"orange"];
    
}

-(void)setOkButtonBGColor:(UIColor *)okButtonBGColor{
    
    btnOk.backgroundColor = okButtonBGColor;
    
}

-(void)setPresentAnimationDuration:(NSTimeInterval)presentAnimationDuration{
    
    presentDuration = presentAnimationDuration;
    
}

-(void)setDismissAnimationDuration:(NSTimeInterval)dismissAnimationDuration {
    
    dismissDuration = dismissAnimationDuration;
    
}

#pragma mark - PopUpView Button Actions
- (void)acceptAction {
    
    [self hide];
    
    if ([_hmDelegate respondsToSelector:@selector(popUpView:accepted:inputText:)]) {
    
        [_hmDelegate popUpView:self accepted:YES inputText:txtField.text];
        
    }
    
    
    if([self.hmDelegate checkEnteredName:txtField.text])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning!"
                                                        message:@"The diagram with this name exists"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
        [self.hmDelegate checkEnteredName:txtField.text];
    }
    
    if(![self.hmDelegate checkEnteredName:txtField.text]){
        
    [self.hmDelegate renameTechniqueDelegate:txtField.text];
    }
}

- (void)cancelAction {
    
    [self hide];
    
    if ([_hmDelegate respondsToSelector:@selector(popUpView:accepted:inputText:)]) {
        
        [_hmDelegate popUpView:self accepted:NO inputText:txtField.text];
        
    }
    
}

#pragma mark - PopUpView
- (void)showInView:(UIView *)view {
    
    containerView.alpha = 0;
    [view addSubview:self];
    
    switch (transitionType) {
        case HMPopUpTransitionTypePop: {
            
            containerView.transform = CGAffineTransformMakeScale(0, 0);
            
            [UIView animateWithDuration:presentDuration
                                  delay:0
                 usingSpringWithDamping:1
                  initialSpringVelocity:1
                                options:UIViewAnimationOptionAllowUserInteraction
                             animations:^{
                                 
                                 containerView.alpha = 1.0f;
                                 containerView.transform = CGAffineTransformIdentity;
                                 
                             } completion:^(BOOL finished) {
                                 
                             }];
        
            break;
        }
            
        case HMPopUpTransitionTypePopFromBottom: {
            
//            containerView.transform = CGAffineTransformMakeScale(0.0, 0.0);
//            containerView.transform = CGAffineTransformMakeTranslation(0, [UIScreen mainScreen].bounds.size.height - 200);
            
            CGAffineTransform t1 = CGAffineTransformMakeScale(0.0, 0.0);
            CGAffineTransform t2 = CGAffineTransformMakeTranslation(0, [UIScreen mainScreen].bounds.size.height );
            containerView.transform = CGAffineTransformConcat(t1, t2);
            
            [UIView animateWithDuration:presentDuration
                                  delay:0
                 usingSpringWithDamping:1
                  initialSpringVelocity:1
                                options:UIViewAnimationOptionAllowUserInteraction
                             animations:^{
                                 
                                 containerView.alpha = 1.0f;
                                 containerView.transform = CGAffineTransformIdentity;
                                 
                             } completion:^(BOOL finished) {
                                 
                             }];
            
        
            break;
        }
            
        case HMPopUpTransitionTypePopFromTop: {
            
            CGAffineTransform t1 = CGAffineTransformMakeScale(0.0, 0.0);
            CGAffineTransform t2 = CGAffineTransformMakeTranslation(0, [UIScreen mainScreen].bounds.origin.y - containerView.frame.size.height*2);
            containerView.transform = CGAffineTransformConcat(t1, t2);
            
            [UIView animateWithDuration:presentDuration
                                  delay:0
                 usingSpringWithDamping:1
                  initialSpringVelocity:1
                                options:UIViewAnimationOptionAllowUserInteraction
                             animations:^{
                                 
                                 containerView.alpha = 1.0f;
                                 containerView.transform = CGAffineTransformIdentity;
                                 
                             } completion:^(BOOL finished) {
                                 
                             }];
            
            break;
        }
            
        case HMPopUpTransitionTypeFadeIn: {
            [UIView animateWithDuration:presentDuration animations:^{
                containerView.alpha = 1.0f;
            }];
        
            break;
        }
            
        case HMPopUpTransitionTypeFadeInFromBottom: {
            containerView.transform = CGAffineTransformMakeTranslation(0, [UIScreen mainScreen].bounds.size.height - 200);
            
            [UIView animateWithDuration:presentDuration
                                  delay:0
                 usingSpringWithDamping:1
                  initialSpringVelocity:1
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 
                                 containerView.alpha = 1.0f;
                                 containerView.transform = CGAffineTransformIdentity;
                                 
                             } completion:^(BOOL finished) {
                                 
                             }];
        
            break;
        }
            
        case HMPopUpTransitionTypeFadeInFromTop: {
            
            containerView.transform = CGAffineTransformMakeTranslation(0, [UIScreen mainScreen].bounds.origin.y - 200);
            
            [UIView animateWithDuration:presentDuration
                                  delay:0
                 usingSpringWithDamping:1
                  initialSpringVelocity:1
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 
                                 containerView.alpha = 1.0f;
                                 containerView.transform = CGAffineTransformIdentity;
                                 
                             } completion:^(BOOL finished) {
                                 
                             }];
            
            break;
        }
            
        default: {
            containerView.transform = CGAffineTransformMakeScale(0, 0);
            
            [UIView animateWithDuration:presentDuration
                                  delay:0
                 usingSpringWithDamping:1
                  initialSpringVelocity:1
                                options:UIViewAnimationOptionAllowUserInteraction
                             animations:^{
                                 
                                 containerView.alpha = 1.0f;
                                 containerView.transform = CGAffineTransformIdentity;
                                 
                             } completion:^(BOOL finished) {
                                 
                             }];
        
            break;
        }
    }
    [txtField becomeFirstResponder];
}

- (void)hide {
    
    if ([txtField isEditing]) {
        [txtField resignFirstResponder];
        
        [self.hmDelegate changeTechniqueName];
        
        
    }
    
    switch (dismissType) {
        case HMPopUpDismissTypeFadeOut: {
            
            [UIView animateWithDuration:dismissDuration
                                  delay:0
                                options:UIViewAnimationOptionBeginFromCurrentState
                             animations:^{
                                 
                                 containerView.alpha = 0.0;
                                 self.alpha = 0.0;
                                 
                             }
                             completion:^(BOOL finished) {
                                 
                                 [self removeFromSuperview];
                                 
                             }];
            break;
        }
            
        case HMPopUpDismissTypeFadeOutBottom: {
            
            [UIView animateWithDuration:dismissDuration
                                  delay:0
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 
                                 containerView.alpha = 0;
                                 self.alpha = 0.0;
                                 containerView.transform = CGAffineTransformMakeTranslation(0, [UIScreen mainScreen].bounds.size.height);
                                 
                             } completion:^(BOOL finished) {
                                 
                             }];
            break;
        }
            
        case HMPopUpDismissTypeFadeOutTop: {
            
            [UIView animateWithDuration:dismissDuration
                                  delay:0
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 
                                 containerView.alpha = 0;
                                 self.alpha = 0.0;
                                 containerView.transform = CGAffineTransformMakeTranslation(0, -(containerView.frame.size.height+containerView.frame.origin.y));
                                 
                             } completion:^(BOOL finished) {
                                 
                             }];
            
            break;
        }
        default: {
            
            [UIView animateWithDuration:dismissDuration
                                  delay:0
                                options:UIViewAnimationOptionBeginFromCurrentState
                             animations:^{
                                 
                                 containerView.alpha = 0.0;
                                 self.alpha = 0.0;
                                 
                             }
                             completion:^(BOOL finished) {
                                 
                                 [self removeFromSuperview];
                                 
                             }];
            
            break;
        }
    }
    
    
}


#pragma mark - TextField Delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if (textField == txtField) {
        
        if ([UIScreen mainScreen].bounds.size.height < 570) {
            
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                
                containerView.transform = CGAffineTransformMakeTranslation(0, -70);
                
            } completion:^(BOOL finished) {
                
            }];
            
        }
        
    }
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {

    
    if (textField == txtField) {
        
        
        [txtField resignFirstResponder];
        
        if ([UIScreen mainScreen].bounds.size.height < 570) {
            
            if (containerView.frame.origin.y < self.frame.size.height / 2 - (containerView.frame.size.height / 2)) {
                
                [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                    
                    containerView.transform = CGAffineTransformMakeTranslation(0, 0);
                    
                } completion:^(BOOL finished) {
                    
                }];
                
            }
            
        }
        
    }
  
    return YES;
    
    
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (textField == txtField && newText.length > 0) {
        
        btnOk.enabled = YES;
        btnOk.alpha = 1;
        
    } else {
        
        btnOk.enabled = NO;
        btnOk.alpha = 0.5;
        
    }
    
    return YES;
    
}
@end
