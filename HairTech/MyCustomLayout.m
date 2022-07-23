/*
#import "MyCustomLayout.h"
#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "DecorationViewLayoutAttributes.h"
@implementation MyCustomLayout


//@synthesize center_cell;

#define ITEM_SIZE 600.0

#define ACTIVE_DISTANCE 200
#define ZOOM_FACTOR 0.0

-(id)init
{
    self = [super init];
    if (self) {
        
    
        self.itemSize = CGSizeMake(400, ITEM_SIZE);
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.sectionInset = UIEdgeInsetsMake(50, 200.0, 50, 200.0);
        self.minimumLineSpacing = 100.0;
    }
    return self;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)oldBounds
{
    return YES;
}

-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray* array = [super layoutAttributesForElementsInRect:rect];
    CGRect visibleRect;
    visibleRect.origin.x = self.collectionView.contentOffset.x;
    visibleRect.origin.y = self.collectionView.contentOffset.y;
    
    
    visibleRect.size.height = self.collectionView.bounds.size.height;
    visibleRect.size.width = self.collectionView.bounds.size.width;
    
    
    for (UICollectionViewLayoutAttributes* attributes in array) {
        if (CGRectIntersectsRect(attributes.frame, rect)) {
            CGFloat distance = CGRectGetMidX(visibleRect) - attributes.center.x;
            CGFloat normalizedDistance = distance / ACTIVE_DISTANCE;
            
            if (ABS(distance) < ACTIVE_DISTANCE) {
                CGFloat zoom = 1 + ZOOM_FACTOR*(1 - ABS(normalizedDistance));
                attributes.transform3D = CATransform3DMakeScale(zoom, zoom, 1.0);
                attributes.zIndex = 1;
            }
            
        }
    }
    return array;
}


- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    CGFloat offsetAdjustment = MAXFLOAT;
    CGFloat horizontalCenter = proposedContentOffset.x + (CGRectGetWidth(self.collectionView.bounds) / 2.0);
    
    CGRect targetRect = CGRectMake(proposedContentOffset.x, 0.0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    NSArray* array = [super layoutAttributesForElementsInRect:targetRect];
    
    for (UICollectionViewLayoutAttributes* layoutAttributes in array) {
        CGFloat itemHorizontalCenter = layoutAttributes.center.x;
        if (ABS(itemHorizontalCenter - horizontalCenter) < ABS(offsetAdjustment)) {
            offsetAdjustment = itemHorizontalCenter - horizontalCenter;
        }
    }
    
    self.center_cell = CGPointMake(proposedContentOffset.x + offsetAdjustment, proposedContentOffset.y);
    
    return CGPointMake(proposedContentOffset.x + offsetAdjustment, proposedContentOffset.y);
}

/*
- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
	CGSize const collectionViewContentSize = self.collectionViewContentSize;
    
		DecorationViewLayoutAttributes *attributes = [DecorationViewLayoutAttributes layoutAttributesForDecorationViewOfKind:kind withIndexPath:indexPath];
		attributes.frame = (CGRect){
			.size.width = collectionViewContentSize.width / 2.,
			.size.height = collectionViewContentSize.height
		};
		attributes.backgroundColor = [UIColor redColor];
		return attributes;
	}*/
//@end
//  SpringboardLayout.m
/

/*
#import "MyCustomLayout.h"
#import "SpringboardLayoutAttributes.h"
#import "ViewController.h"
@implementation MyCustomLayout





@end