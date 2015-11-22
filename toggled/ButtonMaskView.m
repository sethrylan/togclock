
#import "ButtonMaskView.h"
#import "NSDictionary+Additions.h"

@implementation ButtonMaskView
// Other drawing guides: 
// stars: http://stackoverflow.com/questions/8445786/how-to-draw-stars-using-quartz-core/8446655#8446655
// triangle: http://stackoverflow.com/questions/25578090/draw-triangle-ios
// mix/max x/y: http://stackoverflow.com/questions/6697614/how-to-draw-a-triangle-programmatically
// CGPathAddLineToPoint: http://stackoverflow.com/questions/2249683/how-to-draw-polygons-with-cgpath
// CGContextAddLineToPoint: http://stackoverflow.com/questions/16462604/drawing-a-polygon-with-one-color-for-stroke-and-a-different-one-for-fill
// UIBezierPath: http://stackoverflow.com/questions/24769050/creating-a-triangle-shape-in-a-uibutton
// getting the alpha value for a pixel: http://stackoverflow.com/questions/1042830/retrieving-a-pixel-alpha-value-for-a-uiimage/3763313#3763313

// http://stackoverflow.com/questions/1694529/allowing-interaction-with-a-uiview-under-another-uiview


+ (BOOL)isPoint:(CGPoint)point insidePath:(CGPathRef)path
{
    return CGPathContainsPoint(path,nil,point,nil);
}

+ (NSDictionary*)bounds
{
    NSDictionary *vupBounds =
    @{
      @"bottom": @310,
      @"right":  @485,
      @"left":   @325
    };
    
    NSDictionary *vdownBounds =
    @{
      @"top":    @10,
      @"bottom": @150,
      @"left":   @0
    };

    return @{@"vdown": vdownBounds, @"vup":vupBounds};
}

- (void)drawRect:(CGRect)rect
{
    [self drawVdownButton:rect];
    [self drawVupButton:rect];
}

- (void)drawVupButton:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [self.vupColor CGColor]);
    
    NSDictionary *bounds = [[ButtonMaskView bounds] valueForKey:@"vup"];
    
    self.vupPath = CGPathCreateMutable();
    CGPathMoveToPoint(self.vupPath, nil,    [bounds doubleForKey:@"right"], 0);        // start point
    CGPathAddLineToPoint(self.vupPath, nil, [bounds doubleForKey:@"right"], [bounds doubleForKey:@"bottom"]);   // down
    CGPathAddLineToPoint(self.vupPath, nil, [bounds doubleForKey:@"left"], [bounds doubleForKey:@"bottom"]);   // left
    CGPathAddLineToPoint(self.vupPath, nil, [bounds doubleForKey:@"left"], 150);   // up
    CGPathAddLineToPoint(self.vupPath, nil, 455, 0);     // up and right
    CGContextAddPath(context, self.vupPath);             // close path
    CGContextFillPath(context);
}

- (void)drawVdownButton:(CGRect)rect
{
    // 480x320 4s
    // 568x320 5/5s
    // 667x375 6/6s
    // 768x414 6s+
    // orientation-dependent in iOS8
//    CGRect screenRect = [[UIScreen mainScreen] bounds];
//    CGFloat screenWidth = screenRect.size.width;
//    CGFloat screenHeight = screenRect.size.height;

    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [self.vdownColor CGColor]);
    
    NSDictionary *bounds = [[ButtonMaskView bounds] valueForKey:@"vdown"];
    
    self.vdownPath = CGPathCreateMutable();
    CGPathMoveToPoint(self.vdownPath, nil, 425, 0);       // start point
    CGPathAddLineToPoint(self.vdownPath, nil, 295, [bounds doubleForKey:@"bottom"]);  // down and to left
    CGPathAddLineToPoint(self.vdownPath, nil, 0, [bounds doubleForKey:@"bottom"]);    // left across
    CGPathAddLineToPoint(self.vdownPath, nil, 0, [bounds doubleForKey:@"top"]);     // up
    CGPathAddLineToPoint(self.vdownPath, nil, 385, [bounds doubleForKey:@"top"]);   // right
    CGPathAddLineToPoint(self.vdownPath, nil, 390, 0);    // up and right
    CGContextAddPath(context, self.vdownPath);            // close path
    CGContextFillPath(context);
}

- (void)setRGBFillColor:(BOOL)isActive withContext:(CGContextRef)context
{
    if (isActive)
    {
        CGContextSetFillColorWithColor(context, [[ButtonMaskView activeColor] CGColor]);
    }
    else
    {
        CGContextSetFillColorWithColor(context, [[ButtonMaskView inactiveColor] CGColor]);
    }
}

+ (UIColor*)unselectedColor
{
    return [UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:0.5];
}

+ (UIColor*)activeColor
{
    return [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.5];
}

+ (UIColor*)inactiveColor
{
    return [UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:0.5];
}

@end
