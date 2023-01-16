//
//  ViewController.m
//  HairTech
//
//  Created by Lion on 11/29/12.
//  Copyright (c) 2012 Admin. All rights reserved.
//
#import "EntryViewController.h"
#import "REFrostedViewController.h"
#import "ViewController.h"
#import "LoadingViewController.h"
//#import "Cell.h"
#import "MySubView.h"
#import "AppDelegate.h"
#import "MyCustomLayout.h"
#import "HapticHelper.h"
#import "NameViewController.h"
#import "TODetailTableViewController.h"
#import "Hairtech-Bridging-Header.h"
#import "TemporaryDictionary.h"
#import "ReusableView.h"
//#import "Flurry.h"

//NSString *kEntryViewControllerID = @"EntryViewController";    // view controller storyboard id
NSString *kCellID = @"cellID";                          // UICollectionViewCell storyboard id
NSString *nameOfTechniqueforControllers;

#define TRANSFORM_CELL_VALUE CGAffineTransformMakeScale(0.8, 0.8)
#define ANIMATION_SPEED 0.2



#define IDIOM    UI_USER_INTERFACE_IDIOM()
#define IPAD     UIUserInterfaceIdiomPad

#define colorCombination1 [UIColor colorNamed:@"blue"];
#define colorCombination2 [UIColor colorNamed:@"blue"];
#define colorCombination3 [UIColor colorNamed:@"blue"];
#define colorCombination4 [UIColor colorNamed:@"blue"];
#define colorCombination5 [UIColor colorNamed:@"blue"];
#define colorCombination6 [UIColor colorNamed:@"blue"];




@interface ViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIGestureRecognizerDelegate,UICollectionViewDelegateFlowLayout>
{

    UIActionSheet *actionSheet;
    UITapGestureRecognizer* tapRecognizer;
    NSMutableArray *arrayOfTechnique;
    sqlite3 *techniqueDB;
    NSString *dbPathString;
    NSMutableArray *imgName;
    NSInteger *lastAddedItem;
    NSMutableString *foothumb;
    NSMutableString *foothumb1;
    NSMutableString *foothumb2;
    NSMutableString *foothumb3;
    NSMutableString *foothumb4;
    NSMutableString *foothumb5;
    NSMutableString *foobig1;
    NSMutableString *foobig2;
    NSMutableString *foobig3;
    NSMutableString *foobig4;
    NSMutableString *foobig5;
    UILabel *current_technique;
    UIImage *imageForCell;
    NSString *myString;
    NSArray *cell_sysPaths;
    NSString *cell_docDirectory;
    NSString *cell_filePath;
    BOOL *tap;
    int i;
    NSString*tempstring;
    NSIndexPath*indexpathtemp;
    
    NSMutableString *rfoothumb;
    NSMutableString *rfoothumb1;
    NSMutableString *rfoothumb2;
    NSMutableString *rfoothumb3;
    NSMutableString *rfoothumb4;
    NSMutableString *rfoothumb5;
    NSMutableString *rfoobig1;
    NSMutableString *rfoobig2;
    NSMutableString *rfoobig3;
    NSMutableString *rfoobig4;
    NSMutableString *rfoobig5;
   
    
}

@end

@implementation ViewController


BOOL isDeletionModeActive; // TO UNCOMMENT LATER

-(void)viewDidDisappear:(BOOL)animated
{
    [self.collectionView removeGestureRecognizer:tapRecognizer];
    [self reloadMyCollection];
    
}

-(void) saveFloatToUserDefaults:(float)x forKey:(NSString *)key {
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setFloat:x forKey:key];
    [userDefaults synchronize];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];

    NSUserDefaults *sharedDefaults = [NSUserDefaults standardUserDefaults];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger countValue = [defaults integerForKey:@"Array"];
    
    if ([sharedDefaults boolForKey:@"FirstLaunch"])
    {
        [self saveColorsToDefaults];
        [self saveFloatToUserDefaults:0.0 forKey:@"eraserPressed"];
        
[self openSubView:self];
        [sharedDefaults setBool:NO forKey:@"FirstLaunch"];
        [sharedDefaults synchronize];

        // [prefs synchronize];
    }	// Do any additional setup after loading the view.
    else if(countValue == 1)
    {
    }
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
    if ( ![userDefaults valueForKey:@"version"] )
    {
        [self saveColorsToDefaults];
        [self saveFloatToUserDefaults:0.0 forKey:@"eraserPressed"];
        
        // Adding version number to NSUserDefaults for first version:
        [userDefaults setFloat:[[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] floatValue] forKey:@"version"];
    }

    if ([[NSUserDefaults standardUserDefaults] floatForKey:@"version"] == [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] floatValue] )
    {
        // Same Version so dont run the function
    }
    else
    {
        // Call Your Function;
        // Update version number to NSUserDefaults for other versions:
        [userDefaults setFloat:[[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] floatValue] forKey:@"version"];
    }
  }

-(void)saveColorsToDefaults{
    
    UIColor *dottedLine =  [UIColor colorWithRed:35.0/255.0 green:145.0/255.0 blue:72.0/255.0 alpha:1.0];
    UIColor *penColor =  [UIColor colorWithRed:128.0/255.0 green:0.0/255.0 blue:128.0/255.0 alpha:1.0];
    UIColor *arrowColor =  [UIColor colorWithRed:242.0/255.0 green:56.0/255.0 blue:56.0/255.0 alpha:1.0];
    UIColor *blueLine =  [UIColor colorWithRed:17.0/255.0 green:104.0/255.0 blue:217.0/255.0 alpha:1.0];
    UIColor *solidLine =  [UIColor colorWithRed:41.0/255.0 green:47.0/255.0 blue:64.0/255.0 alpha:1.0];

    
    const CGFloat  *components2 = CGColorGetComponents(dottedLine.CGColor);
    const CGFloat  *components3 = CGColorGetComponents(arrowColor.CGColor);
    const CGFloat  *components4 = CGColorGetComponents(solidLine.CGColor);
    const CGFloat  *components5 = CGColorGetComponents(blueLine.CGColor);
    const CGFloat  *components6 = CGColorGetComponents(penColor.CGColor);
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    [prefs setFloat:components2[0]  forKey:@"cr2"];
    [prefs setFloat:components2[1]  forKey:@"cg2"];
    [prefs setFloat:components2[2]  forKey:@"cb2"];
    [prefs setFloat:components2[3]  forKey:@"ca2"];
    
    [prefs setFloat:components3[0]  forKey:@"cr3"];
    [prefs setFloat:components3[1]  forKey:@"cg3"];
    [prefs setFloat:components3[2]  forKey:@"cb3"];
    [prefs setFloat:components3[3]  forKey:@"ca3"];
    
    [prefs setFloat:components4[0]  forKey:@"cr4"];
    [prefs setFloat:components4[1]  forKey:@"cg4"];
    [prefs setFloat:components4[2]  forKey:@"cb4"];
    [prefs setFloat:components4[3]  forKey:@"ca4"];
    
   [prefs setFloat:components5[0]  forKey:@"cr5"];
    [prefs setFloat:components5[1]  forKey:@"cg5"];
    [prefs setFloat:components5[2]  forKey:@"cb5"];
    [prefs setFloat:components5[3]  forKey:@"ca5"];
    
    [prefs setFloat:components6[0]  forKey:@"cr6"];
    [prefs setFloat:components6[1]  forKey:@"cg6"];
    [prefs setFloat:components6[2]  forKey:@"cb6"];
    [prefs setFloat:components6[3]  forKey:@"ca6"];

    
    [prefs synchronize];
    NSLog(@"I just saved colors");
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self getArrayOfFilesInDirectory];
   
    
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [self.collectionView  reloadData];
    [self setupNavigationBar];
    self.isSelectionActivated = NO;
    longpresscell.enabled = YES;
}

