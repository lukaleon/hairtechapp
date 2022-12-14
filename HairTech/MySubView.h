//
//  MySubView.h
//  HairTech
//
//  Created by Lion on 12/2/12.
//  Copyright (c) 2012 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"
#import "Technique.h"
#import "ViewController.h"
//#import "EntryViewController.h"

@class MySubView;
@protocol MySubViewDelegate <NSObject>



-(void)MySubViewController:(MySubView *) controller didAddCustomer:(Technique *) technique;

-(void) passItemBack:(MySubView *)controller didFinishWithItem:(NSString*)item;
-(void) saveData:(NSString *)namefortech;
- (void)reloadMyCollection;
-(void)openEntry;
-(void)refreshVC;

@end

@interface MySubView :  UIViewController <UITextFieldDelegate>

{
    BOOL edit;
    BOOL pressedOk;
    
    NSString *nameForExistFile;
    NSMutableString *exfoothumb;
    ViewController *viewcontroller;
    NSString * uuid;
    
}

@property (assign, nonatomic) NSString * maleOrFemale;
@property (nonatomic,strong) Technique *techniqueAdd;

@property (nonatomic,strong) Technique *techniqueToEdit;

@property(nonatomic,strong)NSIndexPath *indexpath;
@property (weak,nonatomic) IBOutlet UIImageView * imageOfheads;

-(BOOL) validate:(Technique *) c;

@property (strong, nonatomic) NSString *nameForExistFile;
@property (strong, nonatomic)  NSMutableString *exfoothumb;
@property (nonatomic,retain) ViewController *viewcontroller;
- (IBAction)cancelSubview:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *labeltest;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) NSString *stringFromSubview;
- (IBAction)closeSubView:(id)sender;
@property (weak, nonatomic) id<MySubViewDelegate>delegate;
@property (strong,nonatomic) NSMutableString *convertedLabel;
@property (weak, nonatomic) IBOutlet UILabel *labelLong;


@property (weak, nonatomic) IBOutlet UIButton *male_btn;
@property (weak, nonatomic) IBOutlet UIButton *female_btn;
- (IBAction)MF_selected:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *doneBtn;

@property (weak, nonatomic) IBOutlet UIImageView *progressBar;

@end
