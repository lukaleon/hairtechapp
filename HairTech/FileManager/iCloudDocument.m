//
//  iCloudDocument.m
//  iCloud Document Sync
//
//  Created by iRare Media. Last updated January 2014.
//  Available on GitHub. Licensed under MIT with Attribution.
//

#import "iCloudDocument.h"
#import "DocumentManager.h"
#import <sys/xattr.h>


NSFileVersion *laterVersion (NSFileVersion *first, NSFileVersion *second) {
    NSDate *firstDate = first.modificationDate;
    NSDate *secondDate = second.modificationDate;
    return ([firstDate compare:secondDate] != NSOrderedDescending) ? second : first;
}

@implementation iCloudDocument
@synthesize diagramFileDictionary;
//----------------------------------------------------------------------------------------------------------------//
//------------  Document Life Cycle ------------------------------------------------------------------------------//
//----------------------------------------------------------------------------------------------------------------//
#pragma mark - Document Life Cycle

- (instancetype)initWithFileURL:(NSURL *)url {
	self = [super initWithFileURL:url];
	if (self) {
        self.fileNameFromFile = [[url path] lastPathComponent];
		_contents = [[NSData alloc] init];
    
	}
	return self;
}
- (void)autosaveWithCompletionHandler:(void (^)(BOOL success))completionHandler {
    // perform the autosave here
    NSLog(@"AUTOSAVE PERFORMED");
    [super autosaveWithCompletionHandler:completionHandler];
}

- (NSString *)localizedName {
	return [self.fileURL lastPathComponent];
}

- (NSString *)stateDescription {
    if (!self.documentState) return @"Document state is normal";
    
    NSMutableString *string = [NSMutableString string];
    if ((self.documentState & UIDocumentStateNormal) != 0) [string appendString:@"Document state is normal"];
    if ((self.documentState & UIDocumentStateClosed) != 0) [string appendString:@"Document is closed"];
    if ((self.documentState & UIDocumentStateInConflict) != 0) [string appendString:@"Document is in conflict"];
    if ((self.documentState & UIDocumentStateSavingError) != 0) [string appendString:@"Document is experiencing saving error"];
    if ((self.documentState & UIDocumentStateEditingDisabled) != 0) [string appendString:@"Document editing is disbled"];
    NSLog(@"Document State = %@", string);
    return string;
}

//----------------------------------------------------------------------------------------------------------------//
//------------  Loading and Saving -------------------------------------------------------------------------------//
//----------------------------------------------------------------------------------------------------------------//
#pragma mark - Loading and Saving

//- (id)contentsForType:(NSString *)typeName error:(NSError **)outError {
//
//    NSLog(@"save to contents");
//
//    if (!self.contents) {
//
//        self.contents = [[NSData alloc]init];
//    }
//    return self.contents;
//}