-(void)openInfoController{
    
   TODetailTableViewController  * viewController = [self.storyboard  instantiateViewControllerWithIdentifier:@"tableView"];
    [self.navigationController pushViewController:viewController animated:YES];
}


- (void)addNewTechniqueButton {
    self.addHeadsheet = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.addHeadsheet addTarget:self
               action:@selector(openSubView:)
     forControlEvents:UIControlEventTouchUpInside];
    self.addHeadsheet.backgroundColor = [UIColor clearColor];
    self.addHeadsheet.adjustsImageWhenHighlighted = NO;
    UIImage *img = [UIImage imageNamed:@"addnewtech.png"];
    [self.addHeadsheet setImage:img forState:UIControlStateNormal];
    [self.addHeadsheet setImage:[UIImage imageNamed:@"addnewtech.png"] forState:UIControlStateHighlighted];
   // [button setBackgroundColor:[UIColor whiteColor]];
    self.addHeadsheet.frame = CGRectMake(self.view.frame.origin.x + self.view.frame.size.width/2 - 25,
                              self.view.frame.origin.y + self.view.frame.size.height - 100, 50 , 50);
    self.addHeadsheet.layer.masksToBounds = YES;
    self.addHeadsheet.layer.cornerRadius = self.addHeadsheet.frame.size.height / 2;
    [self.view addSubview:self.addHeadsheet];
}

- (void)setupNavigationBar{
    [self setupInfoButton:@"info_b.png" selector:@"openInfoController"];
    [self setupRightNavigationItem:@"Select" selector:@"selectionActivated"];
    if(filesArray.count == 0){
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}
-(void)viewDidLoad
{
    filesArray = [NSMutableArray array];

    
    [self setupLongPressGestures];
    
    self.view.backgroundColor = [UIColor colorNamed:@"grey"];
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
        [appearance configureWithOpaqueBackground];
        appearance.backgroundColor = [UIColor colorNamed:@"navBar"];
        appearance.shadowColor =  [UIColor clearColor];
        appearance.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor colorNamed:@"textWhiteDeepBlue"], NSFontAttributeName:[UIFont fontWithName:@"AvenirNext-Bold" size:18]};
        self.navigationController.navigationBar.standardAppearance = appearance;
        self.navigationController.navigationBar.scrollEdgeAppearance = appearance;
        [self.navigationController prefersStatusBarHidden];
    
    }
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification:)
                                                 name:@"showPop"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification2:)
                                                 name:@"hideAllBars"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification3:)
                                                 name:@"showDeletePop"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(shareDiagram)
                                                 name:@"shareDiagram"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(insertExportedDataFromAppDelegate)
                                                 name:@"insertExportedDataFromAppDelegate"
                                               object:nil];
    
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    self.navigationItem.title = @"Collection";
    
    // Bottom Border
    [super viewDidLoad];
    [self.sidemenuButton setAlpha:0];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"MY_CELL"];
   

    
    [self.toolbar_view setClipsToBounds:YES];
    [self.collectionView setBackgroundColor:[UIColor clearColor]];
    tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    tapRecognizer.delegate=self;
    i = 0;
    tap = NO;
    [self addNewTechniqueButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(openEntry)
                                                 name:@"openEntry"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadMyCollection)
                                                 name:@"reloadCollection"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(populateAndReload)
                                                 name:@"populate"
                                               object:nil];
   // [self updateData];
    
}


/************************ NEW CODE ******************************/
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize  newsize;
    newsize = CGSizeMake(CGRectGetWidth(self.view.frame), (CGRectGetHeight(self.view.frame)));
    if ( UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad){
//        newsize.width = 246;
//        newsize.height = 380;
       newsize.width = 240;
       newsize.height = 345;
        return newsize;
   }
   else
   {
//        newsize.width = ((self.view.frame.size.width / 100) * 80);
//        newsize.height = ((self.view.frame.size.height / 100) * 68);
       newsize.width = self.view.frame.size.width / 2.18 ;
       newsize.height = newsize.width *  1.84;
       
        return newsize;
    }
}
-(void)changeTechniqueName{

}


-(void)MySubViewController:(MySubView *) controller didAddCustomer:(Technique *) technique
{
    [self.collectionView reloadData];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.globalIndex = [self.techniques indexOfObject:technique];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)populateAndReload{
    [self.collectionView reloadData];
}
-(void)viewDidDisappear{
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    tapRecognizer = nil;
    self.menuViewController.ViewController = nil;
}

-(void)openEntry
{
    
    _fileNameForOpenEntry  = [[NSUserDefaults standardUserDefaults] objectForKey:@"newCreatedFileName"];
    [self copyFileToICloud:_fileNameForOpenEntry];

    [self getArrayOfFilesInDirectory];
    
//    [self copyFileToICloud:_fileNameForOpenEntry];
    
    NewEntryController *newEntryVC = [self.storyboard instantiateViewControllerWithIdentifier:@"NewEntryController"];
    NSMutableDictionary * dictOfData = [self openFileAtPath:_fileNameForOpenEntry error:nil];
            
    newEntryVC.navigationItem.title = [dictOfData objectForKey:@"techniqueName"];
    [newEntryVC setTechniqueID:[dictOfData objectForKey:@"uuid"]];
    newEntryVC.techniqueType = [dictOfData objectForKey:@"maleFemale"];
    [self.navigationController pushViewController:newEntryVC animated:YES];
}

#pragma mark -Create or Open Database

#pragma mark -didRecieveMemoryWarning
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark -Collection View methods



- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section;
{
//    if(arrayOfTechnique.count==0)
//    {
//        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//        [defaults setInteger:0 forKey:@"Array"];
//        [defaults synchronize];
//    }
//    else
//    {
//        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//        [defaults setInteger:1 forKey:@"Array"];
//        [defaults synchronize];
//    }
    return filesArray.count;
}

-(void)updateCollectionView{
}
- (void)userDidSwipe:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        NSLog(@"Gesture Swipe Handled");
    }
}
#pragma mark LongPressGesture

