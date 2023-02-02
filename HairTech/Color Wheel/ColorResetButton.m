//
//  UIButton+ColorResetButton.m
//  hairtech
//
//  Created by Alexander Prent on 30.01.2023.
//  Copyright © 2023 Admin. All rights reserved.
//

#import "ColorResetButton.h"

@implementation ColorResetButton



-(CGPoint)menuAttachmentPointForConfiguration:(UIContextMenuConfiguration *)configuration{
    
   // self.offset = CGPointZero;
    
    CGPoint original = [super menuAttachmentPointForConfiguration:configuration];
    
    return CGPointMake(original.x + self.offset.x, original.y + self.offset.y);
}


@end
