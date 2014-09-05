#import "AKUStoryboardEntry.h"

@class CViewController;
@class TableViewController;
@class DViewController;

@interface _MainEntry : AKUStoryboardEntry
- (void)c:(TableViewController *)controller block:(void(^)(CViewController *))block;
- (void)d:(CViewController *)controller block:(void(^)(DViewController *))block;
@end