- (void)setupLongPressGestures{
     longpresscell = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(pressCell:)];
    longpresscell.minimumPressDuration = 0.3;
    [self.collectionView addGestureRecognizer:longpresscell];
}
- (void)pressCell:(UILongPressGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan){
        return;
    }
        CGPoint p = [gestureRecognizer locationInView:self.collectionView];
        NSIndexPath * indexPath = [self.collectionView indexPathForItemAtPoint:p];
        indexOfSelectedCell = indexPath;
        
        if(indexPath == nil){
            NSLog(@"couldn't find index");
        }else {
            Cell * cell = (Cell *)[self.collectionView cellForItemAtIndexPath:indexPath];
            longpresscell.enabled = NO;
            [self.collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
            [self selectCell:cell];
            indexOfSelectedCell = indexPath;
            [self selectionActivatedFromLongPress];
            
            
        }
}

-(void)selectionActivated{
    self.isSelectionActivated = YES;
    [self setupRightNavigationItem:@"Cancel" selector:@"removeOrangeLayer"];
    self.navigationItem.leftBarButtonItem = nil;
    self.addHeadsheet.hidden = YES;
    [HapticHelper generateFeedback:FeedbackType_Impact_Light];
    [self.collectionView reloadData];
}



-(void)selectionActivatedFromLongPress{
    self.isSelectionActivated = YES;
    [self setupRightNavigationItem:@"Cancel" selector:@"removeOrangeLayer"];
    //[self setupInfoButton:@"trash_edited" selector:@"showConfirmationPopOver"];
    self.navigationItem.leftBarButtonItem = nil;
    self.addHeadsheet.hidden = YES;
    for (NSInteger row = 0; row < [self.collectionView numberOfItemsInSection:0]; row++) {
        Cell * cell =   (Cell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
        [cell setIsCheckHidden:NO];
    }
    [HapticHelper generateFeedback:FeedbackType_Impact_Light];
}

-(void)setupRightNavigationItem:(NSString*)btnTitle selector:(NSString*)method{
    SEL selectorNew = NSSelectorFromString(method);

    UIBarButtonItem *sortBtn = [[UIBarButtonItem alloc]initWithTitle:btnTitle style:UIBarButtonItemStylePlain target:self action:selectorNew];
    NSDictionary * barButtonApperance = @{NSFontAttributeName : [UIFont fontWithName:@"AvenirNext-DemiBold" size:16.0], NSForegroundColorAttributeName: [UIColor colorNamed:@"textWhiteDeepBlue"]};
    [sortBtn setTitleTextAttributes:barButtonApperance forState:UIControlStateNormal];
    [sortBtn setTitleTextAttributes:barButtonApperance forState:UIControlStateHighlighted];
    [sortBtn setTitleTextAttributes:barButtonApperance forState:UIControlStateSelected];
    self.navigationItem.rightBarButtonItem = sortBtn;
}
-(void)setupInfoButton:(NSString*)imgName selector:(NSString*)method{
    SEL selectorNew = NSSelectorFromString(method);

    UIButton *leftCustomButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [leftCustomButton addTarget:self
                         action:selectorNew
               forControlEvents:UIControlEventTouchUpInside];
    [leftCustomButton.widthAnchor constraintEqualToConstant:40].active = YES;
    [leftCustomButton.heightAnchor constraintEqualToConstant:40].active = YES;
    [leftCustomButton setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    
    UIBarButtonItem *rename = [[UIBarButtonItem alloc]initWithTitle:@"Rename" style:UIBarButtonItemStylePlain target:self action:@selector(renameTechnique)];
    NSDictionary * barButtonApperance = @{NSFontAttributeName : [UIFont fontWithName:@"AvenirNext-DemiBold" size:16.0], NSForegroundColorAttributeName: [UIColor colorNamed:@"textWhiteDeepBlue"]};
    [rename setTitleTextAttributes:barButtonApperance forState:UIControlStateNormal];
    [rename setTitleTextAttributes:barButtonApperance forState:UIControlStateHighlighted];
    [rename setTitleTextAttributes:barButtonApperance forState:UIControlStateSelected];
    UIBarButtonItem * leftButtonItem =[[UIBarButtonItem alloc] initWithCustomView:leftCustomButton];

    if([method isEqualToString:@"showConfirmationPopOver"]){
        self.navigationItem.leftBarButtonItems = @[leftButtonItem, rename];
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    }
    else {

        self.navigationItem.leftBarButtonItems = @[leftButtonItem];
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    }
   
}

-(void)renameTechnique{
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"showPop"
     object:self];
}

-(void)removeOrangeLayer{
    self.addHeadsheet.hidden = NO;
    self.navigationItem.rightBarButtonItems = nil;
    [self setupInfoButton:@"info_b.png" selector:@"openInfoController"];
    self.isSelectionActivated = NO;
    [self cancelCellSelection];
    [self setupRightNavigationItem:@"Select" selector:@"selectionActivated"];
}

#pragma mark SHARING
-(void)shareDiagram{

    NSString *exportingFileName = [filesArray objectAtIndex:[indexOfSelectedCell row]];
    

    NSArray *sysPaths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
    NSString *docDirectory = [sysPaths objectAtIndex:0];
    NSString *filePath = [docDirectory stringByAppendingPathComponent:exportingFileName];
    NSURL * url = [NSURL fileURLWithPath:filePath];
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems: @[url] applicationActivities:nil];
    [self presentViewController:activityViewController animated: YES completion: nil];
}

