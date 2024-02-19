//
//  ImagePreviewController.h
//  hairtech
//
//  Created by Alexander Prent on 10.02.2024.
//  Copyright © 2024 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol ImagePreviewControllerDelegate <NSObject>

@end

@interface ImagePreviewController : UIViewController<UIGestureRecognizerDelegate>
{
    CGPoint initialTouchPoint;

}

- (IBAction)closeNotes:(id)sender;
- (void)initWithView:(UIView *)p;

@property(nonatomic, retain) UIView *parent;

@property (nonatomic,weak) id<ImagePreviewControllerDelegate> delegate;

@property (nonatomic,weak) NSString *textOfTextView;
@property (nonatomic,weak) UIImage *imgFromPhoto;


@end

