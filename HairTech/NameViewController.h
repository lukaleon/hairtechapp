//
//  ViewController+NameViewController.h
//  hairtech
//
//  Created by Alexander Prent on 05.11.2022.
//  Copyright © 2022 Admin. All rights reserved.
//

#import "ViewController.h"

NS_ASSUME_NONNULL_BEGIN




@interface  NameViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *continue_btn;
@property (weak, nonatomic) IBOutlet UIButton *fem_btn;
@property (weak, nonatomic) IBOutlet UIButton *male_btn;
- (IBAction)headPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@property (weak, nonatomic) IBOutlet UIImageView *progressBar;

@end

NS_ASSUME_NONNULL_END