/*
-(UIImage*)imageToArchive:(NSString*)fileName headtype:(NSString*)headtype{
    NSMutableString *filenamethumb1 = [@"%@/" mutableCopy];
    NSMutableString *prefix= [fileName mutableCopy];
    filenamethumb1 = [filenamethumb1 mutableCopy];
    [filenamethumb1 appendString: prefix];
    filenamethumb1 = [filenamethumb1 mutableCopy];
    [filenamethumb1 appendString: headtype];
    filenamethumb1 = [filenamethumb1 mutableCopy];
    [filenamethumb1 appendString: @".png"];
    
    NSArray *sysPaths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
    NSString *docDirectory = [sysPaths objectAtIndex:0];
    NSString *filePath = [NSString stringWithFormat:filenamethumb1, docDirectory];
    UIImage *tempimage = [[UIImage alloc] initWithContentsOfFile:filePath];
    return tempimage;
}

-(NSDictionary*)JSONtoArchive:(NSString*)fileName headtype:(NSString*)headtype{
    NSMutableString *filenamethumb1 = [@"%@/" mutableCopy];
    NSMutableString *prefix= [fileName mutableCopy];
    filenamethumb1 = [filenamethumb1 mutableCopy];
    [filenamethumb1 appendString: prefix];
    filenamethumb1 = [filenamethumb1 mutableCopy];
    [filenamethumb1 appendString: headtype];
    filenamethumb1 = [filenamethumb1 mutableCopy];
    [filenamethumb1 appendString: @".json"];
    
    NSArray *sysPaths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
    NSString *docDirectory = [sysPaths objectAtIndex:0];
    NSString *filePath = [NSString stringWithFormat:filenamethumb1, docDirectory];
   
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    return json;
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError imageName:(NSString*)imageName fileName:(NSString*)name techniqueName:(NSString*)techniqueName maleOrFemale:(NSString*)maleOrFem{
    NSError *error = nil;
    NSLog(@"filename %@", imageName);

    UIImage * fileName1 = [self imageToArchive:imageName headtype:@"thumb1"];
    UIImage * fileName2 = [self imageToArchive:imageName headtype:@"thumb2"];
    UIImage * fileName3 = [self imageToArchive:imageName headtype:@"thumb3"];
    UIImage * fileName4 = [self imageToArchive:imageName headtype:@"thumb4"];
    UIImage * fileName5 = [self imageToArchive:imageName headtype:@"thumb5"];
    UIImage * fileNameEntry = [self imageToArchive:imageName headtype:@"Entry"];

    
    NSDictionary * fileNameJSON1 = [self JSONtoArchive:imageName headtype:@"lefthead"];
    NSDictionary * fileNameJSON2 = [self JSONtoArchive:imageName headtype:@"righthead"];
    NSDictionary * fileNameJSON3 = [self JSONtoArchive:imageName headtype:@"tophead"];
    NSDictionary * fileNameJSON4 = [self JSONtoArchive:imageName headtype:@"fronthead"];
    NSDictionary * fileNameJSON5 = [self JSONtoArchive:imageName headtype:@"backhead"];
    
    NSString * filename = imageName;
    NSString * techName = techniqueName;
    NSString * maleOrFemale = maleOrFem;


    
    if ([typeName isEqualToString:typeName]) {
        //Create a Dictionary
        NSMutableDictionary *dictToSave = [NSMutableDictionary dictionary];
        
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

          //Return the archived data
        return [NSKeyedArchiver archivedDataWithRootObject:dictToSave requiringSecureCoding:NO error:&error];
    }
    //Don't generate an error
    outError = NULL;
    return nil;
}

- (NSString*)createNameFromUUID:(NSString*)filetype identifier:(NSString*)uuidTemp {
    NSMutableString * newString = [uuidTemp mutableCopy];
    newString = [newString mutableCopy];
    [newString appendString:filetype];
    newString = [newString mutableCopy];
    [newString appendString:@".png"];
    return newString;
}

-(NSString*)techniqueNameFrom:(AppDelegate*)appDelegate{
    
    for(Technique * tech in self.techniques){
        if([appDelegate.nameFromImportedFile isEqual:tech.techniquename]){
        
            NSString *lastChar = [tech.techniquename substringFromIndex:[tech.techniquename length] - 1];
            
            unichar c = [lastChar characterAtIndex:0];
            NSCharacterSet *numericSet = [NSCharacterSet decimalDigitCharacterSet];
            if ([numericSet characterIsMember:c]) {
                
                int myInt = [lastChar intValue];
                appDelegate.nameFromImportedFile = [appDelegate.nameFromImportedFile substringToIndex:[appDelegate.nameFromImportedFile length] - 1];

                appDelegate.nameFromImportedFile = [appDelegate.nameFromImportedFile stringByAppendingFormat:@"%d", myInt + 1];
            }
            else {
                appDelegate.nameFromImportedFile = [appDelegate.nameFromImportedFile stringByAppendingFormat:@"%d", 1];
            }
        }
    }
    return appDelegate.nameFromImportedFile;
}*/

-(NSString*)getNamesOfTechniquesInFiles:(NSString*)techNameImported{
    
    for(int i = 0; i < filesArray.count; i++){
        NSMutableDictionary * dictOfData = [self openFileAtPath:[filesArray objectAtIndex:i] error:nil];
        NSString * nameFromDict = [dictOfData objectForKey:@"techniqueName"];
        if([techNameImported isEqualToString:nameFromDict]){
            NSString *lastChar = [nameFromDict substringFromIndex:[nameFromDict length] - 1];
            
            unichar c = [lastChar characterAtIndex:0];
            NSCharacterSet *numericSet = [NSCharacterSet decimalDigitCharacterSet];
            if ([numericSet characterIsMember:c]) {
                
                int myInt = [lastChar intValue];
                techNameImported = [techNameImported substringToIndex:[techNameImported length] - 1];

                techNameImported = [techNameImported stringByAppendingFormat:@"%d", myInt + 1];
            }
            else {
                techNameImported = [techNameImported stringByAppendingFormat:@"%d", 1];
            }
            
        }
    }
    return techNameImported;
}

-(void)insertExportedDataFromAppDelegate{
    
    [self getArrayOfFilesInDirectory];
    [self.collectionView reloadData];
    NewEntryController *newEntryVC = [self.storyboard instantiateViewControllerWithIdentifier:@"NewEntryController"];

    NSString * nameOfTechnique;
    
    NSMutableDictionary * dictOfData = [self openFileAtPath:[filesArray lastObject ] error:nil];
    
    newEntryVC.navigationItem.title = [dictOfData objectForKey:@"techniqueName"];
    [newEntryVC setTechniqueID:[dictOfData objectForKey:@"uuid"]];
    newEntryVC.techniqueType = [dictOfData objectForKey:@"maleFemale"];
     
    [self.navigationController pushViewController:newEntryVC animated:YES];
}

-(NSString*)currentDateFromFilePath:(NSString*)path{
    NSString * deviceLanguage = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSDictionary* fileAttribs = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
    NSDate *date = [fileAttribs objectForKey:NSFileCreationDate]; //or NSFileModificationDate
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    NSLocale * locale = [[NSLocale alloc] initWithLocaleIdentifier:deviceLanguage];
    [df setLocale:locale];

    [df setDateStyle:NSDateFormatterMediumStyle]; // day, Full month and year
    [df setTimeStyle:NSDateFormatterNoStyle];  // nothing
    NSString *dateString = [df stringFromDate:date];
    return dateString;
}
-(NSString*)currentDate{
    
    NSDate *date = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateStyle:NSDateFormatterMediumStyle]; // day, Full month and year
    [df setTimeStyle:NSDateFormatterNoStyle];  // nothing
    NSString *dateString = [df stringFromDate:date];
    return dateString;
}
#pragma mark Collection View Delegate Methods

-(void)getArrayOfFilesInDirectory{

    NSArray * dirs = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] error:NULL];
    [filesArray removeAllObjects];
    [dirs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *filename = (NSString *)obj;
        NSString *extension = [[filename pathExtension] lowercaseString];
        if ([extension isEqualToString:@"htapp"]) {
            [filesArray addObject:filename];
            NSLog(@"filename %@ ", filename );
        }
    }];
    
    [self sortCollectionViewFromSegments:[[NSUserDefaults standardUserDefaults] objectForKey:@"order"]];
    
    [self.collectionView reloadData];
}
#pragma mark Sorting methods

-(void)sortCollectionView:(NSString*)key{
    
    NSLog(@"SEGMENTED PERFORMED");
    NSArray * dirs = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] error:NULL];
    [filesArray removeAllObjects];
    [dirs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *filename = (NSString *)obj;
        NSString *extension = [[filename pathExtension] lowercaseString];
        if ([extension isEqualToString:@"htapp"]) {
            [filesArray addObject:filename];
            NSLog(@"filename %@ ", filename );
        }
    }];
   

    [self sortCollectionViewFromSegments:key];
    [self.collectionView reloadData];

}

