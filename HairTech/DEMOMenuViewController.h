//
//  DEMOMenuViewController.h
//  REFrostedViewControllerExample
//
//  Created by Roman Efimov on 9/18/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "REFrostedViewController.h"


@interface DEMOMenuViewController : REFrostedViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, readwrite, nonatomic) UIViewController *viewController;

@end
