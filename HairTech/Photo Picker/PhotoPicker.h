//
//  UIViewController+ColorWheelController.h
//  hairtech
//
//  Created by Alexander Prent on 12.01.2023.
//  Copyright © 2023 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISColorWheel.h"
#import "sliderCustom.h"
#import "ColorResetButton.h"
#import "ImageCollectionViewCell.h"
#import "ImagePreviewController.h"
#import "VCPresentationDelegate.h"
NS_ASSUME_NONNULL_BEGIN
@import PhotosUI;



@protocol PhotoPickerDelegate
-(void)disableDismissalRecognizers;
-(void)savePhotos:(NSMutableArray*)photos;

@end
@interface PhotoPicker : UIViewController <UIGestureRecognizerDelegate, UIAdaptivePresentationControllerDelegate,UICollectionViewDataSource, UICollectionViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIContextMenuInteractionDelegate, ImageCollectionViewCellDelegate, ImagePreviewControllerDelegate,PHPickerViewControllerDelegate>
{
    id <PhotoPickerDelegate> __weak delegate;

    UIView* _wellView;
    UIButton * colorButton;
    CAShapeLayer *line;
    CGPoint initialTouchPoint;
    CGPoint touchBegin;
    CGRect btnRect;
    CGRect newSliderRect;
    UIMenuController * menuReset;
    ColorResetButton *restoreBtn;
   // UILabel * noDataLabel;
    UILabel *noPhotoLabel;
    PHPickerConfiguration *configuration;

}

-(void)setMyArray:(NSArray *)arr;

@property (nonatomic, strong) VCPresentationDelegate* overlayDelegate;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *imagesArray;
@property (nonatomic, strong) NSMutableArray *tempImages;



@property (strong, nonatomic) IBOutlet sliderCustom * _brightnessSlider;

@property BOOL isIpad;
@property (strong, nonatomic) IBOutlet UIButton * applyBtn;
@property (weak, nonatomic) id<PhotoPickerDelegate> delegate;
@property UIColor * startColor;
@property NSMutableArray * colorCollection;
@property(nonatomic, strong) NSMutableArray *buttonCollection;

@end

NS_ASSUME_NONNULL_END
