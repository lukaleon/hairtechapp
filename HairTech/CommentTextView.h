//
//  CommentTextView.h
//  CommentTextViewTest
//
//  Created by Szabolcs Sztanyi on 01/04/15.
//  Copyright (c) 2015 Szabolcs Sztanyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentTextView : UITextView
{}
- (void)setPlaceHolderLabelVisible:(BOOL)visible;
@property (nonatomic, strong) UILabel *placeHolderLabel;
- (void)setText:(NSString *)text;
@end
