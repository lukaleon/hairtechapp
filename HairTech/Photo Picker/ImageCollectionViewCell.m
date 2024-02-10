// ImageCollectionViewCell.m

#import "ImageCollectionViewCell.h"

@implementation ImageCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        [self.contentView addSubview:_imageView];
        
        [self.contentView.layer setCornerRadius:15.0f];
        self.clipsToBounds = YES;
        self.contentView.layer.masksToBounds = YES;
//        self.layer.shadowColor = [UIColor blackColor].CGColor;
//        self.layer.shadowOffset = CGSizeMake(0,0);
//        self.layer.shadowRadius = 3.0f;
//        self.layer.shadowOpacity = 0.1f;
//        self.layer.masksToBounds = NO;
        
        
        // Enable context menu interaction
//                if (@available(iOS 13.0, *)) {
//                    UIContextMenuInteraction *interaction = [[UIContextMenuInteraction alloc] initWithDelegate:self];
//                    [self.contentView addInteraction:interaction];
//                }
       
    }
    return self;
}

// MARK: - UIContextMenuInteractionDelegate
/*
- (UIContextMenuConfiguration *)contextMenuInteraction:(UIContextMenuInteraction *)interaction configurationForMenuAtLocation:(CGPoint)location {
    return [UIContextMenuConfiguration configurationWithIdentifier:nil
                                                        previewProvider:nil
                                                         actionProvider:^UIMenu * _Nullable(NSArray<UIMenuElement *> * _Nonnull suggestedActions) {
        NSLog(@"IndexPath: %@", self.indexPath);
        // Create and return your custom UIMenu here
        UIAction *action = [UIAction actionWithTitle:@"Delete" image:nil identifier:nil handler:^(UIAction * _Nonnull action) {
            // Handle the action
            
           // CGPoint point = [interaction locationInView:self.collectionView];
//            NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point];
            
            
        
            NSLog(@"Custom action tapped");
            if (self.delegate && [self.delegate respondsToSelector:@selector(deleteCellAtIndexPath:)]) {
                           [self.delegate deleteCellAtIndexPath:self.indexPath];
                        }
        }];
        UIMenu *menu = [UIMenu menuWithTitle:@"" children:@[action]];
        return menu;
    }];
}
*/
@end
