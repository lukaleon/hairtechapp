//
//  ViewController+NewEntryController.h
//  hairtech
//
//  Created by Alexander Prent on 18.10.2022.
//  Copyright © 2022 Admin. All rights reserved.
//

#import "ViewController.h"
#import "NewDrawController.h"

NS_ASSUME_NONNULL_BEGIN

@interface NewEntryController : UIViewController
{
    NSMutableString *entryviewImage;
    NSMutableString *entryviewImageSmall;

}
@property (weak, nonatomic) IBOutlet UIImageView *logo;
@property (weak, nonatomic) IBOutlet UILabel *labelToSave;
@property (weak, nonatomic) IBOutlet UIImageView *imageLeft;
@property (weak, nonatomic) IBOutlet UIImageView *imageRight;
@property (weak, nonatomic) IBOutlet UIImageView *imageTop;
@property (weak, nonatomic) IBOutlet UIImageView *imageFront;
@property (weak, nonatomic) IBOutlet UIImageView *imageBack;
@property (assign, nonatomic) NSString * techniqueName;
@property (assign, nonatomic) NSString * techniqueType;
@property (weak, nonatomic)  UIImage *imageL;
@property (weak, nonatomic)  UIImage *imageR;
@property (weak, nonatomic)  UIImage *imageT;
@property (weak, nonatomic)  UIImage *imageF;
@property (weak, nonatomic)  UIImage *imageB;
@property BOOL isFirstTime;
@property (weak, nonatomic) IBOutlet UIView *screenShotView;


//-(void)setImagesForLeft:(UIImage*)left rigth:(UIImage*)right top:(UIImage*) front:(UIImage*)front back:(UIImage*)back;
@end

NS_ASSUME_NONNULL_END