-(void)sortCollectionViewFromSegments:(NSString*)key{
    NSMutableArray * tempArray = [NSMutableArray array];

for(int i = 0; i < filesArray.count; i++){
NSMutableDictionary * dictOfData = [self openFileAtPath:[filesArray objectAtIndex:i] error:nil];
[tempArray addObject:dictOfData];
}
NSArray * sortedArray;

sortedArray = [self sortArrayByNameWithKey:key andArray:tempArray];

/* Creating new sordted array of file names*/
[filesArray removeAllObjects];
for(int i = 0; i < sortedArray.count; i++){
    NSMutableDictionary * dictOfDataSorted = [sortedArray objectAtIndex:i];
    NSMutableString * stringWithWxtension = [[dictOfDataSorted objectForKey:@"uuid"] mutableCopy];
    [stringWithWxtension appendString:@".htapp"];
    [filesArray addObject:stringWithWxtension];
}

}
//-(void)sortArrayByAscendingName{
//    
//    NSMutableArray * tempArray = [NSMutableArray array];
//    
//    for(int i = 0; i < filesArray.count; i++){
//    NSMutableDictionary * dictOfData = [self openFileAtPath:[filesArray objectAtIndex:i] error:nil];
//    [tempArray addObject:dictOfData];
//    }
//    NSArray * sortedArray;
//    
//    sortedArray = [self sortArrayByNameWithKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"order"] andArray:tempArray];
//    
//    /* Creating new sordted array of file names*/
//    [filesArray removeAllObjects];
//    for(int i = 0; i < sortedArray.count; i++){
//        NSMutableDictionary * dictOfDataSorted = [sortedArray objectAtIndex:i];
//        NSMutableString * stringWithWxtension = [[dictOfDataSorted objectForKey:@"uuid"] mutableCopy];
//        [stringWithWxtension appendString:@".htapp"];
//        [filesArray addObject:stringWithWxtension];
//    }
//}

-(NSMutableArray *)sortArrayByNameWithKey:(NSString *)sortingKey andArray:(NSMutableArray *)unsortedArray{
    
    NSArray * sortedArray;
    
    if( [sortingKey isEqualToString:@"techniqueName"]){
        NSSortDescriptor *sortByName = [NSSortDescriptor sortDescriptorWithKey:sortingKey
                                                                     ascending:YES];
        NSArray *sortDescriptors = [NSArray arrayWithObject:sortByName];
        sortedArray =  [unsortedArray sortedArrayUsingDescriptors:sortDescriptors].mutableCopy;
    }
    if ([sortingKey isEqualToString:@"creationDate"]){
        NSSortDescriptor *lastDescriptor = [[NSSortDescriptor alloc] initWithKey:sortingKey ascending:NO selector:@selector(compare:)];
        NSArray *descriptors = [NSArray arrayWithObjects: lastDescriptor, nil];
        sortedArray =  [unsortedArray sortedArrayUsingDescriptors:descriptors].mutableCopy;
    }
    if ([sortingKey isEqualToString:@"favorite"]){
        NSSortDescriptor *lastDescriptor = [[NSSortDescriptor alloc] initWithKey:sortingKey ascending:NO selector:@selector(compare:)];
        NSArray *descriptors = [NSArray arrayWithObjects: lastDescriptor, nil];
        sortedArray =  [unsortedArray sortedArrayUsingDescriptors:descriptors].mutableCopy;
    }
    
    return sortedArray.mutableCopy;
}

/*-(NSMutableArray *)sortArrayByDateWithKey:(NSString *)sortingKey andArray:(NSMutableArray *)unsortedArray{
    NSSortDescriptor *lastDescriptor = [[NSSortDescriptor alloc] initWithKey:sortingKey ascending:YES selector:@selector(compare:)];
    NSArray *descriptors = [NSArray arrayWithObjects: lastDescriptor, nil];
    return [unsortedArray sortedArrayUsingDescriptors:descriptors].mutableCopy;
}*/


-(NSMutableDictionary*)openFileAtPath:(NSString*)fileName error:(NSError **)outError {

    NSArray *sysPaths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
    NSString *docDirectory = [sysPaths objectAtIndex:0];
    NSString *filePath = [docDirectory stringByAppendingPathComponent:fileName];
    
    NSURL * url = [NSURL fileURLWithPath:filePath];
    NSData *data = [NSData dataWithContentsOfURL:url];

    NSMutableDictionary * tempDict = [NSKeyedUnarchiver unarchivedObjectOfClass:[NSObject class] fromData:data error:outError];
    
    return tempDict;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        self.headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView" forIndexPath:indexPath];
//        NSString *title = [[NSString alloc]initWithFormat:@"Recipe Group #%i", indexPath.section + 1];
//        headerView.title.text = title;
//        UIImage *headerImage = [UIImage imageNamed:@"header_banner.png"];
        //headerView.backgroundImage.image = headerImage;
        self.headerView.delegate = self;

        reusableview = self.headerView;
    }
 
    if (kind == UICollectionElementKindSectionFooter) {
        UICollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
 
        reusableview = footerview;
    }
        
    return reusableview;
}

- (void)addGestureRecognizersToCell:(Cell *)cell {
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(renamePressed:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    
    UITapGestureRecognizer *tapFavorite = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(heartPressed:)];
    tapFavorite.numberOfTapsRequired = 1;
    [cell.favorite addGestureRecognizer:tapFavorite];
    [cell.dateLabel addGestureRecognizer:tapGestureRecognizer];
    cell.dateLabel.userInteractionEnabled = YES;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    Cell *cell = [cv dequeueReusableCellWithReuseIdentifier:kCellID forIndexPath:indexPath];
    
    if(self.isSelectionActivated)
    {
        [cell.favorite setHidden:YES];

        [cell setIsCheckHidden:NO];
    }
    else {
        [cell.favorite setHidden:NO];

        [cell setIsCheckHidden:YES];
    }
    
    [cell hideBar];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        [cell.contentView.layer setCornerRadius:15.0f];
        cell.clipsToBounds = YES;
        cell.contentView.layer.masksToBounds = YES;
        cell.layer.shadowColor = [UIColor blackColor].CGColor;
        cell.layer.shadowOffset = CGSizeMake(0,0);
        cell.layer.shadowRadius = 3.0f;
        cell.layer.shadowOpacity = 0.1f;
        cell.layer.masksToBounds = NO;

    NSMutableDictionary * dictOfData = [self openFileAtPath:[filesArray objectAtIndex:indexPath.row] error:nil];
    
    NSLog(@"File name in dir %@", [filesArray objectAtIndex:indexPath.row]);

    
    cell.image.image = [UIImage imageWithData:[dictOfData objectForKey:@"imageEntry"]];
    cell.dateLabel.text = [dictOfData objectForKey:@"techniqueName"];
    cell.cellIndex = indexPath;
    cell.viewModeLabel.text = [dictOfData objectForKey:@"creationDate"];
    cell.UUIDcell = [dictOfData objectForKey:@"uuid"];
    
    if([[dictOfData objectForKey:@"favorite"] isEqualToString:@"favorite"]){
        cell.isFavorite = YES;
        [cell.favorite setImage:[UIImage imageNamed:@"star.fill"]];
    }else {
        cell.isFavorite = NO;

        [cell.favorite setImage:[UIImage imageNamed:@"star.tr"]];
    }
    

        CGSize  newsize;
        newsize = CGSizeMake(CGRectGetWidth(cell.frame), (CGRectGetHeight(cell.frame)));
        CGRect screenRect = [[UIScreen mainScreen] bounds];

    [self addGestureRecognizersToCell:cell];
    cell.newVersionDiagram = YES;
    cell.image.frame = CGRectMake(0, -15, cell.frame.size.width , cell.frame.size.height);
    
    if ([cv.indexPathsForSelectedItems containsObject:indexPath]) {
        [cv selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        // Select Cell
        [self selectCell:cell];
        indexOfSelectedCell = indexPath;
        [self setupRightNavigationItem:@"Cancel" selector:@"removeOrangeLayer"];
        [self setupInfoButton:@"trash_edited" selector:@"showConfirmationPopOver"];
    }
    else {
        // Set cell to non-highlight
        [self selectCell:cell];
        
    }
    return cell;
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"subView"])
            {
                [self openSubView];
            }
    }

