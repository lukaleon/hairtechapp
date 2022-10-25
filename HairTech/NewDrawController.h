//
//  ViewController+NewDrawController.h
//  hairtech
//
//  Created by Alexander Prent on 18.10.2022.
//  Copyright © 2022 Admin. All rights reserved.
//

#import "ViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface NewDrawController : UIViewController{
    IBOutlet UIScrollView *scrollView;
    NSMutableArray * arrayOfGrids;
    UIButton * grid;

}
@property (nonatomic, assign) NSString * labelText;
@property (nonatomic, assign) NSString * imgName;
@property (weak, nonatomic) IBOutlet UIImageView *img;

@end

NS_ASSUME_NONNULL_END
