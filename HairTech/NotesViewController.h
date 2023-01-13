#import <UIKit/UIKit.h>
#import "CommentTextView.h"

@protocol NotesViewDelegate <NSObject>
-(void)saveNote:(NSString*)note;
@end
@interface NotesViewController : UIViewController <UITextViewDelegate>

{
   
 }

- (IBAction)closeNotes:(id)sender;
- (void)initWithView:(UIView *)p;

@property(nonatomic, retain) UIView *parent;

@property (nonatomic,weak) id<NotesViewDelegate> delegate;

@property (nonatomic,weak) NSString *textOfTextView;
@property (weak, nonatomic) IBOutlet CommentTextView *textView1;

@end

