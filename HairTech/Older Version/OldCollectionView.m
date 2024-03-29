
#import "EntryViewController.h"
#import "REFrostedViewController.h"
#import "OldCollectionView.h"
#import "LoadingViewController.h"
//#import "Cell.h"
#import "MySubView.h"
#import "AppDelegate.h"
#import "MyCustomLayout.h"
#import "HapticHelper.h"
#import "NameViewController.h"
#import "TODetailTableViewController.h"

//#import "Flurry.h"

//NSString *kEntryViewControllerID = @"EntryViewController";    // view controller storyboard id
NSString *OldCellID = @"OldCellID";                          // UICollectionViewCell storyboard id
//NSString *nameOfTechniqueforControllers;

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




@interface OldCollectionView ()<UICollectionViewDataSource,UICollectionViewDelegate,UIGestureRecognizerDelegate,UICollectionViewDelegateFlowLayout>
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

@implementation OldCollectionView


BOOL isDeletionModeActive; // TO UNCOMMENT LATER


-(void)viewDidDisappear:(BOOL)animated
{
    NSLog(@"disapear");

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
    
    NSLog(@"View did appear");

    [super viewDidAppear:animated];
    

    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];

    NSUserDefaults *sharedDefaults = [NSUserDefaults standardUserDefaults];
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSInteger countValue = [defaults integerForKey:@"Array"];
//
//    if ([sharedDefaults boolForKey:@"FirstLaunch"])
//    {
//        [self saveColorsToDefaults];
//        [self saveFloatToUserDefaults:0.0 forKey:@"eraserPressed"];
//
//[self openSubView];
//        [sharedDefaults setBool:NO forKey:@"FirstLaunch"];
//        [sharedDefaults synchronize];
//
//        // [prefs synchronize];
//    }    // Do any additional setup after loading the view.
//    else if(countValue == 1)
//    {
//    }
//
//
 
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
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [self.collectionView  reloadData];
    [self setupNavigationBar];
    self.isSelectionActivated = NO;
    longpresscell.enabled = YES;
}

