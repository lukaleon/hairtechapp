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
@property (weak, nonatomic) IBOutlet UIImageView *imageLeft;
@property (weak, nonatomic) IBOutlet UIImageView *imageRight;
@property (weak, nonatomic) IBOutlet UIImageView *imageTop;
@property (weak, nonatomic) IBOutlet UIImageView *imageFront;
@property (weak, nonatomic) IBOutlet UIImageView *imageBack;

@end

NS_ASSUME_NONNULL_END
