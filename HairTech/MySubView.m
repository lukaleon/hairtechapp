//
//  MySubView.m
//  HairTech
//
//  Created by Lion on 12/2/12.
//  Copyright (c) 2012 Admin. All rights reserved.
//

#import "MySubView.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "NameViewController.h"
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
  
    UIColor *color = [UIColor colorNamed:@"textWhiteDeepBlue"];
      self.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"diagram name" attributes:@{NSForegroundColorAttributeName: color}];
    self.textField.layer.cornerRadius = 8;
    
    arrayOfTechnique = [[NSMutableArray alloc]init];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.OkButtonInSubView=0;
    [self.imageOfheads.layer setShadowOffset:CGSizeMake(0, 2)];
    [self.imageOfheads.layer setShadowColor:[[UIColor darkGrayColor] CGColor]];
    [self.imageOfheads.layer setShadowRadius:8.0f];
    [self.imageOfheads.layer setShadowOpacity:0.9];
    
    [self setCloseButton];
    [self setAppearanceOfElements];
}

-(void)setAppearanceOfElements{
    self.progressBar.layer.cornerRadius = 2;
    self.doneBtn.layer.cornerRadius = 22;
  
    //self.doneBtn.alpha = 0.6;
   // self.doneBtn.enabled = NO;

    
}
-(void)viewDidAppear:(BOOL)animated{
    self.textField.delegate = self;
    [self.textField becomeFirstResponder];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"Male female %@", self.maleOrFemale);
    appDelegate.globalDate = self.maleOrFemale;
}

-(void)setCloseButton{
    UIButton *rightCustomButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [rightCustomButton addTarget:self
                         action:@selector(closeView)
               forControlEvents:UIControlEventTouchUpInside];
    [rightCustomButton.widthAnchor constraintEqualToConstant:30].active = YES;
    [rightCustomButton.heightAnchor constraintEqualToConstant:30].active = YES;

    [rightCustomButton setImage:[UIImage imageNamed:@"Close.png"] forState:UIControlStateNormal];
    UIBarButtonItem * rightButtonItem =[[UIBarButtonItem alloc] initWithCustomView:rightCustomButton];
    self.navigationItem.rightBarButtonItems = @[rightButtonItem];

}

-(void)closeView{
    pressedOk = NO;
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
/*- (IBAction)MF_selected:(id)sender{
    
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
}*/
-(void)viewDidDisappear:(BOOL)animated
{
   // if(pressedOkButton == YES)
    {

       // [self.delegate passItemBack:self didFinishWithItem:self.textField.text];
      /*  [[NSNotificationCenter defaultCenter]
         postNotificationName:@"openEntry"
         object:self];
//        [self.navigationController popToRootViewControllerAnimated:YES];*/

      //  [self.delegate openEntry];
     
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

- (NSString*)createNameFromUUID:(NSString*)filetype identifier:(NSString*)uuidTemp {
    NSMutableString * newString = [uuidTemp mutableCopy];
    newString = [newString mutableCopy];
    [newString appendString:filetype];
    newString = [newString mutableCopy];
    [newString appendString:@".png"];
    return newString;
}

-(void)closeSubViewManually
{
    uuid = [[NSUUID UUID] UUIDString];
    NSLog(@"uuid = %@", uuid);
    
    pressedOkButton=YES;
    pressedOk = YES;
    [self.delegate passItemBack:self didFinishWithItem:self.textField.text];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    ViewController *viewcontroller = [[ViewController alloc]init];
    viewcontroller.label.text=self.textField.text;
    viewcontroller.delegate1=self;
    appDelegate.NameForTechnique = self.textField.text;
    appDelegate.uniqueID = uuid;
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
    appDelegate.checkvalue = 0;
    

   
    Technique *technique = [[Technique alloc] init];
    technique.techniquename = self.textField.text;
    technique.date = self.maleOrFemale; // newest version
    technique.techniqueimage = [self createNameFromUUID:@"Entry" identifier:uuid];
    technique.techniqueimagethumb1 = [self createNameFromUUID:@"thumb1" identifier:uuid];
    technique.techniqueimagethumb2 = [self createNameFromUUID:@"thumb2" identifier:uuid];
    technique.techniqueimagethumb3 = [self createNameFromUUID:@"thumb3" identifier:uuid];
    technique.techniqueimagethumb4 = [self createNameFromUUID:@"thumb4" identifier:uuid];
    technique.techniqueimagethumb5 = [self createNameFromUUID:@"thumb5" identifier:uuid];
    technique.techniqueimagebig1 = [self createNameFromUUID:@"big1" identifier:uuid];
    technique.techniqueimagebig2 = [self createNameFromUUID:@"big2" identifier:uuid];
    technique.techniqueimagebig3 = [self createNameFromUUID:@"big3" identifier:uuid];
    technique.techniqueimagebig4 = [self createNameFromUUID:@"big4" identifier:uuid];
    technique.techniqueimagebig5 = [self createNameFromUUID:@"big5" identifier:uuid];
    technique.uniqueId = uuid;

    if(![self validate:technique])
    {
        [Utility showAlert:@"Error" message:@"Validation Failed!"];
        return;
    }

    FMDBDataAccess *db = [[FMDBDataAccess alloc] init];
    [db insertCustomer:technique];
    
    [self createJSON:[self createFileNameJSON:technique.uniqueId headtype:@"lefthead"]];
    [self createJSON:[self createFileNameJSON:technique.uniqueId headtype:@"righthead"]];
    [self createJSON:[self createFileNameJSON:technique.uniqueId headtype:@"tophead"]];
    [self createJSON:[self createFileNameJSON:technique.uniqueId headtype:@"fronthead"]];
    [self createJSON:[self createFileNameJSON:technique.uniqueId headtype:@"backhead"]];

    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"populate"
     object:self];
   
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"reloadCollection"
     object:self];
    
    [self dismissViewControllerAnimated:YES completion:nil];

    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"openEntry"
     object:self];
}