-(void)popBack{
    
    [self.navigationController popViewControllerAnimated:YES];
//   TODetailTableViewController  * viewController = [self.storyboard  instantiateViewControllerWithIdentifier:@"tableView"];
//    [self.navigationController pushViewController:viewController animated:YES];
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
    
    [self setupInfoButton:@"Back" selector:@"popBack"];
    
    [self setupRightNavigationItem:@"Select" selector:@"selectionActivated"];
    
    if(self.techniques.count > 0 ){
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
    else {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}



-(void)viewDidLoad
{

    //database =  [[CKContainer containerWithIdentifier:@"iCloud.com.hair.hairtech"] publicCloudDatabase];
    
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
                                                 name:@"showPopOld"
                                               object:nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(receiveTestNotification2:)
//                                                 name:@"hideAllBars"
//                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification3:)
                                                 name:@"showDeletePopOld"
                                               object:nil];

    
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    self.navigationItem.title = @"Archive";
    
    // Bottom Border
    [super viewDidLoad];
    [self.sidemenuButton setAlpha:0];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"MY_CELL"];
    
    self.techniques = [[NSMutableArray alloc] init];
    FMDBDataAccess *db = [[FMDBDataAccess alloc] init];
    self.techniques = [db getCustomers];
    
    [self.toolbar_view setClipsToBounds:YES];
    [self.collectionView setBackgroundColor:[UIColor clearColor]];
    tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    tapRecognizer.delegate=self;
    i = 0;
    tap = NO;
    [self populateCustomers];
   // [self addNewTechniqueButton];
    
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

-(void) populateCustomers
{
    NSString *homeDir = NSHomeDirectory();
    NSLog(@"%@",homeDir);
    self.techniques = [[NSMutableArray alloc] init];
    FMDBDataAccess *db = [[FMDBDataAccess alloc] init];
    self.techniques = [db getCustomers];
     
}

-(void)MySubViewController:(MySubView *) controller didAddCustomer:(Technique *) technique
{
    FMDBDataAccess *db = [[FMDBDataAccess alloc] init];
    [db insertCustomer:technique];
    [self populateCustomers];
    [self.collectionView reloadData];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.globalIndex = [self.techniques indexOfObject:technique];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)populateAndReload{
    [self populateCustomers];
    [self.collectionView reloadData];
}
-(void)viewDidDisappear{
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    tapRecognizer = nil;
   // self.menuViewController.ViewController = nil;
}

-(void)fetchImages:(NSUInteger)idx{
    
    Technique *technique = [self.techniques objectAtIndex:idx];
    NSMutableString *filenamethumb1 = @"%@/";
    NSMutableString *prefix= technique.techniqueimagethumb1;
    filenamethumb1 = [filenamethumb1 mutableCopy];
    [filenamethumb1 appendString: prefix];

    NSArray *sysPaths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
    NSString *docDirectory = [sysPaths objectAtIndex:0];
    NSString *filePath = [NSString stringWithFormat:filenamethumb1, docDirectory];
    UIImage *tempimage = [[UIImage alloc] initWithContentsOfFile:filePath];
    
    /////---------Delegate image to EntryViewController button2 ---------/////////
    NSMutableString *filenamethumb2 = @"%@/";
    NSMutableString *prefix2= technique.techniqueimagethumb2;
    filenamethumb2 = [filenamethumb2 mutableCopy];
    [filenamethumb2 appendString: prefix2];
    
    
    NSArray *sysPaths2 = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
    NSString *docDirectory2 = [sysPaths2 objectAtIndex:0];
    NSString *filePath2 = [NSString stringWithFormat:filenamethumb2, docDirectory2];
    UIImage *tempimage2 = [[UIImage alloc] initWithContentsOfFile:filePath2];
    
    NSLog(@"DOCDIRECTORY %@.",docDirectory2);
    
    NSMutableString *filenamethumb3 = @"%@/";
    NSMutableString *prefix3= technique.techniqueimagethumb3;
    filenamethumb3 = [filenamethumb3 mutableCopy];
    [filenamethumb3 appendString: prefix3];

    NSArray *sysPaths3 = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
    NSString *docDirectory3 = [sysPaths3 objectAtIndex:0];
    NSString *filePath3 = [NSString stringWithFormat:filenamethumb3, docDirectory3];
    UIImage *tempimage3 = [[UIImage alloc] initWithContentsOfFile:filePath3];
    
    NSMutableString *filenamethumb4 = @"%@/";
    NSMutableString *prefix4= technique.techniqueimagethumb4;
    filenamethumb4 = [filenamethumb4 mutableCopy];
    [filenamethumb4 appendString: prefix4];
    
    NSArray *sysPaths4 = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
    NSString *docDirectory4 = [sysPaths4 objectAtIndex:0];
    NSString *filePath4 = [NSString stringWithFormat:filenamethumb4, docDirectory4];
    UIImage *tempimage4 = [[UIImage alloc] initWithContentsOfFile:filePath4];
    
    /////---------Delegate image to EntryViewController buttonBackHead---------/////////
    NSMutableString *filenamethumb5 = @"%@/";
    NSMutableString *prefix5= technique.techniqueimagethumb5;
    filenamethumb5 = [filenamethumb5 mutableCopy];
    [filenamethumb5 appendString: prefix5];
    
    NSArray *sysPaths5 = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
    NSString *docDirectory5 = [sysPaths5 objectAtIndex:0];
    NSString *filePath5 = [NSString stringWithFormat:filenamethumb5, docDirectory5];
    UIImage *tempimage5 = [[UIImage alloc] initWithContentsOfFile:filePath5];
    
    self.image1 = tempimage;
    self.image2 = tempimage2;
    self.image3 = tempimage3;
    self.image4 = tempimage4;
    self.image5 = tempimage5;
   
}




//#pragma mark -Create or Open Database

//#pragma mark -didRecieveMemoryWarning
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

//#pragma mark -Collection View methods
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section;
{
    if(arrayOfTechnique.count==0)
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setInteger:0 forKey:@"Array"];
        [defaults synchronize];
    }
    else
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setInteger:1 forKey:@"Array"];
        [defaults synchronize];
    }
   return [self.techniques count];
}

-(void)updateCollectionView{
}
- (void)userDidSwipe:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        NSLog(@"Gesture Swipe Handled");
    }
}
//#pragma mark LongPressGesture

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


