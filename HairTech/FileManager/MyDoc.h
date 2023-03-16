//
//  MyDoc.h
//  SoItGoesApp
//
//  Created by Alexander Prent on 01.03.2023.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyDoc : UIDocument

@property (nonatomic, assign) NSInteger number;


+ (instancetype)sharedInstance;

+ (void)documentNamed: (NSString *)name withCompletion: (void (^)(MyDoc *doc))completionHandler;

@property NSString * fileNameFromFile;

@property NSMutableDictionary * diagramFileDictionary;
@property NSURL * fileURL;
@property NSString * uuid;
@property NSString * techniqueName;
@property NSString * maleFemale;
@property NSString * note;
@property NSString * favorite;

@property NSString * creationDate;
@property NSString * modificationDate;

@property UIImage * imageEntry;
@property UIImage * imageLeft;
@property UIImage * imageRight;
@property UIImage * imageTop;
@property UIImage * imageFront;
@property UIImage * imageBack;

@property NSData * dictLeft;
@property NSData * dictRight;
@property NSData * dictTop;
@property NSData * dictFront;
@property NSData * dictBack;

@end

NS_ASSUME_NONNULL_END
