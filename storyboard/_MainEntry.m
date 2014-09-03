#import "MainEntry.h"

@implementation MainEntry {
}
+ (NSString *)storyboardName {
    return @"Main";
}

- (void)c:(TableViewController *)controller block:(void(^)(CViewController *))block {
    [self performSegueWithIdentifier:@"C" block:block];
}

- (void)d:(CViewController *)controller block:(void(^)(DViewController *))block {
    [self performSegueWithIdentifier:@"D" block:block];
}
@end
