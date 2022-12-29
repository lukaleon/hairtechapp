
#import <Foundation/Foundation.h>

extern const struct CloudTechniqueFields {
    __unsafe_unretained NSString *techniqueId;
    __unsafe_unretained NSString *uniqueId;
    __unsafe_unretained NSString *date;
    __unsafe_unretained NSString *techniqueimage;
    __unsafe_unretained NSString *techniqueimagethumb1;
    __unsafe_unretained NSString *techniqueimagethumb2;
    __unsafe_unretained NSString *techniqueimagethumb3;
    __unsafe_unretained NSString *techniqueimagethumb4;
    __unsafe_unretained NSString *techniqueimagethumb5;
    __unsafe_unretained NSString *techniqueimagebig1;
    __unsafe_unretained NSString *techniqueimagebig2;
    __unsafe_unretained NSString *techniqueimagebig3;
    __unsafe_unretained NSString *techniqueimagebig4;
    __unsafe_unretained NSString *techniqueimagebig5;
    __unsafe_unretained NSString *dateOfCreation;


} CloudTechniqueFields;


@interface Technique : NSObject

@property (nonatomic, assign) int techniqueId;
@property (nonatomic, strong) NSString * uniqueId;
@property (nonatomic, strong) NSString *techniquename;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *techniqueimage;
@property (nonatomic, strong) NSString *techniqueimagethumb1;
@property (nonatomic, strong) NSString *techniqueimagethumb2;
@property (nonatomic, strong) NSString *techniqueimagethumb3;
@property (nonatomic, strong) NSString *techniqueimagethumb4;
@property (nonatomic, strong) NSString *techniqueimagethumb5;
@property (nonatomic, strong) NSString *techniqueimagebig1;
@property (nonatomic, strong) NSString *techniqueimagebig2;
@property (nonatomic, strong) NSString *techniqueimagebig3;
@property (nonatomic, strong) NSString *techniqueimagebig4;
@property (nonatomic, strong) NSString *techniqueimagebig5;
@property (nonatomic, strong) NSString * dateOfCreation;

+ (NSDictionary *)defaultContent;

- (instancetype)initWithInputData:(id)inputData;

@end
