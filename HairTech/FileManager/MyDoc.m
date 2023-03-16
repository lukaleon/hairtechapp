//
//  MyDoc.m
//  SoItGoesApp
//
//  Created by Alexander Prent on 01.03.2023.
//

#import "MyDoc.h"
#import "DocumentManager.h"




@implementation MyDoc

//static MyDoc *sharedInstance = nil;
//+ (instancetype)sharedInstance {
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        sharedInstance = [[self alloc] initWithFileURL:[MyDoc url]];
//    });
//    return sharedInstance;
//}



+ (void)documentNamed: (NSString *)name withCompletion: (void (^)(MyDoc *doc))completionHandler {
    
//    NSString *fileName = [name stringByAppendingString:@".SIG"];
    
    NSURL *documentDirURL = [[DocumentManager documentDirectory] URLByAppendingPathComponent:name];
    MyDoc * doc = [[MyDoc alloc] initWithFileURL:documentDirURL];
    
    if ([DocumentManager documentExists:name]) {

        [doc openWithCompletionHandler:^(BOOL success) {
            
            dispatch_async(dispatch_get_main_queue(), ^{

                if (success) {
                    
                    completionHandler(doc);
                }
                else {
                    
                    completionHandler(nil);
                }
            });
        }];
        
    } else {
        // new document, skip loading
        
        completionHandler(doc);
    }
}

//- (void)setNumber:(NSInteger)number {
//    NSLog(@"set number");
//    NSInteger oldValue = _number;
//    _number = number;
//    
//    [self.undoManager registerUndoWithTarget:self handler:^(MyDoc *target) {
//        
//        target->_number = oldValue;
//    }];
//}



- (BOOL)loadFromContents:(id)contents ofType:(NSString *)typeName error:(NSError *__autoreleasing  _Nullable *)outError {
    NSLog(@"load from contents");


    NSData *data = (NSData *)contents;
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingFromData:data error:nil];
    unarchiver.requiresSecureCoding = NO;
    
    _techniqueName = (NSString *)[unarchiver decodeObjectForKey:@"techniqueName"];
    _note = (NSString *)[unarchiver decodeObjectForKey:@"note"];
    _maleFemale = (NSString *)[unarchiver decodeObjectForKey:@"maleFemale"];
    
    _imageEntry = [UIImage imageWithData:[unarchiver decodeObjectForKey:@"imageEntry"]];
    _imageLeft = [UIImage imageWithData:[unarchiver decodeObjectForKey:@"imageLeft"]];
    _imageRight = [UIImage imageWithData:[unarchiver decodeObjectForKey:@"imageRight"]];
    _imageTop = [UIImage imageWithData:[unarchiver decodeObjectForKey:@"imageTop"]];
    _imageFront = [UIImage imageWithData:[unarchiver decodeObjectForKey:@"imageFront"]];
    _imageBack = [UIImage imageWithData:[unarchiver decodeObjectForKey:@"imageBack"]];

    _dictLeft = (NSData*)[unarchiver decodeObjectForKey:@"jsonLeft"];
    _dictRight = (NSData*)[unarchiver decodeObjectForKey:@"jsonRight"];
    _dictTop = (NSData*)[unarchiver decodeObjectForKey:@"jsonTop"];
    _dictFront = (NSData*)[unarchiver decodeObjectForKey:@"jsonFront"];
    _dictBack = (NSData*)[unarchiver decodeObjectForKey:@"jsonBack"];

    [unarchiver finishDecoding];
    
    return YES;
}

- (id)contentsForType:(NSString *)typeName error:(NSError *__autoreleasing  _Nullable *)outError {

    NSLog(@"save to contents");
    
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initRequiringSecureCoding:NO];
    
    [archiver encodeObject:(NSString *)_techniqueName forKey:@"techniqueName"];
    [archiver encodeObject:(NSString *)_note forKey:@"note"];
    [archiver encodeObject:(NSString *)_uuid forKey:@"uuid"];
    [archiver encodeObject:_maleFemale forKey:@"maleFemale"];
    [archiver encodeObject:_modificationDate forKey:@"modificationDate"];
    [archiver encodeObject:_favorite forKey:@"favorite"];
    
    [archiver encodeObject:_dictLeft forKey:@"jsonLeft"];
    [archiver encodeObject:_dictRight forKey:@"jsonRight"];
    [archiver encodeObject:_dictTop forKey:@"jsonTop"];
    [archiver encodeObject:_dictFront forKey:@"jsonFront"];
    [archiver encodeObject:_dictBack forKey:@"jsonBack"];

   // [archiver encodeObject:(UIImage*)_imageEntry forKey:@"imageEntry"];
    
    [archiver encodeObject:(UIImage*)[self encodeImage:_imageEntry] forKey:@"imageEntry"];
    [archiver encodeObject:[self encodeImage:_imageLeft] forKey:@"imageLeft"];
    [archiver encodeObject:[self encodeImage:_imageRight] forKey:@"imageRight"];
    [archiver encodeObject:[self encodeImage:_imageTop] forKey:@"imageTop"];
    [archiver encodeObject:[self encodeImage:_imageFront] forKey:@"imageFront"];
    [archiver encodeObject:[self encodeImage:_imageBack] forKey:@"imageBack"];
    
    [archiver finishEncoding];
    data = [[archiver encodedData] mutableCopy];

    return data;
    
}

- (NSData*)encodeImage:(UIImage *)image
{
    NSData *data = UIImagePNGRepresentation(image);
    return data;
}

@end
