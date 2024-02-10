// ImageCollectionViewCell.h

#import <UIKit/UIKit.h>
@protocol ImageCollectionViewCellDelegate <NSObject>

- (void)deleteCellAtIndexPath:(NSIndexPath *)indexPath;

@end


@interface ImageCollectionViewCell : UICollectionViewCell



@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, weak) id<ImageCollectionViewCellDelegate> delegate;
@property (nonatomic, strong) NSIndexPath *indexPath;

@end
