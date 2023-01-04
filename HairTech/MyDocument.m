//
//  NSObject+MyDocument.m
//  hairtech
//
//  Created by Alexander Prent on 30.12.2022.
//  Copyright © 2022 Admin. All rights reserved.
//

#import "MyDocument.h"

@implementation MyDocument
@synthesize zipDataContent;

// Called whenever the application reads data from the file system
- (BOOL)loadFromContents:(id)contents ofType:(NSString *)typeName error:(NSError **)outError
{
    self.zipDataContent = [[NSData alloc] initWithBytes:[contents bytes] length:[contents length]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"noteModified" object:self];
    return YES;
}

// Called whenever the application (auto)saves the content of a note
- (id)contentsForType:(NSString *)typeName error:(NSError **)outError
{
    return self.zipDataContent;
}

@end
