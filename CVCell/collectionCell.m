//
//  UICollectionViewCell+collectionCell.m
//  hairtech
//
//  Created by Alexander Prent on 17.11.2022.
//  Copyright © 2022 Admin. All rights reserved.
//

#import "collectionCell.h"

@implementation collectionCell

- (void)awakeFromNib{
    [super awakeFromNib];
    NSLog(@"nibnib");
}
//
//-(instancetype) initWithCoder: (NSCoder *)aDecoder{
//self = [super initWithCoder: aDecoder];
//
//        if (self)
//        {
//    [self customInit];
//}
//return self;
//}
//
//-(instancetype)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self){
//        [self customInit];
//    }
// return self;
//}
//
//-(void)customInit{
//[[NSBundle mainBundle] loadNibNamed:@"collectionCell" owner:self options:nil];
// [self addSubview:self.contentView];
// self.contentView.frame = self.bounds;
//}
@end
