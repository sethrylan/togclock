

@interface ButtonMaskView : UIView

@property (strong, nonatomic) UIColor* vdownColor;
@property (strong, nonatomic) UIColor* vupColor;

@property CGMutablePathRef vdownPath;
@property CGMutablePathRef vupPath;

/**
 * Returns YES is the passed point is in the geometry space
 * @param a point relative to the UIView containing the geometry
 * @return YES is the point is in the geometry space
 */
+ (BOOL)isPoint:(CGPoint)point insidePath:(CGPathRef)path;

+ (NSDictionary*)bounds;

+ (UIColor*)unselectedColor;
+ (UIColor*)activeColor;
+ (UIColor*)inactiveColor;

@end
