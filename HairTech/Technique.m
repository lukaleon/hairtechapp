

#import "Technique.h"
#import <CloudKit/CloudKit.h>


@implementation Technique


- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.uniqueId forKey:@"uniqueID"];
}


-(NSString *) getName
{
    return [NSString stringWithFormat:@"%@ %@",self.techniquename,self.date];
}


@end
