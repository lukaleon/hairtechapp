

#import "Technique.h"

@implementation Technique


-(NSString *) getName
{
    return [NSString stringWithFormat:@"%@ %@",self.techniquename,self.date];
}
@end
