//
//  UIViewController+ColorViewNew.h
//  hairtechapp
//
//  Created by Alexander Prent on 14.01.2023.
//  Copyright © 2023 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ColorViewController.h"

@protocol ColorViewNewdelegate<NSObject>

@end

@interface ColorViewNew : UIViewController <ColorViewControllerDelegate>
{
    ColorViewController * colorController;
}
@property (nonatomic, weak) id <ColorViewNewdelegate> delegate;


@end

