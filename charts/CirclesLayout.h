
#import <UIKit/UIKit.h>

@interface CirclesLayout : UICollectionViewLayout

// "Cached" layout information
@property (nonatomic, strong) NSDictionary *layoutInfo;
@property (nonatomic) float contentHeight;
@property (nonatomic) float contentWidth;

@property (nonatomic) bool vertical;

// Helpers
@property (nonatomic) UIEdgeInsets viewInsets;
@property (nonatomic) float initialX;
@property (nonatomic) float initialY;

@end
