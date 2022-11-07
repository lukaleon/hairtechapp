//
//  Cell.h
//  HairTech
//
//  Created by Lion on 11/29/12.
//  Copyright (c) 2012 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "ViewController.h"
@class Cell;
@protocol CellDelegate <NSObject>
@optional
- (void)showPopover;
@end


@interface Cell : UICollectionViewCell///<ViewControllerDelegate>
{
    int tapCount;

UIImageView *transparentImage;
}
@property (nonatomic) BOOL isDispensed;

@property (nonatomic, strong) UIButton *deleteButton; // TO UNCOMMENT LATER

@property (weak, nonatomic) IBOutlet UIImageView *transparentImage;
@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) IBOutlet UIImageView *ribbon;

@property (strong, nonatomic) IBOutlet UILabel *labelOne;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) id<CellDelegate> delegatecell;
- (void)setEditing:(BOOL)editing animated:(BOOL)animated;
@property (readonly) BOOL editing;

@property (strong, nonatomic) IBOutlet UIImageView *barImage;

- (IBAction)showEditMenu:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *menuBar;
@property (weak, nonatomic) IBOutlet UIImageView *menuBarExpanded;
@property (weak, nonatomic) IBOutlet UIButton *cell_menu_btn;

@property (weak, nonatomic) IBOutlet UIButton *renameBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
- (IBAction)renamePressed:(id)sender;

- (IBAction)deletePressed:(id)sender;
-(void)showBar;
-(void)hideBar;

@property (weak, nonatomic) NSIndexPath *indexOfCell;
@property (weak, nonatomic) IBOutlet UIImageView *iconTag;

@end