-(void)renamePressed:(UITapGestureRecognizer *)gestureRecognizer{
    
    CGPoint tapPoint = [gestureRecognizer locationInView:self.collectionView];
    indexOfSelectedCell = [self.collectionView indexPathForItemAtPoint:tapPoint];
    Cell * cell = (Cell*)[self.collectionView cellForItemAtIndexPath:indexOfSelectedCell];
    NSLog(@"rename preseed %@", cell.dateLabel);
    if(!self.isSelectionActivated){
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"showPop"
         object:self];
    }
}
-(void)heartPressed:(UITapGestureRecognizer *)gestureRecognizer{
    
    CGPoint tapPoint = [gestureRecognizer locationInView:self.collectionView];
    indexOfFavoriteCell = [self.collectionView indexPathForItemAtPoint:tapPoint];
    Cell * cell = (Cell*)[self.collectionView cellForItemAtIndexPath:indexOfFavoriteCell];
        
    NSMutableString * filePath = [cell.UUIDcell mutableCopy];
    [filePath appendString:@".htapp"];

    NSMutableDictionary * dictOfData = [self openFileAtPath:filePath error:nil];

    if(cell.isFavorite){
        [dictOfData setObject:@"default" forKey:@"favorite"];
        [cell.favorite setImage:[UIImage imageNamed:@"star.tr"]];
    }else {
        [dictOfData setObject:@"favorite" forKey:@"favorite"];
        [cell.favorite setImage:[UIImage imageNamed:@"star.fill"]];
    }
    
    NSMutableDictionary* tempDictDefaults = [dictOfData mutableCopy];
    [[NSUserDefaults standardUserDefaults] setObject:tempDictDefaults forKey:@"temporaryDictionary"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    [self saveDiagramToFile:[tempDictDefaults objectForKey:@"uuid"]];
    [self reloadMyCollection];

    
    //    if(!self.isSelectionActivated){
//        [[NSNotificationCenter defaultCenter]
//         postNotificationName:@"showPop"
//         object:self];
//    }
    
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NewEntryController *newEntryVC = [self.storyboard instantiateViewControllerWithIdentifier:@"NewEntryController"];
    Cell *cell = (Cell *)[collectionView  cellForItemAtIndexPath:indexPath];

    
    if(!self.isSelectionActivated){
        
        
        NSMutableDictionary * dictOfData = [self openFileAtPath:[filesArray objectAtIndex:indexPath.row] error:nil];
                
        newEntryVC.navigationItem.title = [dictOfData objectForKey:@"techniqueName"];
        [newEntryVC setTechniqueID:[dictOfData objectForKey:@"uuid"]];
        [newEntryVC setTechniqueID:[dictOfData objectForKey:@"uuid"]];
        newEntryVC.techniqueType = [dictOfData objectForKey:@"maleFemale"];
        
        [self.navigationController pushViewController: newEntryVC animated:YES];
    }
    else{
        [self selectCell:cell];
        indexOfSelectedCell = indexPath;
        [self setupRightNavigationItem:@"Cancel" selector:@"removeOrangeLayer"];
        [HapticHelper generateFeedback:FeedbackType_Impact_Light];
    }
}


 -(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
     Cell * cell = (Cell *)[collectionView cellForItemAtIndexPath:indexPath];
     [self selectCell:cell];
}


-(void)selectCell:(Cell*)cell {

        if (cell.selected){
            [cell setIsHidden:NO];
            cell.checker.hidden = NO;
            cell.cell_menu_btn.hidden = NO;
            cell.cell_rename_btn.hidden = NO;
            
            if(cell.newVersionDiagram == YES){
                cell.shareBtn.hidden = NO;
            }

        }else {
            [cell setIsHidden:YES];
            cell.checker.hidden = YES;
            cell.cell_menu_btn.hidden = YES;
            cell.cell_rename_btn.hidden = YES;
            cell.shareBtn.hidden = YES;

        }

}
-(void)cancelCellSelection{

    for (NSIndexPath *indexPath in [self.collectionView indexPathsForSelectedItems]) {
        [self.collectionView deselectItemAtIndexPath:indexPath animated:NO];
        Cell * cell = (Cell *)[self.collectionView cellForItemAtIndexPath:indexPath];
        [cell setIsHidden:YES];
        longpresscell.enabled = YES;
        [cell.favorite setHidden:NO];
    }
        for (NSInteger row = 0; row < [self.collectionView numberOfItemsInSection:0]; row++) {
            Cell * cell2 =   (Cell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
        cell2.checkItem.hidden = YES;
            cell2.checker.hidden = YES;
            cell2.cell_menu_btn.hidden = YES;
            cell2.cell_rename_btn.hidden = YES;
            cell2.shareBtn.hidden = YES;

            longpresscell.enabled = YES;
            [cell2.favorite setHidden:NO];
    }
}
-(void)openSubView:(id)sender
    {
 
        [HapticHelper generateFeedback:FeedbackType_Impact_Light];
        MySubView *mysubview  = [self.storyboard instantiateViewControllerWithIdentifier:@"subView"];
        mysubview.delegate = self;
        NameViewController *nameView  = [self.storyboard instantiateViewControllerWithIdentifier:@"NameViewController"];
        nameView.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        nameView.modalPresentationStyle = UIModalPresentationFullScreen;
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:nameView];
        [self presentViewController:nc animated:YES completion:nil];

    }
#pragma mark -passItemBack Method

-(void) passItemBack:(MySubView *)controller didFinishWithItem:(NSString*)item{
   tempstring = item;
   NSLog(@"text From subView %@", item);
}

#pragma mark -Save and Reload methods

- (void)reloadMyCollection
{
[self.collectionView reloadData];
}

-(void)colorCellFrame:(UICollectionViewCell*)cell
{
    
    UIColor *fillColor = [UIColor colorWithRed:30.0/255.0 green:135.0/255.0 blue:220.0/255.0 alpha:1.0];
    cell.contentView.backgroundColor =  fillColor;
    [cell.layer setBorderColor:fillColor.CGColor];
     [cell.layer setBorderWidth:4.0f];
    [cell.layer setBackgroundColor:fillColor.CGColor];
    [cell.layer setCornerRadius:15.0f];
    [cell.layer setShadowOffset:CGSizeMake(0, 0)];
    [cell.layer setShadowColor:fillColor.CGColor];
    [cell.layer setShadowRadius:5.0f];
    [cell.layer setShadowOpacity:1.0];
}

-(void)colorBackCellFrame{
   
    Cell *cell = [self.collectionView cellForItemAtIndexPath:self.tappedCellPath];
    UIColor *fillColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
    cell.contentView.backgroundColor =  [UIColor colorNamed:@"blue"];
    [cell.layer setBorderColor:fillColor.CGColor];
    [cell.contentView.layer setCornerRadius:15.0f];
    [cell.layer setBorderWidth:1.0f];
    [cell.layer setBackgroundColor:fillColor.CGColor];
    [cell.layer setCornerRadius:15.0f];
    [cell.layer setShadowOffset:CGSizeMake(0, 0)];
    [cell.layer setShadowColor:fillColor.CGColor];
    [cell.layer setShadowRadius:0.0f];
    [cell.layer setShadowOpacity:0.0];
}


-(void)showConfirmationPopOver
{

    actionSheet = [[UIActionSheet alloc] initWithTitle:@"Confirm" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"Delete" otherButtonTitles:@"Cancel", nil];
    actionSheet.delegate = self;
    //[actionSheet showFromBarButtonItem:self.navigationItem.rightBarButtonItem animated:YES];
    [actionSheet showInView:self.view];
}


- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {

    if (buttonIndex == actionSheet.destructiveButtonIndex) {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];


        NSMutableDictionary * dictOfData = [self openFileAtPath:[filesArray objectAtIndex:[indexOfSelectedCell row]] error:nil];
        [self removeImage:[dictOfData objectForKey:@"uuid"]];
        [self.collectionView  reloadData];

        self.navigationItem.leftBarButtonItems = nil;

        if(filesArray.count == 0){
            [self removeOrangeLayer];
            self.navigationItem.rightBarButtonItem.enabled = NO;
        }
        
    }else {
       // [ self.editButtonOutlet setEnabled:YES];

        for (Cell *cell in [self.collectionView visibleCells]) {
            [cell setEditing:NO animated:NO];
        }
      //  isDeletionModeActive = NO;
       MyCustomLayout *layout = (MyCustomLayout *)self.collectionView.collectionViewLayout;
       [layout invalidateLayout];
        [self.addTechnique setEnabled:YES];
        [actionSheet dismissWithClickedButtonIndex:actionSheet.cancelButtonIndex animated:YES];
   }
    }


