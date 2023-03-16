//
//  DocumentManager.h
//  SoItGoesApp
//
//  Created by Alexander Prent on 01.03.2023.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DocumentManager : NSObject


+ (NSURL *)documentDirectory;

+ (BOOL)documentExists: (NSString *)name;

+(NSURL*)ubiquitousDocumentsDirectoryURL;
+(NSMutableArray*)getArrayOfFilesInDirectory;

@end

NS_ASSUME_NONNULL_END