//- (BOOL)loadFromContents:(id)fileContents ofType:(NSString *)typeName error:(NSError **)outError {
//
//    NSLog(@"Load from contents");
//
//    if ([fileContents length] > 0) {
//        self.contents = [[NSData alloc] initWithData:fileContents];
//        [self storeFileDataInObject:self.contents error:nil];
//    } else {
//        self.contents = [[NSData alloc] init];
//    }
//    return YES;
//}
- (id)contentsForType:(NSString *)typeName error:(NSError **)outError {
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

- (BOOL)loadFromContents:(id)contents ofType:(NSString *)typeName error:(NSError **)outError {
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

-(NSData*)storeJsonDataInDictionary:(NSString*)str{
    NSData* data = [str dataUsingEncoding:NSUTF8StringEncoding];
    //NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    return data;
}

- (NSData*)encodeImage:(UIImage *)image
{
    NSData *data = UIImagePNGRepresentation(image);
    return data;
}


- (void)setDocumentData:(NSData *)newData {
    
    NSLog(@"setDocumentData");
    NSData *oldData = self.contents;
    self.contents = [newData copy];
//
//    NSData *data = (NSData *)newData;
//    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingFromData:data error:nil];
//    unarchiver.requiresSecureCoding = NO;
//
//    _techniqueName = (NSString *)[unarchiver decodeObjectForKey:@"techniqueName"];
//    _note = (NSString *)[unarchiver decodeObjectForKey:@"note"];
//    _maleFemale = (NSString *)[unarchiver decodeObjectForKey:@"maleFemale"];
//
//    _imageEntry = [UIImage imageWithData:[unarchiver decodeObjectForKey:@"imageEntry"]];
//    _imageLeft = [UIImage imageWithData:[unarchiver decodeObjectForKey:@"imageLeft"]];
//    _imageRight = [UIImage imageWithData:[unarchiver decodeObjectForKey:@"imageRight"]];
//    _imageTop = [UIImage imageWithData:[unarchiver decodeObjectForKey:@"imageTop"]];
//    _imageFront = [UIImage imageWithData:[unarchiver decodeObjectForKey:@"imageFront"]];
//    _imageBack = [UIImage imageWithData:[unarchiver decodeObjectForKey:@"imageBack"]];
//
//    _dictLeft = (NSData*)[unarchiver decodeObjectForKey:@"jsonLeft"];
//    _dictRight = (NSData*)[unarchiver decodeObjectForKey:@"jsonRight"];
//    _dictTop = (NSData*)[unarchiver decodeObjectForKey:@"jsonTop"];
//    _dictFront = (NSData*)[unarchiver decodeObjectForKey:@"jsonFront"];
//    _dictBack = (NSData*)[unarchiver decodeObjectForKey:@"jsonBack"];
//
//    [unarchiver finishDecoding];
//
//
//
//
//
    
    
    
    // Register the undo operation
    [self.undoManager setActionName:@"Data Change"];
    [self.undoManager registerUndoWithTarget:self selector:@selector(setDocumentData:) object:oldData];
}

- (void)setNote:(NSString*)note {
    NSLog(@"set note");
    NSString * oldValue = _note;
    _note = note;
    
    [self.undoManager registerUndoWithTarget:self handler:^(iCloudDocument *target) {
        
        target->_note = oldValue;
    }];
}

//----------------------------------------------------------------------------------------------------------------//
//------------  Error Handling ----------------------------------------------------------------------------------//
//----------------------------------------------------------------------------------------------------------------//
#pragma mark - Loading and Saving

- (void)handleError:(NSError *)error userInteractionPermitted:(BOOL)userInteractionPermitted {
    [super handleError:error userInteractionPermitted:userInteractionPermitted];
	NSLog(@"[iCloudDocument] %@", error);
    
    if ([self.delegate respondsToSelector:@selector(iCloudDocumentErrorOccured:)]) [self.delegate iCloudDocumentErrorOccured:error];
}



-(void)storeFileDataInObject:(NSData*)data error:(NSError **)outError {
    
//    diagramFileDictionary = [NSKeyedUnarchiver unarchivedObjectOfClass:[NSObject class] fromData:data error:outError];
    
    NSError* err;
    NSKeyedUnarchiver* unarchiver = [[NSKeyedUnarchiver alloc] initForReadingFromData:data error:&err];
    diagramFileDictionary = [unarchiver decodeObjectOfClasses:[[NSSet alloc] initWithArray:@[[NSMutableDictionary class],[NSString class], [NSData class]]] forKey:NSKeyedArchiveRootObjectKey];
    
    self.techniqueName = self.fileNameFromFile;
    self.uuid = [diagramFileDictionary objectForKey:@"uuid"];
    self.maleFemale = [diagramFileDictionary objectForKey:@"maleFemale"];
    self.note = [diagramFileDictionary objectForKey:@"note"];

    self.imageEntry = [UIImage imageWithData:[diagramFileDictionary objectForKey:@"imageEntry"]];
    self.imageLeft = [UIImage imageWithData:[diagramFileDictionary objectForKey:@"imageLeft"]];
    self.imageRight = [UIImage imageWithData:[diagramFileDictionary objectForKey:@"imageRight"]];
    self.imageTop = [UIImage imageWithData:[diagramFileDictionary objectForKey:@"imageTop"]];
    self.imageFront = [UIImage imageWithData:[diagramFileDictionary objectForKey:@"imageFront"]];
    self.imageBack = [UIImage imageWithData:[diagramFileDictionary objectForKey:@"imageBack"]];
    
    self.dictLeft = [diagramFileDictionary objectForKey:@"jsonLeft"];
    self.dictRight = [diagramFileDictionary objectForKey:@"jsonRight"];
    self.dictTop = [diagramFileDictionary objectForKey:@"jsonTop"];
    self.dictFront = [diagramFileDictionary objectForKey:@"jsonFront"];
    self.dictBack = [diagramFileDictionary objectForKey:@"jsonBack"];
}

-(NSData*)saveDataToDict:(NSMutableDictionary*)dict error:(NSError **)outError {
    
    NSError * error;
    NSMutableDictionary * dictToSave = [NSMutableDictionary dictionary];

    dictToSave = [dict mutableCopy];
    
    [dictToSave setObject:self.imageEntry forKey:@"imageEntry"];
    [dictToSave setObject:self.imageLeft  forKey:@"imageLeft"];
    [dictToSave setObject:self.imageRight  forKey:@"imageRight"];
    [dictToSave setObject:self.imageTop  forKey:@"imageTop"];
    [dictToSave setObject:self.imageFront  forKey:@"imageFront"];
    [dictToSave setObject:self.imageBack  forKey:@"imageBack"];
    
    [dictToSave setObject: self.dictLeft  forKey:@"jsonLeft"];
    [dictToSave setObject: self.dictRight  forKey:@"jsonRight"];
    [dictToSave setObject: self.dictTop  forKey:@"jsonTop"];
    [dictToSave setObject: self.dictFront  forKey:@"jsonFront"];
    [dictToSave setObject: self.dictBack  forKey:@"jsonBack"];

    [dictToSave setObject:self.techniqueName forKey:@"techniqueName"];
    [dictToSave setObject:self.uuid forKey:@"uuid"];
    [dictToSave setObject:self.maleFemale forKey:@"maleFemale"];
    [dictToSave setObject:self.creationDate forKey:@"creationDate"];
    [dictToSave setObject:self.modificationDate forKey:@"modificationDate"];
    [dictToSave setObject:self.favorite forKey:@"favorite"];
    [dictToSave setObject:self.note forKey:@"note"];
    
    return [NSKeyedArchiver archivedDataWithRootObject:dictToSave requiringSecureCoding:NO error:&error];
    
    
}



+ (void)documentNamed: (NSString *)name withCompletion: (void (^)(iCloudDocument *doc))completionHandler {
    
    NSString *fileName = name;
    
    NSURL *documentDirURL = [[DocumentManager documentDirectory] URLByAppendingPathComponent:fileName];
    
    iCloudDocument *doc = [[iCloudDocument alloc] initWithFileURL:documentDirURL];
    
    if ([DocumentManager documentExists:fileName]) {
        
        [doc openWithCompletionHandler:^(BOOL success) {
            
            dispatch_async(dispatch_get_main_queue(), ^{

                if (success) {
                    NSLog(@"fffff ");

                    completionHandler(doc);
                }
                else {
                    NSLog(@"fffff no ");
                    completionHandler(nil);
                }
            });
        }];
        
    } else {
        // new document, skip loading
        
        completionHandler(doc);
    }
}




@end

