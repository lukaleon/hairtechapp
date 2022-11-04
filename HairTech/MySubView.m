//
//  MySubView.m
//  HairTech
//
//  Created by Lion on 12/2/12.
//  Copyright (c) 2012 Admin. All rights reserved.
//

#import "MySubView.h"
#import <QuartzCore/QuartzCore.h>
//#import "ViewController.h"
#import "AppDelegate.h"
@interface MySubView()
{
    NSMutableArray *arrayOfTechnique;
    sqlite3 *techniqueDB;
    NSString *dbPathString;
    NSString *convertedLabel;
    BOOL *pressedCancelButton;
    BOOL *pressedOkButton;

    NSMutableString *foothumb1;
    NSMutableString *foothumb2;
    NSMutableString *foothumb3;
    NSMutableString *foothumb4;
    NSMutableString *foothumb5;
    NSMutableString *foothumbCell;

    
    
    NSMutableArray *imgName;
    NSMutableString *foothumb_0;
    NSMutableString *foothumb_1;
    NSMutableString *foothumb_2;
    NSMutableString *foothumb_3;
    NSMutableString *foothumb_4;
    NSMutableString *foothumb_5;
    NSMutableString *foobig1;
    NSMutableString *foobig2;
    NSMutableString *foobig3;
    NSMutableString *foobig4;
    NSMutableString *foobig5;
    
   }
@end

@implementation MySubView
@synthesize textField;
@synthesize labeltest,indexpath;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidLoad
{
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.textField becomeFirstResponder];
    self.textField.delegate = self;
    UIColor *color = [UIColor colorNamed:@"deepblue"];
      self.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"diagram name" attributes:@{NSForegroundColorAttributeName: color}];
    
    arrayOfTechnique = [[NSMutableArray alloc]init];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.OkButtonInSubView=0;
    [self.imageOfheads.layer setShadowOffset:CGSizeMake(0, 2)];
    [self.imageOfheads.layer setShadowColor:[[UIColor darkGrayColor] CGColor]];
    [self.imageOfheads.layer setShadowRadius:8.0f];
    [self.imageOfheads.layer setShadowOpacity:0.9];
}

- (IBAction)MF_selected:(id)sender{
    
    UIButton * PressedButton = (UIButton*)sender;
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    switch(PressedButton.tag)
    {
        case 0:
            appDelegate.globalDate = @"men22";
            self.maleOrFemale = @"men22";
            self.female_btn.selected=NO;
            self.male_btn.selected=YES;
            break;
        case 1:
            appDelegate.globalDate = @"version22";
            self.maleOrFemale = @"version22";
            self.male_btn.selected=NO;
            self.female_btn.selected=YES;

            break;
    }
}
-(void)viewDidDisappear:(BOOL)animated
{
    NSLog(@"View did Dissapear name == : %@.",foothumb1);
    if(pressedOkButton == YES)
    {
        [self.delegate passItemBack:self didFinishWithItem:self.textField.text];
        [self.delegate  openEntry];
        NSLog(@"GOING TO OPEN OPENENTRY");
    }
}


- (BOOL)disablesAutomaticKeyboardDismissal {
    return NO;
}

-(BOOL)checkNameForSpecialSymbols {
    
    NSLog(@"This CHECKER.");

    NSString *string = self.textField.text;

    NSString *specialCharacterString = @"!~`@#$%^&*+();:={}[],<>?\\/\"\'";
    NSCharacterSet *specialCharacterSet = [NSCharacterSet
                                           characterSetWithCharactersInString:specialCharacterString];
    if ([string.lowercaseString rangeOfCharacterFromSet:specialCharacterSet].length) {
        NSLog(@"contains special characters");
        return YES;
    } else {
        return NO;
    }
}

-(BOOL)checkEnteredName{
    
    NSMutableString *bfcol1 =@"thumb1";
    foothumb1 = self.textField.text;
    foothumb1 = [self.textField.text mutableCopy];
    [foothumb1 appendString:bfcol1];
    foothumb1= [foothumb1 mutableCopy];
    [foothumb1 appendString:@".png"];
    NSLog(@"Результат in textfield: %@.",foothumb1);
    
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSString *foofile = [documentsPath stringByAppendingPathComponent:foothumb1];
    BOOL fileExist = [[NSFileManager defaultManager] fileExistsAtPath:foofile];
    return fileExist;
}

