//
//  UIViewController+OldCollectionView.h
//  hairtech
//
//  Created by Alexander Prent on 10.01.2023.
//  Copyright © 2023 Admin. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "Technique.h"
#import "sqlite3.h"
#import "EntryViewController.h"
#import "MyCustomLayout.h"
#import "toolbar_view.h"
#import "FMDBDataAccess.h"
#import "HMPopUpView.h"
#import "OldCell.h"


@class EntryViewController;
@class OldCollectionViewDelegate;
@class OldCollectionView;

@protocol OldCollectionViewDelegate <NSObject>
-(void)changeImageAlphaBack;
-(void)changeImageAlpha;
//- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
//;
-(void)setImagesInEC:(OldCollectionView*)controller didFinishWithItem1:(UIImage*)item1 didFinishWithItem2:(UIImage*)item2 didFinishWithItem3:(UIImage*)item3 didFinishWithItem4:(UIImage*)item4 didFinishWithItem5:(UIImage*)item5;
@end

@interface OldCollectionView : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate,HMPopUpViewDelegate,CellDelegate, CellDelegate>{
   // buttonImage *buttonImageClass;
    
    IBOutlet UILongPressGestureRecognizer *longpresscell;
    NSUInteger *renameIndexPath;
    NSIndexPath * indexOfSelectedCell;
    NSUInteger indexForDelete;
    
    CKDatabase * database;

}

@property (nonatomic, strong) NSArray *fetchedTechniques;

@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *indicatorView;

@property (nonatomic,strong) UIButton *addHeadsheet;
@property  BOOL isSelectionActivated;

@property (weak, nonatomic) IBOutlet UIImageView *shadowLayer;

@property (weak, nonatomic) IBOutlet UIButton *sidemenuButton;

@property (nonatomic,strong) NSMutableArray *techniques;

//@property (strong, readwrite, nonatomic) DEMOMenuViewController *menuViewController;
@property (nonatomic, strong) NSMutableIndexSet *optionIndices;
@property (weak,nonatomic) IBOutlet UIToolbar *toolbar_view;
@property (weak,nonatomic) IBOutlet UIImageView * toolbarImg;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addTechnique;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *baritemtrash;
@property NSIndexPath* tappedCellPath;
@property (nonatomic,retain) UIPopoverController *listPopover;

@property (nonatomic, assign) NSInteger cellCount;
@property (nonatomic,assign) BOOL *emptyArray;

@property (nonatomic, retain) NSIndexPath *selectedIndexPath;
@property (nonatomic,assign)NSInteger *delegatevalue;

@property (strong,nonatomic) NSMutableString *convertedLabel;
@property (strong,nonatomic)NSString *sendImagenameToControllers;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong,nonatomic)UIImage *image1;
@property (strong,nonatomic)UIImage *image2;
@property (strong,nonatomic)UIImage *image3;
@property (strong,nonatomic)UIImage *image4;
@property (strong,nonatomic)UIImage *image5;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) NSString *stringFromTextfield;

- (IBAction)activateDeletionMode:(id)sender;
- (IBAction)showSideMenu:(id)sender;


@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButtonOutlet;


- (void)saveData;

- (void)openItemInEntryViewController:(UIStoryboardSegue *)segue;

- (void)openSubView;

@property (weak, nonatomic) id<OldCollectionViewDelegate>delegate2;

@property BOOL *tapcopy;

@property (nonatomic, assign) Mode collectionMode;


//-(void)setupInfoButton:(NSString*)imgName selector:(NSString*)method;
//-(void)setupRightNavigationItem:(NSString*)btnTitle selector:(NSString*)method;
//-(void)reloadMyCollection;
//-(void)setupLongPressGestures;
//- (void)didReceiveMemoryWarning;
@end
