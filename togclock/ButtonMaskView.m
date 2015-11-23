
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


+ (BOOL)isPoint:(CGPoint)point insidePath:(UIBezierPath*)path
{
    return [path containsPoint:point];
}

+ (NSDictionary*)bounds
{
    // angle should be 13/15
    NSDictionary *vupBounds =
    @{
      @"bottom": @310,
      @"right":  @485,
      @"left":   @(13*23)
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
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, nil,    [bounds doubleForKey:@"right"], 0);        // start point
    CGPathAddLineToPoint(path, nil, [bounds doubleForKey:@"right"], [bounds doubleForKey:@"bottom"]);   // down
    CGPathAddLineToPoint(path, nil, [bounds doubleForKey:@"left"], [bounds doubleForKey:@"bottom"]);   // left
    CGPathAddLineToPoint(path, nil, [bounds doubleForKey:@"left"], 525 - (15 * 23));   // up   (455-left)/(165) must equal equal 13/15
    CGPathAddLineToPoint(path, nil, 455, 0);     // up and right
    CGContextAddPath(context, path);             // close path
    CGContextFillPath(context);
    self.vupPath = [UIBezierPath bezierPathWithCGPath:path];
    CGPathRelease(path);
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
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, nil, 425, 0);       // start point
    CGPathAddLineToPoint(path, nil, 295, [bounds doubleForKey:@"bottom"]);  // down and to left
    CGPathAddLineToPoint(path, nil, 0, [bounds doubleForKey:@"bottom"]);    // left across
    CGPathAddLineToPoint(path, nil, 0, [bounds doubleForKey:@"top"]);     // up
    CGPathAddLineToPoint(path, nil, 385, [bounds doubleForKey:@"top"]);   // right
    CGPathAddLineToPoint(path, nil, 395, 0);    // up and right
    CGContextAddPath(context, path);            // close path
    CGContextFillPath(context);
    self.vdownPath = [UIBezierPath bezierPathWithCGPath:path];
    CGPathRelease(path);
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
//    return [UIColor colorWithRed:135/255.0 green:206/255.0 blue:250/255.0 alpha:0.5];
    return [UIColor colorWithRed:76/255.0 green:195/255.0 blue:217/255.0 alpha:0.5];
}

+ (UIColor*)activeColor
{
//    return [UIColor colorWithRed:178/255.0 green:34/255.0 blue:34/255.0 alpha:0.5];
    return [UIColor colorWithRed:241/255.0 green:103/255.0 blue:69/255.0 alpha:0.5];

}

+ (UIColor*)inactiveColor
{
//    return [UIColor colorWithRed:142/255.0 green:252/255.0 blue:0.0/255.0 alpha:0.5];
    return [UIColor colorWithRed:123/255.0 green:200/255.0 blue:164/255.0 alpha:0.5];

}

@end