-(BOOL)checkNameLength{
    
    BOOL zeroLenght;
    
    if(textField.text.length==0){
        
        zeroLenght=true;
    }else{
        
        zeroLenght=false;
    }
    
    return zeroLenght;
    
}

/////////-------- Return text from UITextField -------------------/////
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
   
    
    if ([self checkEnteredName] )
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning!"
                                                        message:@"The technique with such name exists"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
        [self checkEnteredName];
    }
    if (![self checkEnteredName]){
    [self closeSubViewManually];
    return [textField resignFirstResponder];
    }
    
}

-(void)copyFileFromBundleToDocs:(NSString*)fileName {
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [documentPaths objectAtIndex:0];
    NSLog(@"documentsDir:%@",documentsDir);
    
    NSError *error = nil;
    
    if ([filemgr fileExistsAtPath: [documentsDir stringByAppendingPathComponent:fileName] ] == YES) {
        NSLog (@"File exists, done");
    } else {
        NSLog (@"File not found, copying next.");
        if([filemgr copyItemAtPath:[[NSBundle mainBundle] pathForResource:fileName ofType:@""] toPath:[documentsDir stringByAppendingPathComponent:fileName] error:&error]){
            NSLog(@"File successfully copied to:%@",documentsDir);
        } else {
            NSLog(@"Error description - %@ \n", [error localizedDescription]);
            NSLog(@"Error reason - %@", [error localizedFailureReason]);
        }
    }
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
}
-(void)changeFileName:(NSString *)filename to:(NSString*)newFileName
{
    NSError *error;
    
    // Create file manager
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [documentPaths objectAtIndex:0];

    // Point to Document directory
 //   NSString *documentsDirectory = [NSDocumentDirectory()
                              //      stringByAppendingPathComponent:@"Documents"];

    NSString *filePath2 = [documentsDirectory
                           stringByAppendingPathComponent:newFileName];
    
    
    NSString *filePath =[documentsDirectory
                         stringByAppendingPathComponent:filename];
    // Attempt the move
    if ([fileMgr moveItemAtPath:filePath toPath:filePath2 error:&error] != YES)
        NSLog(@"Unable to move file: %@", [error localizedDescription]);
    
    // Show contents of Documents directory
    NSLog(@"Documents directory: %@",
          [fileMgr contentsOfDirectoryAtPath:documentsDirectory error:&error]);
}

