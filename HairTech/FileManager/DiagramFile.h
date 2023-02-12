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
-(NSMutableDictionary*)openFileAtURL:(NSString*)fileName error:(NSError **)outError;
-(void)openFileAtPath:(NSString*)fileName error:(NSError **)outError;
-(void)saveDiagramToFile:(NSString*)techniqueName;
-(void)clearAllSaveData;
-(void)saveDiagramToCloud:(NSString*)techniqueName;


@property NSString * uuid;
@property NSString * techniqueName;
@property NSString * maleFemale;
@property NSString * note;
@property NSString * favorite;

@property UIImage * imageLeft;
@property UIImage * imageRight;
@property UIImage * imageTop;
@property UIImage * imageFront;
@property UIImage * imageBack;
@property NSMutableDictionary * tempDict;

@end

NS_ASSUME_NONNULL_END