-(void)checkArrayCount
{
    if (arrayOfTechnique.count==0)
    {

        NSLog(@"Array count  = %lu", arrayOfTechnique.count);
        
        isDeletionModeActive = NO;
        MyCustomLayout *layout = (MyCustomLayout *)self.collectionView.collectionViewLayout;
        [layout invalidateLayout];
        

        [self.collectionView removeGestureRecognizer:tapRecognizer];
        
        self.navigationItem.title=@"Collection";
       [self.editButtonOutlet setEnabled:NO];
        [self.addTechnique setEnabled:YES];
        tap = NO;
    }
}

- (NSMutableString *)getFileName:(NSString *)fileName prefix:(NSString*)prefix{
    NSMutableString *filenamethumb = [fileName mutableCopy];
    filenamethumb = [filenamethumb mutableCopy];
    [filenamethumb appendString: prefix];
    return filenamethumb;
}

- (void)removeImage:(NSString*)fileName {
    
    NSMutableString * fileNameToDelete = [self getFileName:fileName prefix:@".htapp"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,   YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSLog(@"%@ Documents", documentsDirectory);
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:
                          [NSString stringWithFormat:@"%@",fileNameToDelete]];
    [fileManager removeItemAtPath:fullPath error:NULL];
    NSError *error = nil;
    if(![fileManager removeItemAtPath: fullPath error:&error]) {
        NSLog(@"Delete failed:%@", error);
    } else {
        NSLog(@"image removed: %@", fullPath);
    }

//    NSString *appFolderPath = [[NSBundle mainBundle] resourcePath];
//    NSLog(@"Directory Contents:\n%@", [fileManager directoryContentsAtPath: appFolderPath]);
//    [self getArrayOfFilesInDirectory];

    NSURL * fileURL = [NSURL fileURLWithPath:fullPath];
    NSOperationQueue *q = [[NSOperationQueue alloc] init];

    NSURL *localURL = [self iCloudPathToResource:fileNameToDelete];
    NSArray * urlArray = @[localURL];

    [self deleteItemsAtURLs:urlArray queue:q];
    [self getArrayOfFilesInDirectory];
    [self getArrayOfFilesInDirectory];

}

//        NSURL * fileURL = [NSURL fileURLWithPath:filePath];
- ( void )deleteItemsAtURLs: ( NSArray * )urls queue: ( NSOperationQueue * )queue
    {
        //assuming urls is an array of urls to be deleted
        NSFileCoordinator   * coordinator;
        NSMutableArray      * writingIntents;
        NSURL               * url;

        writingIntents = [ NSMutableArray arrayWithCapacity: urls.count ];

        for( url in urls )
        {
            [ writingIntents addObject: [ NSFileAccessIntent writingIntentWithURL: url options: NSFileCoordinatorWritingForDeleting ] ];
        }

        coordinator = [ [ NSFileCoordinator alloc ] initWithFilePresenter: nil ];

        [ coordinator coordinateAccessWithIntents: writingIntents
                                            queue: queue
                                       byAccessor: ^( NSError * error )
         {
             if( error )
             {
                 //handle
                 return;
             }
             NSFileAccessIntent * intent;

             error = nil;

             for( intent in writingIntents )
             {
                 [ [ NSFileManager defaultManager ] removeItemAtURL: intent.URL error: &error ];
                 if( error )
                 {
                     //handle
                 }

             }
         }];
    }

-(NSURL*)ubiquitousDocumentsDirectoryURL {
    return [[self ubiquitousContainerURL] URLByAppendingPathComponent:@"Documents"];
}
-(NSURL*)ubiquitousContainerURL {
    return [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil];
}


- (IBAction)showSideMenu:(id)sender{
[self.menuViewController presentFromViewController:self animated:YES completion:nil];

}