-(void)closeSubViewManually
{
    pressedOkButton=YES;
    [self.delegate passItemBack:self didFinishWithItem:self.textField.text];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    ViewController *viewcontroller = [[ViewController alloc]init];
    viewcontroller.label.text=self.textField.text;
    viewcontroller.delegate1=self;
    appDelegate.NameForTechnique=self.textField.text;
    [self.delegate passItemBack:self didFinishWithItem:self.textField.text];
    
    if([appDelegate.globalDate isEqualToString:@"version22"]){
                [self copyXFiles];
    }
    /*-----------------MEN_HEADS-----------------------*/
    if([appDelegate.globalDate isEqualToString:@"men22"]){
           [self copyXFilesMEN];
       }
    
    appDelegate.checkwindow = 1;
    appDelegate.checkEntrywindow = 1;
    appDelegate.OkButtonInSubView = 1;
    appDelegate.checkvalue=0;
    
    self.convertedLabel =self.textField.text;
    
    NSMutableString *bfcol =@"Entry";
    foothumb_0 =self.convertedLabel;
    foothumb_0 = [self.convertedLabel mutableCopy];
    [foothumb_0 appendString:bfcol];
    foothumb_0= [foothumb_0 mutableCopy];
    [foothumb_0 appendString:@".png"];
    NSLog(@"Результат in vc: %@.",foothumb_0);
    
    /////-----------Name for  thumbimage1 ---------------//////////
    
    self.convertedLabel =self.textField.text;
    
    NSMutableString *bf1 =@"thumb1";
    foothumb_1 =self.convertedLabel;
    foothumb_1 = [self.convertedLabel mutableCopy];
    [foothumb_1 appendString:bf1];
    foothumb_1= [foothumb_1 mutableCopy];
    [foothumb_1 appendString:@".png"];
    NSLog(@"Результат in vc: %@.",foothumb_1);
    /////-----------Name for  thumbimage2 ---------------//////////
    
    self.convertedLabel =self.textField.text;
    
    NSMutableString *bf2 =@"thumb2";
    foothumb_2 =self.convertedLabel;
    foothumb_2 = [self.convertedLabel mutableCopy];
    [foothumb_2 appendString:bf2];
    foothumb_2= [foothumb_2 mutableCopy];
    [foothumb_2 appendString:@".png"];
    NSLog(@"Результат in vc: %@.",foothumb_2);
    
    /////-----------Name for  thumbimage3 ---------------//////////
    self.convertedLabel =self.textField.text;
    NSMutableString *bf3 =@"thumb3";
    foothumb_3 =self.convertedLabel;
    foothumb_3 = [self.convertedLabel mutableCopy];
    [foothumb_3 appendString:bf3];
    foothumb_3= [foothumb_3 mutableCopy];
    [foothumb_3 appendString:@".png"];
    NSLog(@"Результат in vc: %@.",foothumb_3);
    
    /////-----------Name for  thumbimage1 ---------------//////////
    self.convertedLabel =self.textField.text;
    NSMutableString *bf4 =@"thumb4";
    foothumb_4 =self.convertedLabel;
    foothumb_4 = [self.convertedLabel mutableCopy];
    [foothumb_4 appendString:bf4];
    foothumb_4= [foothumb_4 mutableCopy];
    [foothumb_4 appendString:@".png"];
    NSLog(@"Результат in vc: %@.",foothumb_4);
    
    /////-----------Name for  thumbimage5 ---------------//////////
    self.convertedLabel =self.textField.text;
    NSMutableString *bf5 =@"thumb5";
    foothumb_5 =self.convertedLabel;
    foothumb_5 = [self.convertedLabel mutableCopy];
    [foothumb_5 appendString:bf5];
    foothumb_5= [foothumb_5 mutableCopy];
    [foothumb_5 appendString:@".png"];
    NSLog(@"Результат in vc: %@.",foothumb_5);
    
    /////-----------Name for  bigimage1 ---------------//////////
    self.convertedLabel =self.textField.text;
    NSMutableString *bfb1 =@"big1";
    foobig1 =self.convertedLabel;
    foobig1 = [self.convertedLabel mutableCopy];
    [foobig1 appendString:bfb1];
    foobig1= [foobig1 mutableCopy];
    [foobig1 appendString:@".png"];
    NSLog(@"Результат in vc: %@.",foobig1);
    
    /////-----------Name for  bigimage2---------------//////////
    self.convertedLabel =self.textField.text;
    NSMutableString *bfb2 =@"big2";
    foobig2 =self.convertedLabel;
    foobig2 = [self.convertedLabel mutableCopy];
    [foobig2 appendString:bfb2];
    foobig2= [foobig2 mutableCopy];
    [foobig2 appendString:@".png"];
    NSLog(@"Результат in vc: %@.",foobig2);
    
    /////-----------Name for  bigimage3---------------//////////
    self.convertedLabel =self.textField.text;
    NSMutableString *bfb3 =@"big3";
    foobig3 =self.convertedLabel;
    foobig3 = [self.convertedLabel mutableCopy];
    [foobig3 appendString:bfb3];
    foobig3= [foobig3 mutableCopy];
    [foobig3 appendString:@".png"];
    NSLog(@"Результат: %@.",foobig3);
    
    /////-----------Name for  bigimage4---------------//////////
    self.convertedLabel =self.textField.text;
    NSMutableString *bfb4 =@"big4";
    foobig4 =self.convertedLabel;
    foobig4 = [self.convertedLabel mutableCopy];
    [foobig4 appendString:bfb4];
    foobig4= [foobig4 mutableCopy];
    [foobig4 appendString:@".png"];
    NSLog(@"Результат: %@.",foobig4);
    
    /////-----------Name for  bigimage5---------------//////////
    self.convertedLabel =self.textField.text;
    NSMutableString *bfb5 =@"big5";
    foobig5 =self.convertedLabel;
    foobig5 = [self.convertedLabel mutableCopy];
    [foobig5 appendString:bfb5];
    foobig5= [foobig5 mutableCopy];
    [foobig5 appendString:@".png"];
    NSLog(@"Результат: %@.",foobig5);
    
    Technique *technique = [[Technique alloc] init];
    technique.techniquename = self.textField.text;
    NSLog(@"MALEFEMALE %@ ", self.maleOrFemale);
    technique.date = self.maleOrFemale; // newest version
    technique.techniqueimage = foothumb_0;
    technique.techniqueimagethumb1=foothumb_1;
    technique.techniqueimagethumb2=foothumb_2;
    technique.techniqueimagethumb3=foothumb_3;
    technique.techniqueimagethumb4=foothumb_4;
    technique.techniqueimagethumb5=foothumb_5;
    technique.techniqueimagebig1=foobig1;
    technique.techniqueimagebig2=foobig2;
    technique.techniqueimagebig3=foobig3;
    technique.techniqueimagebig4=foobig4;
    technique.techniqueimagebig5=foobig5;

    if(![self validate:technique])
    {
        [Utility showAlert:@"Error" message:@"Validation Failed!"];
        return;
    }
    [self.delegate MySubViewController:self didAddCustomer:technique];
    NSLog(@"JUST ADDED NEW TECHNIQUE");
    NSLog(@"JUST ADDED NEW TECHNIQUE = %@", technique.techniquename);
    [self.delegate  reloadMyCollection];
    pressedCancelButton=NO;
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(BOOL) validate:(Technique *)c
{
    if([c.techniquename length] == 0)
    {
        return NO;
    }
    return YES;
}



-(void)copyAndRenameFiles
{
    NSMutableString *bfcol0 =@"Entry";
    foothumbCell =self.textField.text;
    foothumbCell = [self.textField.text mutableCopy];
    [foothumbCell appendString:bfcol0];
    foothumbCell= [foothumbCell mutableCopy];
    [foothumbCell appendString:@".png"];
    NSLog(@"Результат: %@.",foothumbCell);
    
    
    
    NSMutableString *bfcol1 =@"thumb1";
    foothumb1 =self.textField.text;
    foothumb1 = [self.textField.text mutableCopy];
    [foothumb1 appendString:bfcol1];
    foothumb1= [foothumb1 mutableCopy];
    [foothumb1 appendString:@".png"];
    NSLog(@"Результат: %@.",foothumb1);
    
    NSMutableString *bfcol2 =@"thumb2";
    foothumb2 =self.textField.text;
    foothumb2 = [self.textField.text mutableCopy];
    [foothumb2 appendString:bfcol2];
    foothumb2= [foothumb2 mutableCopy];
    [foothumb2 appendString:@".png"];
    NSLog(@"Результат: %@.",foothumb2);
    
    NSMutableString *bfcol3 =@"thumb3";
    foothumb3 =self.textField.text;
    foothumb3 = [self.textField.text mutableCopy];
    [foothumb3 appendString:bfcol3];
    foothumb3= [foothumb3 mutableCopy];
    [foothumb3 appendString:@".png"];
    NSLog(@"Результат: %@.",foothumb3);
    
    NSMutableString *bfcol4 =@"thumb4";
    foothumb4 =self.textField.text;
    foothumb4 = [self.textField.text mutableCopy];
    [foothumb4 appendString:bfcol4];
    foothumb4= [foothumb4 mutableCopy];
    [foothumb4 appendString:@".png"];
    NSLog(@"Результат: %@.",foothumb4);
    
    
    NSMutableString *bfcol5 =@"thumb5";
    foothumb5 =self.textField.text;
    foothumb5 = [self.textField.text mutableCopy];
    [foothumb5 appendString:bfcol5];
    foothumb5= [foothumb5 mutableCopy];
    [foothumb5 appendString:@".png"];
    NSLog(@"Результат: %@.",foothumb5);
    
    
    
    [self copyFileFromBundleToDocs:@"uiimage_cell.png"];
    [self copyFileFromBundleToDocs:@"btn_lefthead.png"];
    [self copyFileFromBundleToDocs:@"btn_righthead.png"];
    [self copyFileFromBundleToDocs:@"btn_tophead.png"];
    [self copyFileFromBundleToDocs:@"btn_backhead.png"];
    [self copyFileFromBundleToDocs:@"btn_fronthead.png"];
    
    [self changeFileName:@"uiimage_cell.png" to:foothumbCell];
    [self changeFileName:@"btn_lefthead.png" to:foothumb1];
    [self changeFileName:@"btn_righthead.png" to:foothumb2];
    [self changeFileName:@"btn_tophead.png" to:foothumb3];
    [self changeFileName:@"btn_fronthead.png" to:foothumb4];
    [self changeFileName:@"btn_backhead.png" to:foothumb5];

}

-(void)copyAndRenameRetinaFiles
{
    NSMutableString *bfcol0 =@"Entry";
    foothumbCell =self.textField.text;
    foothumbCell = [self.textField.text mutableCopy];
    [foothumbCell appendString:bfcol0];
    foothumbCell= [foothumbCell mutableCopy];
    [foothumbCell appendString:@".png"];
    NSLog(@"Результат: %@.",foothumbCell);
    
    
    
    NSMutableString *bfcol1 =@"thumb1";
    foothumb1 =self.textField.text;
    foothumb1 = [self.textField.text mutableCopy];
    [foothumb1 appendString:bfcol1];
    foothumb1= [foothumb1 mutableCopy];
    [foothumb1 appendString:@".png"];
    NSLog(@"Результат: %@.",foothumb1);
    
    NSMutableString *bfcol2 =@"thumb2";
    foothumb2 =self.textField.text;
    foothumb2 = [self.textField.text mutableCopy];
    [foothumb2 appendString:bfcol2];
    foothumb2= [foothumb2 mutableCopy];
    [foothumb2 appendString:@".png"];
    NSLog(@"Результат: %@.",foothumb2);
    
    NSMutableString *bfcol3 =@"thumb3";
    foothumb3 =self.textField.text;
    foothumb3 = [self.textField.text mutableCopy];
    [foothumb3 appendString:bfcol3];
    foothumb3= [foothumb3 mutableCopy];
    [foothumb3 appendString:@".png"];
    NSLog(@"Результат: %@.",foothumb3);
    
    NSMutableString *bfcol4 =@"thumb4";
    foothumb4 =self.textField.text;
    foothumb4 = [self.textField.text mutableCopy];
    [foothumb4 appendString:bfcol4];
    foothumb4= [foothumb4 mutableCopy];
    [foothumb4 appendString:@".png"];
    NSLog(@"Результат: %@.",foothumb4);
    
    
    NSMutableString *bfcol5 =@"thumb5";
    foothumb5 =self.textField.text;
    foothumb5 = [self.textField.text mutableCopy];
    [foothumb5 appendString:bfcol5];
    foothumb5= [foothumb5 mutableCopy];
    [foothumb5 appendString:@".png"];
    NSLog(@"Результат: %@.",foothumb5);
    
    
    
    [self copyFileFromBundleToDocs:@"uiimage_cell@2x.png"];
    [self copyFileFromBundleToDocs:@"btn_lefthead@2x.png"];
    [self copyFileFromBundleToDocs:@"btn_righthead@2x.png"];
    [self copyFileFromBundleToDocs:@"btn_tophead@2x.png"];
    [self copyFileFromBundleToDocs:@"btn_backhead@2x.png"];
    [self copyFileFromBundleToDocs:@"btn_fronthead@2x.png"];
    
    [self changeFileName:@"uiimage_cell@2x.png" to:foothumbCell];
    [self changeFileName:@"btn_lefthead@2x.png" to:foothumb1];
    [self changeFileName:@"btn_righthead@2x.png" to:foothumb2];
    [self changeFileName:@"btn_tophead@2x.png" to:foothumb3];
    [self changeFileName:@"btn_fronthead@2x.png" to:foothumb4];
    [self changeFileName:@"btn_backhead@2x.png" to:foothumb5];
    
}


#pragma mark -Close SubView methods
- (IBAction)closeSubView:(id)sender {
    
    
    if([self checkEnteredName])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning!"
                                                        message:@"The technique with this name exists already"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
        [self checkEnteredName];
    }
    
    
    
    if([self checkNameLength])
    {
        UIAlertView *alert2 = [[UIAlertView alloc] initWithTitle:@"Warning!"
                                                        message:@"This field can't be empty!"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert2 show];
        [self checkNameLength];
    }
    
    if(![self checkButtonSelected])
       {
           UIAlertView *alert3 = [[UIAlertView alloc] initWithTitle:@"Warning!"
                                                           message:@"Please, select male or female heads!"
                                                          delegate:nil
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles: nil];
           [alert3 show];
           [self checkButtonSelected];
       }
    
    
    
    if(![self checkEnteredName]&&(![self checkNameLength])&&[self checkButtonSelected]&&![self checkNameForSpecialSymbols]){
       [self closeSubViewManually];
    }
    
    if ([self checkNameForSpecialSymbols]) {
        
        UIAlertView *alert4 = [[UIAlertView alloc] initWithTitle:@"Warning!"
                                                        message:@"This string contains illegal characters"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert4 show];
        [self checkNameForSpecialSymbols];
    }
    
    

}

