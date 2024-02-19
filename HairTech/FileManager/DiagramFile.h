//
//  NSObject+DiagramFile.h
//  hairtech
//
//  Created by Alexander Prent on 10.02.2023.
//  Copyright © 2023 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DiagramFile : NSObject

+ (DiagramFile*) sharedInstance;
+(void)setSharedInstance:(DiagramFile *)instance;
+ (void)resetSharedInstance;


-(void)storeFileDataInObject:(NSData*)data fileName:(NSString*) fileName error:(NSError **)outError;
-(NSData*)dataFromDictionary;
@property NSMutableDictionary * diagramFileDictionary;

@property NSString * uuid;
@property NSString * techniqueName;
@property NSString * maleFemale;
@property NSString * note;
@property NSString * favorite;

@property UIImage * imageEntry;
@property UIImage * imageLeft;
@property UIImage * imageRight;
@property UIImage * imageTop;
@property UIImage * imageFront;
@property UIImage * imageBack;

@property NSDictionary * dictLeft;
@property NSDictionary * dictRight;
@property NSDictionary * dictTop;
@property NSDictionary * dictFront;
@property NSDictionary * dictBack;
@property NSMutableArray * photoArray;



@end

NS_ASSUME_NONNULL_END