- (void) receiveTestNotification:(NSNotification *)notification
{
    if ([[notification name] isEqualToString:@"showPop"])
    {
        Technique *tech = [self.techniques objectAtIndex:[indexOfSelectedCell row]];
        HMPopUpView *hmPopUp = [[HMPopUpView alloc] initWithTitle:@"Rename diagram" okButtonTitle:@"Ok" cancelButtonTitle:@"Cancel" okBtnColor:[UIColor colorNamed:@"orange"] delegate:self];
    
    [hmPopUp configureHMPopUpViewWithBGColor:[UIColor colorNamed:@"whiteDark"] titleColor: [UIColor colorNamed:@"textWhiteDeepBlue"] buttonViewColor:[UIColor colorNamed:@"whiteDark"] buttonBGColor:[UIColor colorNamed:@"whiteDark"] buttonTextColor: [UIColor colorNamed:@"textWhiteDeepBlue"]];
        
    NSMutableDictionary * dictOfData = [self openFileAtPath:[filesArray objectAtIndex:[indexOfSelectedCell row]] error:nil];
        
    [hmPopUp showInView:self.view];
    [hmPopUp setTextFieldText:[dictOfData objectForKey:@"techniqueName"]];
        
        NSMutableDictionary* tempDictDefaults = [dictOfData mutableCopy];
        [[NSUserDefaults standardUserDefaults] setObject:tempDictDefaults forKey:@"temporaryDictionary"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
}

- (void) receiveTestNotification2:(NSNotification *)notification
{
    
    if ([[notification name] isEqualToString:@"hideAllBars"])
    {
        
        for (Cell *cell in [self.collectionView visibleCells]) {
            [cell hideBar];
        }
        
    }
    
}


- (void) receiveTestNotification3:(NSNotification *)notification
{
    
    if ([[notification name] isEqualToString:@"showDeletePop"])
    {
        [self showConfirmationPopOver];
    }
}



- (NSMutableString*)getNameOnRenaming:(NSString *)txtField prefix:(NSString*)prefix{
    NSMutableString * filename = [txtField mutableCopy];
    filename = [filename mutableCopy];
    [filename appendString:prefix];
    return filename;
 }
-(void)storeNewNameInTempDictionary:(NSString*)name{
    
    NSMutableDictionary* tempDict = [[[NSUserDefaults standardUserDefaults] objectForKey:@"temporaryDictionary"] mutableCopy];
    [tempDict setObject:name forKey:@"techniqueName"];
    
    [[NSUserDefaults standardUserDefaults] setObject:tempDict forKey:@"temporaryDictionary"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self saveDiagramToFile:[tempDict objectForKey:@"uuid"]];
}


-(void)renameTechniqueDelegate:(NSString*)txtField{
    
    NSMutableDictionary* tempDict = [[[NSUserDefaults standardUserDefaults] objectForKey:@"temporaryDictionary"] mutableCopy];
    [tempDict setObject:txtField forKey:@"techniqueName"];
    [[NSUserDefaults standardUserDefaults] setObject:tempDict forKey:@"temporaryDictionary"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self saveDiagramToFile:[tempDict objectForKey:@"uuid"]];
    [self reloadMyCollection];
}


-(BOOL) validate:(Technique *)c
{
    if([c.techniquename length] == 0)
    {
        return NO;
    }
    
    return YES;
}

-(void)changeFileName:(NSString *)filename to:(NSString*)newFileName
{
    NSError *error;
    
    // Create file manager
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [documentPaths objectAtIndex:0];
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



-(BOOL)checkEnteredName:(NSString*)txtField{
    BOOL techniqueExist;
    [self getArrayOfFilesInDirectory];
    for(int i = 0; i < filesArray.count; i++){
        
        NSMutableDictionary * dictOfData = [self openFileAtPath:[filesArray objectAtIndex:i] error:nil];
        NSLog(@" technique name in array %@", [dictOfData objectForKey:@"techniqueName"]);

        if([txtField isEqualToString:[dictOfData objectForKey:@"techniqueName"]]){
        techniqueExist = YES;
            break;
        }else {
        techniqueExist = NO;

        }
    }    return techniqueExist;
}

#pragma mark SYNCHRONIZATION



- (void)shouldAnimateIndicator:(BOOL)animate {
    if (animate) {
        [self.indicatorView startAnimating];
      //  self.indicatorView.hidden = NO;

    } else {
        [self.indicatorView stopAnimating];
        //self.indicatorView.hidden = YES;

    }

    self.collectionView.userInteractionEnabled = !animate;
    self.navigationController.navigationBar.userInteractionEnabled = !animate;
}
- (void)presentMessage:(NSString *)msg {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"CloudKit", nil)
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"Ok", nil)
                                          otherButtonTitles:nil];
    [alert show];
}



-(void)saveDiagramToFile:(NSString*)techniqueName{

    NSMutableString * exportingFileName = [techniqueName mutableCopy];
    [exportingFileName appendString:@".htapp"];

    NSArray *sysPaths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
    NSString *docDirectory = [sysPaths objectAtIndex:0];
    NSString *filePath = [docDirectory stringByAppendingPathComponent:exportingFileName];
    NSData * data = [self dataOfType];

    // Save it into file system
    [data writeToFile:filePath atomically:YES];
   // NSURL * url = [NSURL fileURLWithPath:filePath];
}

- (NSData *)dataOfType{
    NSError *error = nil;
 
        NSMutableDictionary* dictToSave = [[[NSUserDefaults standardUserDefaults] objectForKey:@"temporaryDictionary"] mutableCopy];

          //Return the archived data
        return [NSKeyedArchiver archivedDataWithRootObject:dictToSave requiringSecureCoding:NO error:&error];
}



#pragma mark STORE NEW FILE IN CLOUD

- (void)copyFileToICloud:(NSString*)filePath {
    // Let's get the root directory for storing the file on iCloud Drive
    [self rootDirectoryForICloud:^(NSURL *ubiquityURL) {
        NSLog(@"1. ubiquityURL = %@", ubiquityURL);
        if (ubiquityURL) {

                    // We also need the 'local' URL to the file we want to store
                    NSURL *localURL = [self localPathForResource:filePath];
                    NSLog(@"2. localURL = %@", localURL);

                    // Now, append the local filename to the ubiquityURL
                    ubiquityURL = [ubiquityURL URLByAppendingPathComponent:localURL.lastPathComponent];
                    NSLog(@"3. ubiquityURL = %@", ubiquityURL);

                    // And finish up the 'store' action
                    NSError *error;
            if (![[NSFileManager defaultManager] copyItemAtURL:localURL toURL:ubiquityURL error:&error]){
//                          setUbiquitous:NO itemAtURL:localURL destinationURL:ubiquityURL error:&error]) {
                        NSLog(@"Error occurred: %@", error);
                    }
                }
        else {
            NSLog(@"Could not retrieve a ubiquityURL");
        }
    }];
}

- (void)rootDirectoryForICloud:(void (^)(NSURL *))completionHandler {

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *rootDirectory = [[[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil]URLByAppendingPathComponent:@"Documents"];

        if (rootDirectory) {
            if (![[NSFileManager defaultManager] fileExistsAtPath:rootDirectory.path isDirectory:nil]) {
                NSLog(@"Create directory");
                [[NSFileManager defaultManager] createDirectoryAtURL:rootDirectory withIntermediateDirectories:YES attributes:nil error:nil];
            }
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler(rootDirectory);
        });
    });
}
- (NSURL *)localPathForResource:(NSString *)filePath{
    NSString *documentsDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *resourcePath = [documentsDirectory stringByAppendingPathComponent:filePath];
    return [NSURL fileURLWithPath:resourcePath];
}
- (NSURL *)iCloudPathToResource:(NSString *)filePath{
    NSURL *rootDirectory = [[[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil]URLByAppendingPathComponent:@"Documents"];
    rootDirectory = [rootDirectory URLByAppendingPathComponent:filePath.lastPathComponent];

    return rootDirectory;
}

@end
