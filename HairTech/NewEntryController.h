//
//  ViewController+NewEntryController.h
//  hairtech
//
//  Created by Alexander Prent on 18.10.2022.
//  Copyright © 2022 Admin. All rights reserved.
//

#import "ViewController.h"
#import "NewDrawController.h"
#import "NotesViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface NewEntryController : UIViewController <NotesViewDelegate>
{
    NSMutableString *entryviewImage;
    NSMutableString *entryviewImageSmall;
    NSMutableDictionary * temporaryDictionary;
    NSString * _techniqueNameID;
}
-(void)setTechniqueID:(NSString*)techId;

@property (weak, nonatomic) IBOutlet UIImageView *logo;
@property (weak, nonatomic) IBOutlet UILabel *labelToSave;
@property (weak, nonatomic) IBOutlet UIImageView *imageLeft;
@property (weak, nonatomic) IBOutlet UIImageView *imageRight;
@property (weak, nonatomic) IBOutlet UIImageView *imageTop;
@property (weak, nonatomic) IBOutlet UIImageView *imageFront;
@property (weak, nonatomic) IBOutlet UIImageView *imageBack;
//@property (assign, nonatomic) NSString * techniqueNameID;
@property (assign, nonatomic) NSString * techniqueType;
@property (assign, nonatomic) NSString * genderType;


@property (weak, nonatomic)  UIImage *imageL;
@property (weak, nonatomic)  UIImage *imageR;
@property (weak, nonatomic)  UIImage *imageT;
@property (weak, nonatomic)  UIImage *imageF;
@property (weak, nonatomic)  UIImage *imageB;
@property BOOL isFirstTime;
@property (weak, nonatomic) IBOutlet UIView *screenShotView;
@property (strong, nonatomic)  IBOutlet UIView * toolbar;
@property (strong, nonatomic) IBOutlet UILabel * infoLabel;
@property (strong, nonatomic) IBOutlet UIButton * okButton;
@property (strong, nonatomic) NSTimer *touchTimer;


//-(void)setImagesForLeft:(UIImage*)left rigth:(UIImage*)right top:(UIImage*) front:(UIImage*)front back:(UIImage*)back;
@end

NS_ASSUME_NONNULL_END
