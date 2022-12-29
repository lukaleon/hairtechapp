

#import "Technique.h"

@implementation Technique

const struct CloudTechniqueFields CloudTechniqueFields = {
    .uniqueId = @"uniqueid",
    .techniqueId = @"id",
    .techniqueimage = @"image",
    .techniqueimagethumb1 = @"techniqueleft",
    .techniqueimagethumb2 = @"techniqueright",
    .techniqueimagethumb3 = @"techniquetop",
    .techniqueimagethumb4 = @"techniquefront",
    .techniqueimagethumb5 = @"techniqueback",
    .techniqueimagebig1 = @"techniqueleftbig",
    .techniqueimagebig2 = @"techniquerightbig",
    .techniqueimagebig3 = @"techniquetopbig",
    .techniqueimagebig4 = @"techniquefrontbig",
    .techniqueimagebig5 = @"techniquebackbig",
    .dateOfCreation = @"dateofcreation",
    .date = @"malefemale"
};
-(NSString *) getName
{
    return [NSString stringWithFormat:@"%@ %@",self.techniquename,self.date];
}
@end
