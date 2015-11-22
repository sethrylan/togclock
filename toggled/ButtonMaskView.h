

@interface ButtonMaskView : UIView

@property CGRect vdownRect;
@property CGRect vupRect;

@property BOOL vdownRunning;
@property BOOL vupRunning;

/**
 * Returns YES is the passed point is in the geometry space
 * @param a point relative to the UIView containing the geometry
 * @return YES is the point is in the geometry space
 */
- (BOOL)isPoint:(CGPoint)point insideOfRect:(CGRect)rect;


@end
