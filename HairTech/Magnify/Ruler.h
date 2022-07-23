//
//  Ruler.h
//  hairtech
//
//  Created by Alexander Prent on 03.06.2022.
//  Copyright © 2022 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface Ruler : UIWindow

@property (nonatomic) UIView *viewToShowRuler;
@property (nonatomic) CGPoint pointToShowRuler;
@property (nonatomic) CGPoint thePointOfStart;

@property (nonatomic) CGFloat x_axis;
@property (nonatomic) CGFloat y_axis;

@end

