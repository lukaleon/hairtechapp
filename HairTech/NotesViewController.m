
#import "NotesViewController.h"

@interface NotesViewController ()


@end

@implementation NotesViewController


- (void)viewDidLoad
{
    
    [self setupNavigationBar];
    NSLog(@"text from nrc = %@",self.textOfTextView);
    self.textView1.delegate = self;
    [self.textView1 setText:self.textOfTextView];
    [super viewDidLoad];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [self.delegate saveNote:self.textView1.text];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)textViewDidChange:(UITextView *)txtView{
    
    if(self.textView1.text.length == 0 ){
        [self.textView1 setPlaceHolderLabelVisible:YES];
    }
    else {
        [self.textView1 setPlaceHolderLabelVisible:NO];

    }
}
- (IBAction)closeNotes:(id)sender {
    NSLog(@"close notes");
  //[self.delegate saveNote:self.textView1.text];
    
    //[self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)setupNavigationBar{
        UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
        [appearance configureWithTransparentBackground];
        appearance.backgroundColor = [UIColor clearColor];
        appearance.shadowColor =  [UIColor clearColor];
        appearance.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor colorNamed:@"textWhiteDeepBlue"], NSFontAttributeName:[UIFont fontWithName:@"AvenirNext-Bold" size:18]};
        self.navigationItem.standardAppearance = appearance;
        self.navigationItem.scrollEdgeAppearance = appearance;

    UIButton *more = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width -  60, 20, 40, 40)];
    [more addTarget:self
             action:@selector(closeNotes:)
   forControlEvents:UIControlEventTouchUpInside];
    [more.widthAnchor constraintEqualToConstant:30].active = YES;
    [more.heightAnchor constraintEqualToConstant:30].active = YES;
    
    CGFloat pts = [UIFont buttonFontSize];
    UIImageSymbolConfiguration* conf = [UIImageSymbolConfiguration configurationWithPointSize:pts weight:UIImageSymbolWeightSemibold];
    [more setImage:[UIImage systemImageNamed:@"xmark" withConfiguration:conf] forState:UIControlStateNormal];
    [more setTintColor:[UIColor colorNamed:@"textWhiteDeepBlue"]];
//    UIBarButtonItem * moreBtn =[[UIBarButtonItem alloc] initWithCustomView:more];
//    self.navigationItem.leftBarButtonItem = moreBtn;
    [self.view addSubview:more];
}
@end

