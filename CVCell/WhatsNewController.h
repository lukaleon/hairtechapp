//
//  ViewController+WhatsNewController.h
//  hairtech
//
//  Created by Alexander Prent on 18.11.2022.
//  Copyright © 2022 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WhatsNewController : UIViewController 

@property (weak, nonatomic) IBOutlet UILabel * label;
@property (weak, nonatomic) IBOutlet UIButton * btn;
- (IBAction)closeView:(id)sender;
@end

NS_ASSUME_NONNULL_END
