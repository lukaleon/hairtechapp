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
#import "Hairtech-Bridging-Header.h"
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
    FMDBDataAccess *db = [[FMDBDataAccess alloc] init];
    arrayOfTechnique = [db getCustomers];

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

-(void)getArrayOfFilesInDirectory{
    self.filesArraysubView = [NSMutableArray array];
    NSArray * dirs = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] error:NULL];
    [self.filesArraysubView removeAllObjects];
    [dirs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *filename = (NSString *)obj;
        NSString *extension = [[filename pathExtension] lowercaseString];
        if ([extension isEqualToString:@"htapp"]) {
            [self.filesArraysubView addObject:filename];
            NSLog(@"filename in appdelegate %@ ", filename );
        }
    }];
}

-(NSMutableDictionary*)getImportedFileData:(NSData*)data error:(NSError **)outError {

    NSMutableDictionary * tempDict = [NSKeyedUnarchiver unarchivedObjectOfClass:[NSObject class] fromData:data error:outError];
    
    return tempDict;
}
-(NSMutableDictionary*)openFileAtPath:(NSString*)fileName error:(NSError **)outError {

    NSArray *sysPaths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
    NSString *docDirectory = [sysPaths objectAtIndex:0];
    NSString *filePath = [docDirectory stringByAppendingPathComponent:fileName];
    
    NSURL * url = [NSURL fileURLWithPath:filePath];
    NSData *data = [NSData dataWithContentsOfURL:url];

    NSMutableDictionary * tempDict = [NSKeyedUnarchiver unarchivedObjectOfClass:[NSObject class] fromData:data error:outError];
    
    return tempDict;
}