- (void)createJSON:(NSMutableString*)filename{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,  NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:filename];
    NSString* str = @"[]";
    NSData* data = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:appFile]) {
        [[NSFileManager defaultManager] createFileAtPath:appFile contents:data attributes:nil];
    }
}
-(NSMutableString *)createFileNameJSON:(NSString*)fileName headtype:(NSString*)type{
    NSMutableString * newString = [fileName mutableCopy];
    newString = [newString mutableCopy];
    [newString appendString:type];
    newString = [newString mutableCopy];
    [newString appendString:@".json"];
    return newString;
}

-(BOOL) validate:(Technique *)c
{
    if([c.techniquename length] == 0)
    {
        return NO;
    }
    return YES;
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
    
    if(![self checkEnteredName]&&(![self checkNameLength])&&![self checkNameForSpecialSymbols]){
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
    
    

    NSLog(@"close close");
   // UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:];
    //NameViewController * nameVC = [self.storyboard instantiateViewControllerWithIdentifier:@"NameViewController"];
    //[self.navigationController pushViewController:nameVC animated:YES];

}

- (IBAction)cancelSubview:(id)sender
{
    pressedOk = NO;
    pressedCancelButton = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (NSMutableString *)createFileName:(NSString *)fileName prefix:(NSString*)prefix{
    NSMutableString *filenamethumb = [fileName mutableCopy];
    filenamethumb = [filenamethumb mutableCopy];
    [filenamethumb appendString: prefix];
    return filenamethumb;
}

-(void)copyXFiles
{

    NSMutableString * cellImage = [self createFileName:uuid prefix:@"Entry.png"];
    NSMutableString * filenamethumb1 = [self createFileName:uuid prefix:@"thumb1.png"];
    NSMutableString * filenamethumb2 = [self createFileName:uuid prefix:@"thumb2.png"];
    NSMutableString * filenamethumb3 = [self createFileName:uuid prefix:@"thumb3.png"];
    NSMutableString * filenamethumb4 = [self createFileName:uuid prefix:@"thumb4.png"];
    NSMutableString * filenamethumb5 = [self createFileName:uuid prefix:@"thumb5.png"];
    
    [self copyFileFromBundleToDocs:@"uiimage_cell_x.png"];
    [self copyFileFromBundleToDocs:@"lefthead_s.png"];
    [self copyFileFromBundleToDocs:@"righthead_s.png"];
    [self copyFileFromBundleToDocs:@"tophead_s.png"];
    [self copyFileFromBundleToDocs:@"backhead_s.png"];
    [self copyFileFromBundleToDocs:@"fronthead_s.png"];
    
    [self changeFileName:@"uiimage_cell_x.png" to:cellImage];
    [self changeFileName:@"lefthead_s.png" to:filenamethumb1];
    [self changeFileName:@"righthead_s.png" to:filenamethumb2];
    [self changeFileName:@"tophead_s.png" to:filenamethumb3];
    [self changeFileName:@"fronthead_s.png" to:filenamethumb4];
    [self changeFileName:@"backhead_s.png" to:filenamethumb5];
    
}
/*--------------------------MEN_HEADS-------------------------*/

-(void)copyXFilesMEN
{
    NSMutableString * cellImage = [self createFileName:uuid prefix:@"Entry.png"];
    NSMutableString * filenamethumb1 = [self createFileName:uuid prefix:@"thumb1.png"];
    NSMutableString * filenamethumb2 = [self createFileName:uuid prefix:@"thumb2.png"];
    NSMutableString * filenamethumb3 = [self createFileName:uuid prefix:@"thumb3.png"];
    NSMutableString * filenamethumb4 = [self createFileName:uuid prefix:@"thumb4.png"];
    NSMutableString * filenamethumb5 = [self createFileName:uuid prefix:@"thumb5.png"];
    
    [self copyFileFromBundleToDocs:@"men-full-11.png"];
    [self copyFileFromBundleToDocs:@"lefthead_ms.png"];
    [self copyFileFromBundleToDocs:@"righthead_ms.png"];
    [self copyFileFromBundleToDocs:@"tophead_ms.png"];
    [self copyFileFromBundleToDocs:@"backhead_ms.png"];
    [self copyFileFromBundleToDocs:@"fronthead_ms.png"];
    
    [self changeFileName:@"men-full-11.png" to:cellImage];
    [self changeFileName:@"lefthead_ms.png" to:filenamethumb1];
    [self changeFileName:@"righthead_ms.png" to:filenamethumb2];
    [self changeFileName:@"tophead_ms.png" to:filenamethumb3];
    [self changeFileName:@"fronthead_ms.png" to:filenamethumb4];
    [self changeFileName:@"backhead_ms.png" to:filenamethumb5];
}

@end
