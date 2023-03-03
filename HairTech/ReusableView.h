//
//  UICollectionReusableView+ReusableView.h
//  hairtech
//
//  Created by Alexander Prent on 10.01.2023.
//  Copyright © 2023 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@class ReusableViewDelegate;
@protocol ReusableViewDelegate <NSObject>

-(void)sortCollectionView:(NSString*)key;

@end


@interface ReusableView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
- (IBAction)sortPressed:(id)sender;
@property (weak, nonatomic) id<ReusableViewDelegate> delegate;
- (void)segmentChangeOnLoad:(NSString*)key;
@property NSString * segmentedControlValue;
-(void)segmentChangeFromCloud:(NSString*)key;

@end

NS_ASSUME_NONNULL_END
