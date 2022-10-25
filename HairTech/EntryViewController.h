//
//  EntryViewController.h
//  HairTech
//
//  Created by Admin on 15/11/2012.
//  Copyright (c) 2012 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "DrawViewController.h"
//#import "MySubView.h"
//#import "ViewController.h"
#import "UIPopoverListView.h"
//#import "AKPTableViewController.h"

@class EntryViewController;
@class DrawViewController;
@class DrawViewControllerRight;
@class TopHeadViewController;
@class FrontHeadViewController;
@class BackHeadViewController;


@protocol EntryViewControllerDelegate <NSObject>

//-(void) passItemBack:(ViewController *)controller didFinishWithItem:(UIImage*)item;

@end


@interface EntryViewController : UIViewController<UITextFieldDelegate,UIPopoverListViewDataSource, UIPopoverListViewDelegate>//DomainListSelectionDelegate>
{
        
    NSMutableString *entryviewImage;
    NSMutableString *entryviewImageSmall;
    IBOutlet UIButton* loginButton;
    
    __weak IBOutlet UIBarButtonItem *popoverBtn;
    //AKPTableViewController* tbView;
    UIImage *tempimage;
    UIImageView *pictureToMove;
    NSData * data;
    NSData * thumbdata;
    
    CGRect screenRect;
    CGFloat screenWidth;
    CGFloat screenHeight;
    
    
    
    DrawViewController*dcController;
    DrawViewControllerRight*dcControllerRight;
    TopHeadViewController*topController;
    FrontHeadViewController*frontController;
    BackHeadViewController*backController;
}
@property (nonatomic, assign) NSString * appVersion;
//@property (nonatomic,retain)UIImageView * pictureToMove;
//- (IBAction)CopyHeads:(id)sender;

@property (weak,nonatomic) IBOutlet UIImageView * toolbarImg;
//@property (weak,nonatomic) IBOutlet UIImageView * underImage;


@property (weak, nonatomic) IBOutlet UILabel *labelHairTech;
@property (weak, nonatomic) IBOutlet UIButton *backToLib;
@property (weak, nonatomic) IBOutlet UIImageView *barimage;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)setColorButtonTapped:(id)sender;

@property (nonatomic, retain) UIPopoverController *listPopover;
- (IBAction)showHelpView:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *infoBtn;

@property (weak,nonatomic)NSString *sendImagenameToControllers;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) NSString *stringFromTextfield;

@property (weak, nonatomic) IBOutlet UIButton *buttonRightHead;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UIButton *buttonTopHead;
@property (weak, nonatomic) IBOutlet UIButton *buttonFrontHead;
@property (weak, nonatomic) IBOutlet UIButton *buttonBackHead;

@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backbtn;

@property (weak,nonatomic)UIImage *entryImage1;
@property (weak,nonatomic)UIImage *entryImage2;
@property (weak,nonatomic)UIImage *entryImage3;
@property (weak,nonatomic)UIImage *entryImage4;
@property (weak,nonatomic)UIImage *entryImage5;


@property (weak,nonatomic)UIImage *screenshot;
@property (weak, nonatomic) id <EntryViewControllerDelegate> delegate1;
-(void)showImageFirst;
-(void)hideBar;
-(void)showBar;

-(IBAction)showPopoverForRating:(id)sender;

- (IBAction)drawView:(id)sender;
- (IBAction)drawViewRight:(id)sender;
- (IBAction)drawViewTop:(id)sender;
- (IBAction)drawViewFront:(id)sender;
- (IBAction)drawViewBack:(id)sender;

@end

 
