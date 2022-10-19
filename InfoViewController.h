//
//  ViewController+infoViewController.h
//  hairtech
//
//  Created by Alexander Prent on 06.10.2022.
//  Copyright © 2022 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface InfoViewController : UIViewController
- (IBAction)share:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;

@end

NS_ASSUME_NONNULL_END