-(BOOL)checkEnteredName{
    BOOL techniqueExist;
    [self getArrayOfFilesInDirectory];
    for(int i = 0; i < self.filesArraysubView.count; i++){
        
        NSMutableDictionary * dictOfData = [self openFileAtPath:[self.filesArraysubView objectAtIndex:i] error:nil];
        NSLog(@" technique name in array %@", [dictOfData objectForKey:@"techniqueName"]);

        if([self.textField.text isEqualToString:[dictOfData objectForKey:@"techniqueName"]]){
        techniqueExist = YES;
            break;
        }else {
        techniqueExist = NO;

        }
    }
//    for(Technique * tech in arrayOfTechnique){
//        if([textField.text isEqual:tech.techniquename]){
//            techniqueExist = YES;
//            NSLog(@"technique exists");
//
//            break;
//        }
//        else {
//            techniqueExist = NO;
//            NSLog(@"technique NOT exists");
//        }
//    }
    return techniqueExist;
   
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

- (NSString*)createNameFromUUID:(NSString*)uuid{
    NSMutableString * fileName = [uuid mutableCopy];
    [fileName appendString:@".htapp"];
    return fileName;
}

-(void)closeSubViewManually
{
    uuid = [[NSUUID UUID] UUIDString];
    [self saveDiagramToFile:uuid techniqueName:self.textField.text maleOrFemale:self.maleOrFemale];
    
    [[NSUserDefaults standardUserDefaults] setObject:[self createNameFromUUID:self.textField.text] forKey:@"newCreatedFileName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
 

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
-(NSString*)currentDate{
    NSDate *date = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateStyle:NSDateFormatterMediumStyle]; // day, Full month and year
    [df setTimeStyle:NSDateFormatterNoStyle];  // nothing
    NSString *dateString = [df stringFromDate:date];
    return dateString;
}

- (NSData*)createJSON:(NSMutableString*)filename{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,  NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:filename];
    NSString* str = @"[]";
    NSData* data = [str dataUsingEncoding:NSUTF8StringEncoding];
    return data;
//    if (![[NSFileManager defaultManager] fileExistsAtPath:appFile]) {
//        [[NSFileManager defaultManager] createFileAtPath:appFile contents:data attributes:nil];
//    }
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
                                                        message:@"Diagram with this name exists"
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

-(void)saveDiagramToFile:(NSString*)uuid  techniqueName:(NSString*)techName maleOrFemale:(NSString*)maleOrFemale  {
    
    
    NSMutableString * exportingFileName = [techName mutableCopy];
    [exportingFileName appendString:@".htapp"];
    
    NSArray *sysPaths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
    NSString *docDirectory = [sysPaths objectAtIndex:0];
    NSString *filePath = [docDirectory stringByAppendingPathComponent:exportingFileName];
    NSData * data = [self dataOfType:filePath error:nil uuid:uuid fileName:exportingFileName techniqueName:techName maleOrFemale:maleOrFemale];
    // Save it into file system
    [data writeToFile:filePath atomically:YES];
   // NSURL * url = [NSURL fileURLWithPath:filePath];
    
    
    
//    [[[NSFileManager alloc]init]setUbiquitous:YES itemAtURL:url destinationURL:[self ubiquitousDocumentsDirectoryURL] error:nil];
   // [self copyFileToICloud:url];
}



//- (NSURL *)localPathForResource:(NSString *)resource ofType:(NSString *)type {
//    NSString *documentsDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
//    NSString *resourcePath = [[documentsDirectory stringByAppendingPathComponent:resource] stringByAppendingPathExtension:type];
//    return [NSURL fileURLWithPath:resourcePath];
//}



-(NSURL*)ubiquitousContainerURL {
    return [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil];
}
-(NSURL*)ubiquitousDocumentsDirectoryURL {
    return [[self ubiquitousContainerURL] URLByAppendingPathComponent:@"Documents"];
}

-(void)copyToCloud:(NSURL*)url name:(NSString*)backupName{
    NSFileManager *fm = [NSFileManager defaultManager];

    NSURL *ubiq = [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil];

    if (ubiq == nil) {
        return;
    }

    NSError *theError = nil;

    [fm setUbiquitous:true itemAtURL:url destinationURL:[[ubiq URLByAppendingPathComponent:@"Documents" isDirectory:true] URLByAppendingPathComponent:backupName] error:&theError];
}


//-(void)createiCloudFolder{
//
//    NSURL *iCloudDocumentsURL = [[[NSFileManager defaultManager]URLForUbiquityContainerIdentifier:nil] URLByAppendingPathComponent:@"Documents"];
//
//   if(![[NSFileManager defaultManager] fileExistsAtPath:iCloudDocumentsURL.path isDirectory:nil]){
//        [[NSFileManager defaultManager] createDirectoryAtURL:iCloudDocumentsURL withIntermediateDirectories:YES attributes:nil error:nil];
//       NSLog(@" create Directory");
//
//    }
//
//
//   }
//
//-(void)copyDocumentsToiCloudDrive{
//    NSArray * array = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
//    NSURL *localDocumentsURL = array[0];
//
//    NSError * error;
//    NSURL * iCloudDocumentsURL =  [[[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil] URLByAppendingPathComponent:@"Documents"];
////    [[NSFileManager defaultManager] removeItemAtURL:iCloudDocumentsURL error:&error];
//[[NSFileManager defaultManager] copyItemAtURL:localDocumentsURL toURL:iCloudDocumentsURL error:&error];
//
//    NSLog(@"%@",error.localizedDescription);
//
//    }


-(NSData*)storeJsonDataInDictionary{
    NSString* str = @"[]";
    NSData* data = [str dataUsingEncoding:NSUTF8StringEncoding];
    //NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    return data;
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError uuid:(NSString*)uuid fileName:(NSString*)name techniqueName:(NSString*)techniqueName maleOrFemale:(NSString*)maleOrFem{
    NSError *error = nil;
    NSData * fileName1;
    NSData * fileName2;
    NSData * fileName3;
    NSData * fileName4;
    NSData * fileName5;
    NSData * fileNameEntry;
    
    if ([maleOrFem isEqualToString:@"female"]){
        fileName1 = [self storeImagesInDictionary:@"lefthead_s"];
        fileName2 = [self storeImagesInDictionary:@"righthead_s"];
        fileName3 = [self storeImagesInDictionary:@"tophead_s"];
        fileName4 = [self storeImagesInDictionary:@"fronthead_s"];
        fileName5 = [self storeImagesInDictionary:@"backhead_s"];
       fileNameEntry = [self storeImagesInDictionary:@"uiimage_cell_x"];
    }
    if ([maleOrFem isEqualToString:@"male"]){
        fileName1 = [self storeImagesInDictionary:@"lefthead_ms"];
        fileName2 = [self storeImagesInDictionary:@"righthead_ms"];
        fileName3 = [self storeImagesInDictionary:@"tophead_ms"];
        fileName4 = [self storeImagesInDictionary:@"fronthead_ms"];
        fileName5 = [self storeImagesInDictionary:@"backhead_ms"];
       fileNameEntry = [self storeImagesInDictionary:@"men-full-11"];
    }

    NSData * fileNameJSON1 = [self storeJsonDataInDictionary];
    NSData * fileNameJSON2 = [self storeJsonDataInDictionary];
    NSData * fileNameJSON3 = [self storeJsonDataInDictionary];
    NSData * fileNameJSON4 = [self storeJsonDataInDictionary];
    NSData * fileNameJSON5 = [self storeJsonDataInDictionary];
    
    NSString * filename = uuid;
    NSString * techName = techniqueName;
    NSString * maleOrFemale = maleOrFem;
    
    NSString * creationDate = [self currentDate];
    NSString * modificationDate = [self currentDate];
    NSString * favorite = @"default";
    NSString * note = @"";


    
    if ([typeName isEqualToString:typeName]) {
        //Create a Dictionary
        NSMutableDictionary * dictToSave = [NSMutableDictionary dictionary];
        
        [dictToSave setObject:fileNameEntry forKey:@"imageEntry"];
        [dictToSave setObject:fileName1  forKey:@"imageLeft"];
        [dictToSave setObject:fileName2  forKey:@"imageRight"];
        [dictToSave setObject:fileName3  forKey:@"imageTop"];
        [dictToSave setObject:fileName4  forKey:@"imageFront"];
        [dictToSave setObject:fileName5  forKey:@"imageBack"];
        
        [dictToSave setObject:fileNameJSON1  forKey:@"jsonLeft"];
        [dictToSave setObject:fileNameJSON2  forKey:@"jsonRight"];
        [dictToSave setObject:fileNameJSON3  forKey:@"jsonTop"];
        [dictToSave setObject:fileNameJSON4  forKey:@"jsonFront"];
        [dictToSave setObject:fileNameJSON5  forKey:@"jsonBack"];

        [dictToSave setObject:techName forKey:@"techniqueName"];
        [dictToSave setObject:filename forKey:@"uuid"];
        [dictToSave setObject:maleOrFemale forKey:@"maleFemale"];
        [dictToSave setObject:creationDate forKey:@"creationDate"];
        [dictToSave setObject:modificationDate forKey:@"modificationDate"];
        [dictToSave setObject:favorite forKey:@"favorite"];
        [dictToSave setObject:note forKey:@"note"];


        
          //Return the archived data
        return [NSKeyedArchiver archivedDataWithRootObject:dictToSave requiringSecureCoding:NO error:&error];
    }
    //Don't generate an error
    outError = NULL;
    return nil;
}


-(NSData*)storeImagesInDictionary:(NSString*)imageToStore{

    NSString* documentsDir = [[NSBundle mainBundle] pathForResource:imageToStore ofType:@"png"];
    NSLog(@"documentsDir:%@",documentsDir);
    UIImage * imgData = [UIImage imageWithContentsOfFile:documentsDir];
    NSData * data = UIImagePNGRepresentation(imgData);
    return data;
}

@end
