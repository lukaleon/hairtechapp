//  SpringboardLayoutAttributes.m

#import "SpringboardLayoutAttributes.h"

@implementation SpringboardLayoutAttributes

- (id)copyWithZone:(NSZone *)zone
{
    SpringboardLayoutAttributes *attributes = [super copyWithZone:zone];
    attributes.deleteButtonHidden = _deleteButtonHidden;
    return attributes;
}
@end
