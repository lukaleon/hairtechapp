//
//  SPUserResizableView.h
//  SPUserResizableView
//
//  Created by Stephen Poletto on 12/10/11.
//
//  SPUserResizableView is a user-resizable, user-repositionable
//  UIView subclass.

#import <Foundation/Foundation.h>

typedef struct SPUserResizableViewAnchorPoint {
    CGFloat adjustsX;
    CGFloat adjustsY;
    CGFloat adjustsH;
    CGFloat adjustsW;
} SPUserResizableViewAnchorPoint;

@protocol SPUserResizableViewDelegate;
@class SPGripViewBorderView;

@interface SPUserResizableView : UIView  {
    SPGripViewBorderView *borderView;
    UIView *contentViewNew;
    CGPoint touchStart;
    CGFloat minWidth;
    CGFloat minHeight;
    CGFloat newHeight;
    BOOL _textViewSelected;
    // Used to determine which components of the bounds we'll be modifying, based upon where the user's touch started.
    SPUserResizableViewAnchorPoint anchorPoint;
    BOOL textViewResponder;

    
    //id <SPUserResizableViewDelegate> delegate;
}


-(void)setTextViewSelected:(BOOL)textViewSelected;

@property (nonatomic, assign) id <SPUserResizableViewDelegate> delegate;

// Will be retained as a subview.
@property (nonatomic, assign) UIView *contentView;

// Default is 48.0 for each.
@property (nonatomic) CGFloat minWidth;
@property (nonatomic) CGFloat minHeight;

// Defaults to YES. Disables the user from dragging the view outside the parent view's bounds.
@property (nonatomic) BOOL preventsPositionOutsideSuperview;

- (void)hideEditingHandles;
- (void)showEditingHandles;
- (void)newFrame:(CGFloat)height;
@end

@protocol SPUserResizableViewDelegate <NSObject>

@optional

-(void)dotPosition:(SPUserResizableView*)rect;
// Called when the resizable view receives touchesBegan: and activates the editing handles.
- (void)userResizableViewDidBeginEditing:(SPUserResizableView *)userResizableView;

// Called when the resizable view receives touchesEnded: or touchesCancelled:
- (void)userResizableViewDidEndEditing:(SPUserResizableView *)userResizableView;

- (void)userResizingView:(SPUserResizableView *)userResizableView;
- (CGFloat)getTextViewHeight;
- (void)hideHandlesAndMenu;
- (void)adjustTextViewToFrame:(CGRect)rect;

@end