-(void)saveToDatabase{
    
   
   Technique *tech = [self.techniques objectAtIndex:0];
  //  NSLog(@"filename %@", tech.uniqueId);
    NSMutableString * exportingFileName = [tech.uniqueId mutableCopy];
    [exportingFileName appendString:@".htapp"];

    NSArray *sysPaths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
    NSString *docDirectory = [sysPaths objectAtIndex:0];
    NSString *filePath = [docDirectory stringByAppendingPathComponent:exportingFileName];
//    NSData * data = [self dataOfType:filePath error:nil imageName:tech.uniqueId fileName:exportingFileName techniqueName:tech.techniquename maleOrFemale:tech.date];
//
//
//    CKRecord *record = [[CKRecord alloc] initWithRecordType:@"Technique"];
//    [record setValue:data forKey:@"technique"];
//
//    [database saveRecord:record completionHandler:^(CKRecord *record, NSError *error) {
//
//        if(record != nil && error == nil){
//            NSLog(@"Saved");
//        }
//    }];

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
//    SEL selectorNew = NSSelectorFromString(method);
//
//    UIButton *leftCustomButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
//    [leftCustomButton addTarget:self
//                         action:selectorNew
//               forControlEvents:UIControlEventTouchUpInside];
//    [leftCustomButton.widthAnchor constraintEqualToConstant:40].active = YES;
//    [leftCustomButton.heightAnchor constraintEqualToConstant:40].active = YES;
//    [leftCustomButton setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
//    
//    UIBarButtonItem *rename = [[UIBarButtonItem alloc]initWithTitle:@"Rename" style:UIBarButtonItemStylePlain target:self action:@selector(renameTechnique)];
//    NSDictionary * barButtonApperance = @{NSFontAttributeName : [UIFont fontWithName:@"AvenirNext-DemiBold" size:16.0], NSForegroundColorAttributeName: [UIColor colorNamed:@"textWhiteDeepBlue"]};
//    [rename setTitleTextAttributes:barButtonApperance forState:UIControlStateNormal];
//    [rename setTitleTextAttributes:barButtonApperance forState:UIControlStateHighlighted];
//    [rename setTitleTextAttributes:barButtonApperance forState:UIControlStateSelected];
//    UIBarButtonItem * leftButtonItem =[[UIBarButtonItem alloc] initWithCustomView:leftCustomButton];
//
//    if([method isEqualToString:@"showConfirmationPopOver"]){
//        self.navigationItem.leftBarButtonItems = @[leftButtonItem, rename];
//        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
//    }
//    else {
//
//        self.navigationItem.leftBarButtonItems = @[leftButtonItem];
//        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
//    }
   
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
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




//#pragma mark Collection View Delegate Methods

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    Cell *cell = [cv dequeueReusableCellWithReuseIdentifier:OldCellID forIndexPath:indexPath];
    
    if(self.isSelectionActivated)
    {
        [cell setIsCheckHidden:NO];
    }
    else {
        [cell setIsCheckHidden:YES];
    }
    
    //[cell hideBar];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        [cell.contentView.layer setCornerRadius:15.0f];
        cell.clipsToBounds = YES;
        cell.contentView.layer.masksToBounds = YES;
        cell.layer.shadowColor = [UIColor blackColor].CGColor;
        cell.layer.shadowOffset = CGSizeMake(0,0);
        cell.layer.shadowRadius = 3.0f;
        cell.layer.shadowOpacity = 0.1f;
        cell.layer.masksToBounds = NO;
    
//        cell.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:cell.bounds cornerRadius:cell.contentView.layer.cornerRadius].CGPath;
    
    Technique *technique = [self.techniques objectAtIndex:indexPath.row];
 
    cell.dateLabel.text = technique.techniquename;
    NSMutableString *prefix;

    if(technique.uniqueId == NULL){
            prefix = [technique.techniquename mutableCopy];
    }else {
        prefix = [technique.uniqueId mutableCopy];
    }

    NSMutableString *filenamethumb = [@"%@/" mutableCopy];
    filenamethumb = [filenamethumb mutableCopy];
    [filenamethumb appendString: prefix];
    filenamethumb = [filenamethumb mutableCopy];
    [filenamethumb appendString: @"Entry"];
    filenamethumb = [filenamethumb mutableCopy];
    [filenamethumb appendString: @".png"];
   
    NSLog(@"file name unique %@", filenamethumb );
  //  if ([technique.techniquename isEqualToString:@"BB"]){
    
    if ([technique.techniquename isEqualToString:tempstring]){
    indexpathtemp = indexPath;
    }
    NSArray *sysPaths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
    NSString *docDirectory = [sysPaths objectAtIndex:0];
    NSString *filePath = [NSString stringWithFormat:filenamethumb, docDirectory];
    UIImage *tempimage = [[UIImage alloc] initWithContentsOfFile:filePath];
    
    
    cell.image.image = tempimage;
    cell.cellIndex = indexPath;

        CGSize  newsize;
        newsize = CGSizeMake(CGRectGetWidth(cell.frame), (CGRectGetHeight(cell.frame)));
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        cell.image.frame = CGRectMake(0, -10, cell.frame.size.width , cell.frame.size.height);         //[cell.contentView.layer setCornerRadius:15.0f];
    // }
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(renamePressed:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    [cell.dateLabel addGestureRecognizer:tapGestureRecognizer];
    cell.dateLabel.userInteractionEnabled = YES;
    
    if (![technique.date isEqualToString:@"version22"] && ![technique.date isEqualToString:@"men22"]){
        cell.image.frame = CGRectMake(0, -20, cell.frame.size.width , cell.frame.size.height);
     //   cell.viewModeLabel.alpha = 0;
        cell.newVersionDiagram = NO;
    }
    else {
        cell.newVersionDiagram = YES;

       cell.image.frame = CGRectMake(0, -15, cell.frame.size.width , cell.frame.size.height);
        //cell.viewModeLabel.alpha = 0;
    }
    
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
    
    if([segue.identifier isEqualToString:@"EntryViewController"])
    {
        UINavigationController *navigationController = segue.destinationViewController;
        
        EntryViewController* entryViewController = [[navigationController viewControllers] objectAtIndex:0];
        
        entryViewController.delegate1 = self;
    
    }
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

-(UIImage*)loadImages:(NSString*)prefix{
    
    NSMutableString *filenamethumb1 = [@"%@/" mutableCopy];
    //NSMutableString *prefix = [prefix mutableCopy];
    filenamethumb1 = [filenamethumb1 mutableCopy];
    [filenamethumb1 appendString: prefix];
    
    NSArray *sysPaths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
    NSString *docDirectory = [sysPaths objectAtIndex:0];
    NSString *filePath = [NSString stringWithFormat:filenamethumb1, docDirectory];
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:filePath];
    NSLog(@"DOCDIRECTORY %@.",docDirectory);
    return image;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    EntryViewController *entryVC = [self.storyboard instantiateViewControllerWithIdentifier:@"EntryViewController"];
    Technique *technique = [self.techniques objectAtIndex:[indexPath row]];
        
    self.image1 = [self loadImages:technique.techniqueimagethumb1];
    self.image2 = [self loadImages:technique.techniqueimagethumb2];
    self.image3 = [self loadImages:technique.techniqueimagethumb3];
    self.image4 = [self loadImages:technique.techniqueimagethumb4];
    self.image5 = [self loadImages:technique.techniqueimagethumb5];
    
    Cell *cell = (Cell *)[collectionView  cellForItemAtIndexPath:indexPath];
    
    if(!self.isSelectionActivated){
        //if(![technique.date isEqualToString:@"version22"] && ![technique.date isEqualToString:@"men22"]){
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            appDelegate.myGlobalName = technique.techniquename;
            self.sendImagenameToControllers = technique.techniquename;
            appDelegate.globalDate = technique.date;
            entryVC.stringFromTextfield = self.sendImagenameToControllers;
            
            entryVC.entryImage1 = self.image1;
            entryVC.entryImage2 = self.image2;
            entryVC.entryImage3 = self.image3;
            entryVC.entryImage4 = self.image4;
            entryVC.entryImage5 = self.image5;
            entryVC.appVersion = technique.date;
            
            entryVC.navigationItem.title = technique.techniquename;
            cell.contentView.layer.cornerRadius = 15.0f;
            [HapticHelper generateFeedback:FeedbackType_Impact_Medium ];
            [self.navigationController pushViewController: entryVC animated:YES];
    }
    else {
        // cell.checkItem.hidden = NO;
        [self selectCell:cell];
        indexOfSelectedCell = indexPath;
        [self setupRightNavigationItem:@"Cancel" selector:@"removeOrangeLayer"];
       // [self setupInfoButton:@"trash_edited" selector:@"showConfirmationPopOver"];
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
            cell.deleteBtn.hidden = NO;


        }else {
            [cell setIsHidden:YES];
            cell.checker.hidden = YES;
            cell.cell_menu_btn.hidden = YES;
            cell.cell_rename_btn.hidden = YES;


        }

}
-(void)cancelCellSelection{

    for (NSIndexPath *indexPath in [self.collectionView indexPathsForSelectedItems]) {
        [self.collectionView deselectItemAtIndexPath:indexPath animated:NO];
        Cell * cell = (Cell *)[self.collectionView cellForItemAtIndexPath:indexPath];
        [cell setIsHidden:YES];
        longpresscell.enabled = YES;
    }
        for (NSInteger row = 0; row < [self.collectionView numberOfItemsInSection:0]; row++) {
            Cell * cell2 =   (Cell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
        cell2.checkItem.hidden = YES;
            cell2.checker.hidden = YES;
            cell2.cell_menu_btn.hidden = YES;
            cell2.cell_rename_btn.hidden = YES;
            cell2.shareBtn.hidden = YES;

            longpresscell.enabled = YES;
    }
}
-(void)openSubView:(id)sender
    {
//       MySubView *mysubview  = [self.storyboard instantiateViewControllerWithIdentifier:@"subView"];
//        mysubview.delegate = self;
//       // [self presentViewController:mysubview animated:YES completion:nil];
//        mysubview.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
//        mysubview.modalPresentationStyle = UIModalPresentationFullScreen;
//        [self.navigationController presentViewController:mysubview animated:YES completion:nil];
        
        /* version 2022
        MySubView *mysubview  = [self.storyboard instantiateViewControllerWithIdentifier:@"subView"];
        mysubview.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        mysubview.modalPresentationStyle = UIModalPresentationFullScreen;
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:mysubview];
        [self presentViewController:nc animated:YES completion:nil];
*/
        
        [HapticHelper generateFeedback:FeedbackType_Impact_Light];

        MySubView *mysubview  = [self.storyboard instantiateViewControllerWithIdentifier:@"subView"];
        mysubview.delegate = self;
        NameViewController *nameView  = [self.storyboard instantiateViewControllerWithIdentifier:@"NameViewController"];
        nameView.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        nameView.modalPresentationStyle = UIModalPresentationFullScreen;
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:nameView];
        [self presentViewController:nc animated:YES completion:nil];

        
 
    }
//#pragma mark -passItemBack Method

-(void) passItemBack:(MySubView *)controller didFinishWithItem:(NSString*)item{
   tempstring = item;
   NSLog(@"text From subView %@", item);
}

//#pragma mark -Save and Reload methods
- (void) saveData:(NSString *)namefortech{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    ////////------SAVE DATA TO THE DATABASE-------------------------///////
    self.convertedLabel = namefortech;
  
    NSMutableString *bfcol =@"Entry";
    foothumb =self.convertedLabel;
    foothumb = [self.convertedLabel mutableCopy];
    [foothumb appendString:bfcol];
    foothumb= [foothumb mutableCopy];
    [foothumb appendString:@".png"];
    NSLog(@"Результат in vc: %@.",foothumb);
    
    /////-----------Name for  thumbimage1 ---------------//////////
    
    self.convertedLabel =namefortech;
    NSMutableString *bf1 =@"thumb1";
    foothumb1 =self.convertedLabel;
    foothumb1 = [self.convertedLabel mutableCopy];
    [foothumb1 appendString:bf1];
    foothumb1= [foothumb1 mutableCopy];
    [foothumb1 appendString:@".png"];
    NSLog(@"Результат in vc: %@.",foothumb1);
    /////-----------Name for  thumbimage2 ---------------//////////
    
    self.convertedLabel =namefortech;
    
    NSMutableString *bf2 =@"thumb2";
    foothumb2 =self.convertedLabel;
    foothumb2 = [self.convertedLabel mutableCopy];
    [foothumb2 appendString:bf2];
    foothumb2= [foothumb2 mutableCopy];
    [foothumb2 appendString:@".png"];
    NSLog(@"Результат in vc: %@.",foothumb2);
    
    /////-----------Name for  thumbimage3 ---------------//////////
    self.convertedLabel =namefortech;
    NSMutableString *bf3 =@"thumb3";
    foothumb3 =self.convertedLabel;
    foothumb3 = [self.convertedLabel mutableCopy];
    [foothumb3 appendString:bf3];
    foothumb3= [foothumb3 mutableCopy];
    [foothumb3 appendString:@".png"];
    NSLog(@"Результат in vc: %@.",foothumb3);
    
    /////-----------Name for  thumbimage1 ---------------//////////
    self.convertedLabel =namefortech;
    NSMutableString *bf4 =@"thumb4";
    foothumb4 =self.convertedLabel;
    foothumb4 = [self.convertedLabel mutableCopy];
    [foothumb4 appendString:bf4];
    foothumb4= [foothumb4 mutableCopy];
    [foothumb4 appendString:@".png"];
    NSLog(@"Результат in vc: %@.",foothumb4);
    
    /////-----------Name for  thumbimage5 ---------------//////////
    self.convertedLabel =namefortech;
    NSMutableString *bf5 =@"thumb5";
    foothumb5 =self.convertedLabel;
    foothumb5 = [self.convertedLabel mutableCopy];
    [foothumb5 appendString:bf5];
    foothumb5= [foothumb5 mutableCopy];
    [foothumb5 appendString:@".png"];
    NSLog(@"Результат in vc: %@.",foothumb5);
    
    /////-----------Name for  bigimage1 ---------------//////////
    self.convertedLabel =namefortech;
    NSMutableString *bfb1 =@"big1";
    foobig1 =self.convertedLabel;
    foobig1 = [self.convertedLabel mutableCopy];
    [foobig1 appendString:bfb1];
    foobig1= [foobig1 mutableCopy];
    [foobig1 appendString:@".png"];
    NSLog(@"Результат in vc: %@.",foobig1);
    
    /////-----------Name for  bigimage2---------------//////////
    self.convertedLabel =namefortech;
    NSMutableString *bfb2 =@"big2";
    foobig2 =self.convertedLabel;
    foobig2 = [self.convertedLabel mutableCopy];
    [foobig2 appendString:bfb2];
    foobig2= [foobig2 mutableCopy];
    [foobig2 appendString:@".png"];
    NSLog(@"Результат in vc: %@.",foobig2);
    
    /////-----------Name for  bigimage3---------------//////////
    self.convertedLabel =namefortech;
    NSMutableString *bfb3 =@"big3";
    foobig3 =self.convertedLabel;
    foobig3 = [self.convertedLabel mutableCopy];
    [foobig3 appendString:bfb3];
    foobig3= [foobig3 mutableCopy];
    [foobig3 appendString:@".png"];
    NSLog(@"Результат: %@.",foobig3);
    
    /////-----------Name for  bigimage4---------------//////////
    self.convertedLabel =namefortech;
    NSMutableString *bfb4 =@"big4";
    foobig4 =self.convertedLabel;
    foobig4 = [self.convertedLabel mutableCopy];
    [foobig4 appendString:bfb4];
    foobig4= [foobig4 mutableCopy];
    [foobig4 appendString:@".png"];
    NSLog(@"Результат: %@.",foobig4);
    
    /////-----------Name for  bigimage5---------------//////////
    self.convertedLabel =namefortech;
    NSMutableString *bfb5 =@"big5";
    foobig5 =self.convertedLabel;
    foobig5 = [self.convertedLabel mutableCopy];
    [foobig5 appendString:bfb5];
    foobig5= [foobig5 mutableCopy];
    [foobig5 appendString:@".png"];
    NSLog(@"Результат: %@.",foobig5);
    
}

- (void)reloadMyCollection
{
    NSLog(@"xxx Reload My Collection ");

[[self collectionView ] reloadData];
}

-(void)colorCellFrame:(UICollectionViewCell*)cell
{
    
    UIColor *fillColor = [UIColor colorWithRed:30.0/255.0 green:135.0/255.0 blue:220.0/255.0 alpha:1.0];
    cell.contentView.backgroundColor =  fillColor;
    [cell.layer setBorderColor:fillColor.CGColor];
     [cell.layer setBorderWidth:4.0f];
    [cell.layer setBackgroundColor:fillColor.CGColor];
    [cell.layer setCornerRadius:15.0f];
    //[self.layer setOpacity:0.7f];
    
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

//        NSLog(@"AppDelegate MYGlobalNameREAL = %@",appDelegate.cellNameForDelete);
    
//        __block NSUInteger index = NSUIntegerMax;
//
//        [self.techniques enumerateObjectsUsingBlock: ^ (Technique* technique, NSUInteger idx, BOOL* stop) {
//            //if([technique.techniquename isEqualToString:appDelegate.cellNameForDelete])
//            if(idx == indexOfSelectedCell)
//            {
//                index = idx;
//                *stop = YES;
//            }
//        }];
        
        Cell * cell = (Cell *)[self.collectionView cellForItemAtIndexPath:indexOfSelectedCell];
        [self selectCell:cell];
        
        Technique *technique = [self.techniques objectAtIndex:indexOfSelectedCell.row];
        FMDBDataAccess *db = [[FMDBDataAccess alloc] init];
        [db deleteCustomer:technique];
        
       // [CloudKitManager removeRecordWithId:technique.uniqueId completionHandler:^(NSArray *results, NSError *error) {
            //NSLog(@"Record removed");
        //}];
        
        if(technique.uniqueId == NULL){
            [self removeImage:technique.techniquename];
        }else {
            [self removeImage:technique.uniqueId];
        }
        
        
        [self populateCustomers];
        [[self collectionView ] reloadData];
        [self checkArrayCount];
        self.navigationItem.leftBarButtonItems = nil;

        if(self.techniques.count == 0){
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
    
    NSMutableString * json_l = [self getFileName:fileName prefix:@"lefthead.json"];
    NSMutableString * json_r = [self getFileName:fileName prefix:@"righthead.json"];
    NSMutableString * json_t = [self getFileName:fileName prefix:@"tophead.json"];
    NSMutableString * json_f = [self getFileName:fileName prefix:@"fronthead.json"];
    NSMutableString * json_b = [self getFileName:fileName prefix:@"backhead.json"];
    
    NSMutableString * filenamethumb = [self getFileName:fileName prefix:@"Entry.png"];
    NSMutableString * filenamethumb1 = [self getFileName:fileName prefix:@"thumb1.png"];
    NSMutableString * filenamethumb2 = [self getFileName:fileName prefix:@"thumb2.png"];
    NSMutableString * filenamethumb3 = [self getFileName:fileName prefix:@"thumb3.png"];
    NSMutableString * filenamethumb4 = [self getFileName:fileName prefix:@"thumb4.png"];
    NSMutableString * filenamethumb5 = [self getFileName:fileName prefix:@"thumb5.png"];

    NSMutableString * filenamebig1 = [self getFileName:fileName prefix:@"big1.png"];
    NSMutableString * filenamebig2 = [self getFileName:fileName prefix:@"big2.png"];
    NSMutableString * filenamebig3 = [self getFileName:fileName prefix:@"big3.png"];
    NSMutableString * filenamebig4 = [self getFileName:fileName prefix:@"big4.png"];
    NSMutableString * filenamebig5 = [self getFileName:fileName prefix:@"big5.png"];
    NSMutableString * filenamebig0 = [self getFileName:fileName prefix:@"EntryBig.png"];

    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,   YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *fullPath0 = [documentsDirectory stringByAppendingPathComponent:
                          [NSString stringWithFormat:@"%@",filenamethumb]];
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:
                          [NSString stringWithFormat:@"%@",filenamethumb1]];
    NSString *fullPath2 = [documentsDirectory stringByAppendingPathComponent:
                          [NSString stringWithFormat:@"%@",filenamethumb2]];
    NSString *fullPath3 = [documentsDirectory stringByAppendingPathComponent:
                          [NSString stringWithFormat:@"%@",filenamethumb3]];
    NSString *fullPath4 = [documentsDirectory stringByAppendingPathComponent:
                           [NSString stringWithFormat:@"%@", filenamethumb4]];
    NSString *fullPath5 = [documentsDirectory stringByAppendingPathComponent:
                           [NSString stringWithFormat:@"%@", filenamethumb5]];
    
    NSString *fullPathbig1 = [documentsDirectory stringByAppendingPathComponent:
                          [NSString stringWithFormat:@"%@",filenamebig1]];
    NSString *fullPathbig2 = [documentsDirectory stringByAppendingPathComponent:
                              [NSString stringWithFormat:@"%@",filenamebig2]];
    NSString *fullPathbig3 = [documentsDirectory stringByAppendingPathComponent:
                              [NSString stringWithFormat:@"%@",filenamebig3]];
    NSString *fullPathbig4 = [documentsDirectory stringByAppendingPathComponent:
                              [NSString stringWithFormat:@"%@",filenamebig4]];
    NSString *fullPathbig5 = [documentsDirectory stringByAppendingPathComponent:
                              [NSString stringWithFormat:@"%@",filenamebig5]];
    NSString *fullPathbig0 = [documentsDirectory stringByAppendingPathComponent:
                              [NSString stringWithFormat:@"%@",filenamebig0]];
    NSString *jsonPath_l = [documentsDirectory stringByAppendingPathComponent:
                              [NSString stringWithFormat:@"%@",json_l]];
    NSString *jsonPath_r = [documentsDirectory stringByAppendingPathComponent:
                              [NSString stringWithFormat:@"%@",json_r]];
    NSString *jsonPath_t = [documentsDirectory stringByAppendingPathComponent:
                              [NSString stringWithFormat:@"%@",json_t]];
    NSString *jsonPath_f = [documentsDirectory stringByAppendingPathComponent:
                              [NSString stringWithFormat:@"%@",json_f]];
    NSString *jsonPath_b = [documentsDirectory stringByAppendingPathComponent:
                              [NSString stringWithFormat:@"%@",json_b]];
    
    [fileManager removeItemAtPath: fullPath0 error:NULL];
    [fileManager removeItemAtPath: fullPath error:NULL];
    [fileManager removeItemAtPath: fullPath2 error:NULL];
    [fileManager removeItemAtPath: fullPath3 error:NULL];
    [fileManager removeItemAtPath: fullPath4 error:NULL];
    [fileManager removeItemAtPath: fullPath5 error:NULL];

    [fileManager removeItemAtPath:fullPathbig1 error:NULL];
    [fileManager removeItemAtPath:fullPathbig2 error:NULL];
    [fileManager removeItemAtPath:fullPathbig3 error:NULL];
    [fileManager removeItemAtPath:fullPathbig4 error:NULL];
    [fileManager removeItemAtPath:fullPathbig5 error:NULL];
    [fileManager removeItemAtPath:fullPathbig0 error:NULL];
    
    [fileManager removeItemAtPath:jsonPath_l error:NULL];
    [fileManager removeItemAtPath:jsonPath_r error:NULL];
    [fileManager removeItemAtPath:jsonPath_t error:NULL];
    [fileManager removeItemAtPath:jsonPath_f error:NULL];
    [fileManager removeItemAtPath:jsonPath_b error:NULL];
    NSError *error = nil;
    if(![fileManager removeItemAtPath: fullPath error:&error]) {
        NSLog(@"Delete failed:%@", error);
    } else {
        NSLog(@"image removed: %@", fullPath);
    }
    
    NSString *appFolderPath = [[NSBundle mainBundle] resourcePath];
    NSLog(@"Directory Contents:\n%@", [fileManager directoryContentsAtPath: appFolderPath]);
}

- (IBAction)showSideMenu:(id)sender{
//[self.menuViewController presentFromViewController:self animated:YES completion:nil];

}


- (void) receiveTestNotification:(NSNotification *)notification
{
    if ([[notification name] isEqualToString:@"showPopOld"])
    {
//        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//        NSLog(@"AppDelegate MYGlobalNameREAL = %@",appDelegate.cellNameForDelete);
//        __block NSUInteger index = NSUIntegerMax;
//
//        [self.techniques enumerateObjectsUsingBlock: ^ (Technique* technique, NSUInteger idx, BOOL* stop) {
//            if([technique.techniquename isEqualToString:appDelegate.cellNameForDelete])
//            {
//                index = idx;
//                *stop = YES;
//            }
//        }];
//        renameIndexPath = index;

        //Technique *tech = [self.techniques objectAtIndex:index];
        Technique *tech = [self.techniques objectAtIndex:[indexOfSelectedCell row]];
        HMPopUpView *hmPopUp = [[HMPopUpView alloc] initWithTitle:@"Rename diagram" okButtonTitle:@"Ok" cancelButtonTitle:@"Cancel" okBtnColor:[UIColor colorNamed:@"orange"] delegate:self];
    
    [hmPopUp configureHMPopUpViewWithBGColor:[UIColor colorNamed:@"whiteDark"] titleColor: [UIColor colorNamed:@"textWhiteDeepBlue"] buttonViewColor:[UIColor colorNamed:@"whiteDark"] buttonBGColor:[UIColor colorNamed:@"whiteDark"] buttonTextColor: [UIColor colorNamed:@"textWhiteDeepBlue"]];
    [hmPopUp showInView:self.view];
    [hmPopUp setTextFieldText:tech.techniquename];
        
     
    }
   
}

//- (void) receiveTestNotification2:(NSNotification *)notification
//{
//    
//    if ([[notification name] isEqualToString:@"hideAllBars"])
//    {
//        
//        for (Cell *cell in [self.collectionView visibleCells]) {
//            [cell hideBar];
//        }
//        
//    }
//    
//}


- (void) receiveTestNotification3:(NSNotification *)notification
{
    
    if ([[notification name] isEqualToString:@"showDeletePopOld"])
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

-(void)renameTechniqueDelegate:(NSString*)txtField{
   
    Technique *technique = [self.techniques objectAtIndex:indexOfSelectedCell.row];
    FMDBDataAccess *db = [[FMDBDataAccess alloc] init];
    [db deleteCustomer:technique];
    [self populateCustomers];
    
    if(technique.uniqueId == NULL){
        NSMutableString * filenamethumb = [self getNameOnRenaming:txtField prefix:@"Entry.png"];
        NSMutableString * filenamethumb1 = [self getNameOnRenaming:txtField prefix:@"thumb1.png"];
        NSMutableString * filenamethumb2 = [self getNameOnRenaming:txtField prefix:@"thumb2.png"];
        NSMutableString * filenamethumb3 = [self getNameOnRenaming:txtField prefix:@"thumb3.png"];
        NSMutableString * filenamethumb4 = [self getNameOnRenaming:txtField prefix:@"thumb4.png"];
        NSMutableString * filenamethumb5 = [self getNameOnRenaming:txtField prefix:@"thumb5.png"];
        NSMutableString * filenamebig1 = [self getNameOnRenaming:txtField prefix:@"big1.png"];
        NSMutableString * filenamebig2 = [self getNameOnRenaming:txtField prefix:@"big2.png"];
        NSMutableString * filenamebig3 = [self getNameOnRenaming:txtField prefix:@"big3.png"];
        NSMutableString * filenamebig4 = [self getNameOnRenaming:txtField prefix:@"big4.png"];
        NSMutableString * filenamebig5 = [self getNameOnRenaming:txtField prefix:@"big5.png"];
        NSMutableString * json_l = [self getNameOnRenaming:txtField prefix:@"lefthead.json"];
        NSMutableString * json_r = [self getNameOnRenaming:txtField prefix:@"righthead.json"];
        NSMutableString * json_t = [self getNameOnRenaming:txtField prefix:@"tophead.json"];
        NSMutableString * json_f = [self getNameOnRenaming:txtField prefix:@"fronthead.json"];
        NSMutableString * json_b = [self getNameOnRenaming:txtField prefix:@"backhead.json"];
        
        [self changeFileName:technique.techniquename to:txtField];
        [self changeFileName:technique.techniqueimage to:filenamethumb];
        [self changeFileName:technique.techniqueimagethumb1 to:filenamethumb1];
        [self changeFileName:technique.techniqueimagethumb2 to:filenamethumb2];
        [self changeFileName:technique.techniqueimagethumb3 to:filenamethumb3];
        [self changeFileName:technique.techniqueimagethumb4 to:filenamethumb4];
        [self changeFileName:technique.techniqueimagethumb5 to:filenamethumb5];
        [self changeFileName:technique.techniqueimagebig1 to:filenamebig1];
        [self changeFileName:technique.techniqueimagebig2 to:filenamebig2];
        [self changeFileName:technique.techniqueimagebig3 to:filenamebig3];
        [self changeFileName:technique.techniqueimagebig4 to:filenamebig4];
        [self changeFileName:technique.techniqueimagebig5 to:filenamebig5];
        
        [self changeFileName:[self getNameOnRenaming:technique.techniquename prefix:@"lefthead.json"] to:json_l];
        [self changeFileName:[self getNameOnRenaming:technique.techniquename prefix:@"righthead.json"] to:json_r];
        [self changeFileName:[self getNameOnRenaming:technique.techniquename prefix:@"tophead.json"] to:json_t];
        [self changeFileName:[self getNameOnRenaming:technique.techniquename prefix:@"fronthead.json"] to:json_f];
        [self changeFileName:[self getNameOnRenaming:technique.techniquename prefix:@"backhead.json"] to:json_b];
        
        technique.techniquename = txtField;
        technique.techniqueimage = filenamethumb;
        technique.techniqueimagethumb1 = filenamethumb1;
        technique.techniqueimagethumb2 = filenamethumb2;
        technique.techniqueimagethumb3 = filenamethumb3;
        technique.techniqueimagethumb4 = filenamethumb4;
        technique.techniqueimagethumb5 = filenamethumb5;
        technique.techniqueimagebig1 = filenamebig1;
        technique.techniqueimagebig2 = filenamebig2;
        technique.techniqueimagebig3 = filenamebig3;
        technique.techniqueimagebig4 = filenamebig4;
        technique.techniqueimagebig5 = filenamebig5;
    }else {
        technique.techniquename = txtField;
    }
    [db insertCustomer:technique];
    [self populateCustomers];
    [self.collectionView reloadData];
    //self.navigationItem.leftBarButtonItems = nil;
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



-(BOOL)checkEnteredName:(NSString*)txtField{
    
    NSMutableString *bfcol1 =@"thumb1";
    rfoothumb1 = txtField;
    rfoothumb1 = [txtField mutableCopy];
    [rfoothumb1 appendString:bfcol1];
    rfoothumb1= [rfoothumb1 mutableCopy];
    [rfoothumb1 appendString:@".png"];
    NSLog(@"Результат in textfield: %@.",rfoothumb1);
    
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSString *foofile = [documentsPath stringByAppendingPathComponent:rfoothumb1];
    BOOL fileExist = [[NSFileManager defaultManager] fileExistsAtPath:foofile];
    return fileExist;
}

//#pragma mark SYNCHRONIZATION



@end