-(BOOL)checkButtonSelected{
    
    BOOL buttonSelected;
    if(!(self.female_btn.state == UIControlStateSelected)&&(!(self.male_btn.state == UIControlStateSelected))){
        buttonSelected = false;
    }
    else {
        buttonSelected = true;
    }
    return buttonSelected;
}

- (IBAction)cancelSubview:(id)sender
{
    
    pressedCancelButton=YES;
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
///////////////////////*************************************************/////////////////////////

-(void)copyXFiles
{
    NSMutableString *bfcol0 =@"Entry";
    foothumbCell =self.textField.text;
    foothumbCell = [self.textField.text mutableCopy];
    [foothumbCell appendString:bfcol0];
    foothumbCell= [foothumbCell mutableCopy];
    [foothumbCell appendString:@".png"];
    NSLog(@"Результат: %@.",foothumbCell);
    
    
    
    NSMutableString *bfcol1 =@"thumb1";
    foothumb1 =self.textField.text;
    foothumb1 = [self.textField.text mutableCopy];
    [foothumb1 appendString:bfcol1];
    foothumb1= [foothumb1 mutableCopy];
    [foothumb1 appendString:@".png"];
    NSLog(@"Результат: %@.",foothumb1);
    
    NSMutableString *bfcol2 =@"thumb2";
    foothumb2 =self.textField.text;
    foothumb2 = [self.textField.text mutableCopy];
    [foothumb2 appendString:bfcol2];
    foothumb2= [foothumb2 mutableCopy];
    [foothumb2 appendString:@".png"];
    NSLog(@"Результат: %@.",foothumb2);
    
    NSMutableString *bfcol3 =@"thumb3";
    foothumb3 =self.textField.text;
    foothumb3 = [self.textField.text mutableCopy];
    [foothumb3 appendString:bfcol3];
    foothumb3= [foothumb3 mutableCopy];
    [foothumb3 appendString:@".png"];
    NSLog(@"Результат: %@.",foothumb3);
    
    NSMutableString *bfcol4 =@"thumb4";
    foothumb4 =self.textField.text;
    foothumb4 = [self.textField.text mutableCopy];
    [foothumb4 appendString:bfcol4];
    foothumb4= [foothumb4 mutableCopy];
    [foothumb4 appendString:@".png"];
    NSLog(@"Результат: %@.",foothumb4);
    
    
    NSMutableString *bfcol5 =@"thumb5";
    foothumb5 =self.textField.text;
    foothumb5 = [self.textField.text mutableCopy];
    [foothumb5 appendString:bfcol5];
    foothumb5= [foothumb5 mutableCopy];
    [foothumb5 appendString:@".png"];
    NSLog(@"Результат: %@.",foothumb5);
    
    
    
    [self copyFileFromBundleToDocs:@"uiimage_cell_x.png"];
    [self copyFileFromBundleToDocs:@"btn_lefthead_x.png"];
    [self copyFileFromBundleToDocs:@"btn_righthead_x.png"];
    [self copyFileFromBundleToDocs:@"btn_tophead_x.png"];
    [self copyFileFromBundleToDocs:@"btn_backhead_x.png"];
    [self copyFileFromBundleToDocs:@"btn_fronthead_x.png"];
    
    [self changeFileName:@"uiimage_cell_x.png" to:foothumbCell];
    [self changeFileName:@"btn_lefthead_x.png" to:foothumb1];
    [self changeFileName:@"btn_righthead_x.png" to:foothumb2];
    [self changeFileName:@"btn_tophead_x.png" to:foothumb3];
    [self changeFileName:@"btn_fronthead_x.png" to:foothumb4];
    [self changeFileName:@"btn_backhead_x.png" to:foothumb5];
    
}
/*--------------------------MEN_HEADS-------------------------*/

-(void)copyXFilesMEN
{
    NSMutableString *bfcol0 =@"Entry";
    foothumbCell =self.textField.text;
    foothumbCell = [self.textField.text mutableCopy];
    [foothumbCell appendString:bfcol0];
    foothumbCell= [foothumbCell mutableCopy];
    [foothumbCell appendString:@".png"];
    NSLog(@"Результат: %@.",foothumbCell);
    
    
    
    NSMutableString *bfcol1 =@"thumb1";
    foothumb1 =self.textField.text;
    foothumb1 = [self.textField.text mutableCopy];
    [foothumb1 appendString:bfcol1];
    foothumb1= [foothumb1 mutableCopy];
    [foothumb1 appendString:@".png"];
    NSLog(@"Результат: %@.",foothumb1);
    
    NSMutableString *bfcol2 =@"thumb2";
    foothumb2 =self.textField.text;
    foothumb2 = [self.textField.text mutableCopy];
    [foothumb2 appendString:bfcol2];
    foothumb2= [foothumb2 mutableCopy];
    [foothumb2 appendString:@".png"];
    NSLog(@"Результат: %@.",foothumb2);
    
    NSMutableString *bfcol3 =@"thumb3";
    foothumb3 =self.textField.text;
    foothumb3 = [self.textField.text mutableCopy];
    [foothumb3 appendString:bfcol3];
    foothumb3= [foothumb3 mutableCopy];
    [foothumb3 appendString:@".png"];
    NSLog(@"Результат: %@.",foothumb3);
    
    NSMutableString *bfcol4 =@"thumb4";
    foothumb4 =self.textField.text;
    foothumb4 = [self.textField.text mutableCopy];
    [foothumb4 appendString:bfcol4];
    foothumb4= [foothumb4 mutableCopy];
    [foothumb4 appendString:@".png"];
    NSLog(@"Результат: %@.",foothumb4);
    
    
    NSMutableString *bfcol5 =@"thumb5";
    foothumb5 =self.textField.text;
    foothumb5 = [self.textField.text mutableCopy];
    [foothumb5 appendString:bfcol5];
    foothumb5= [foothumb5 mutableCopy];
    [foothumb5 appendString:@".png"];
    NSLog(@"Результат: %@.",foothumb5);
    
    
    
    [self copyFileFromBundleToDocs:@"men-full-11.png"];
    [self copyFileFromBundleToDocs:@"men-left-11-sm.png"];
    [self copyFileFromBundleToDocs:@"men-right-11-sm.png"];
    [self copyFileFromBundleToDocs:@"men-top-11-sm.png"];
    [self copyFileFromBundleToDocs:@"men-back-11-sm.png"];
    [self copyFileFromBundleToDocs:@"men-front-11-sm.png"];
    
    [self changeFileName:@"men-full-11.png" to:foothumbCell];
    [self changeFileName:@"men-left-11-sm.png" to:foothumb1];
    [self changeFileName:@"men-right-11-sm.png" to:foothumb2];
    [self changeFileName:@"men-top-11-sm.png" to:foothumb3];
    [self changeFileName:@"men-front-11-sm.png" to:foothumb4];
    [self changeFileName:@"men-back-11-sm.png" to:foothumb5];
    
}




@end
