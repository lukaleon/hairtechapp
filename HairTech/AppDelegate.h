//
//  AppDelegate.h
//  HairTech
//
//  Created by Admin on 06/11/2012.
//  Copyright (c) 2012 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "MyCustomLayout.h"
#import "FMDBDataAccess.h"
#import "FMDatabaseAdditions.h"

@class MyViewController;

@protocol MyViewControllerDelegate <NSObject>

-(void)saveImageWhenterminate;
-(void)closeAndSave;
-(void)captureScreenRetina;

@end
@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    
    
    //MyCustomLayout *mycustomLayout;
 // UIBarButtonItem *tempButton;
}
@property (weak, nonatomic) id<MyViewControllerDelegate>myviewdelegate;

@property (weak,nonatomic)UIImage *imageToSend;
//@property (strong, nonatomic) EntryViewController *entryViewController;
@property (nonatomic, retain) UIBarButtonItem *tempButton;
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,retain) NSString *myGlobalName;
@property (nonatomic,retain) NSString *NameForTechnique;
@property (nonatomic,assign) NSInteger *checkvalue;
@property (nonatomic,assign) NSInteger *checkwindow;

@property (nonatomic,assign) NSInteger *globalIndex;

@property (nonatomic,assign) NSInteger *checkHead1;
@property (nonatomic,assign) NSInteger *checkHead2;
@property (nonatomic,assign) NSInteger *checkHead3;
@property (nonatomic,assign) NSInteger *checkHead4;
@property (nonatomic,assign) NSInteger *checkHead5;

@property (nonatomic,assign) NSInteger *OkButtonInSubView;
@property (nonatomic,assign) NSInteger *checkEntrywindow;
@property (nonatomic,assign) NSInteger *loadviewCheckButton;

@property (nonatomic,assign) CGSize entryViewSize;

@property (nonatomic, assign) BOOL dashedCurve;


@property (nonatomic,retain) NSString *currentView;

@property (nonatomic,retain) NSString *currentViewName;


@property (nonatomic,assign) CGPoint theFirstPointForRuler;


-(void) createAndCheckDatabase;


@property (strong, nonatomic) NSString *databaseName;
@property (strong, nonatomic) NSString *databasePath;

@property (nonatomic,retain) NSString *globalDate;
@property (nonatomic,retain) NSString *cellNameForDelete;
-(void)changeTheme;
@property (strong, nonatomic) NSIndexPath *cellPath;

@property (strong,nonatomic) NSString * uniqueID;
@property (strong, nonatomic) NSDictionary * dict;
@property (strong, nonatomic) UIImage * imageBtn;
@end
