@interface MainEntry : AKUStoryboardEntry
- (void)c:(TableViewController *)controller block:(void(^)(CViewController *))block;
- (void)d:(CViewController *)controller block:(void(^)(DViewController *))block;
@end
