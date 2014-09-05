#import "_MainEntry.h"
#import "CViewController.h"
#import "TableViewController.h"
#import "DViewController.h"

@implementation _MainEntry {
}
+ (NSString *)storyboardName {
    return @"Main";
}

- (void)c:(TableViewController *)controller block:(void(^)(CViewController *))block {
    [controller performSegueWithIdentifier:@"C" block:block];
}

- (void)d:(CViewController *)controller block:(void(^)(DViewController *))block {
    [controller performSegueWithIdentifier:@"D" block:block];
}
@end
