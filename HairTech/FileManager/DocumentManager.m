//
//  DocumentManager.m
//  SoItGoesApp
//
//  Created by Alexander Prent on 01.03.2023.
//

#import "DocumentManager.h"

@implementation DocumentManager

+ (BOOL)documentExists: (NSString *)name {
    
    NSURL *path = [[self documentDirectory] URLByAppendingPathComponent:name];
    NSLog(@" path %@", path);

    return [[NSFileManager defaultManager] fileExistsAtPath:path.path];
}

+ (NSURL *)documentDirectory {
    return [self ubiquitousDocumentsDirectoryURL];
    //return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
}

+(NSURL*)ubiquitousDocumentsDirectoryURL {
    return [[self ubiquitousContainerURL] URLByAppendingPathComponent:@"Documents"];
}
+(NSURL*)ubiquitousContainerURL {
    return [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil];
}
@end
