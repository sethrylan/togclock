
#import "ButtonMaskView.h"

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


-(BOOL)isPoint:(CGPoint)point insidePath:(CGPathRef)path
{
    return CGPathContainsPoint(path,nil,point,nil);
}

-(void)drawRect:(CGRect)rect
{
    [self drawVdownButton:rect];
    [self drawVupButton:rect];
}

-(void)drawVupButton:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [self setRGBFillColor:self.vupRunning withContext:context];
    
    self.vupPath = CGPathCreateMutable();
    CGPathMoveToPoint(self.vupPath, nil, 485, 0);        // start point
    CGPathAddLineToPoint(self.vupPath, nil, 490, 310);   // down
    CGPathAddLineToPoint(self.vupPath, nil, 320, 310);   // left
    CGPathAddLineToPoint(self.vupPath, nil, 320, 165);   // up
    CGPathAddLineToPoint(self.vupPath, nil, 455, 0);     // up and right
    CGContextAddPath(context, self.vupPath);             // close path
    CGContextFillPath(context);
}

-(void)drawVdownButton:(CGRect)rect
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
    
    [self setRGBFillColor:self.vdownRunning withContext:context];
    
    self.vdownPath = CGPathCreateMutable();
    CGPathMoveToPoint(self.vdownPath, nil, 425, 0);       // start point
    CGPathAddLineToPoint(self.vdownPath, nil, 315, 140);  // down and to left
    CGPathAddLineToPoint(self.vdownPath, nil, 0, 140);    // left across
    CGPathAddLineToPoint(self.vdownPath, nil, 0, 10);     // up
    CGPathAddLineToPoint(self.vdownPath, nil, 380, 10);   // right
    CGPathAddLineToPoint(self.vdownPath, nil, 390, 0);    // up and right
    CGContextAddPath(context, self.vdownPath);            // close path
    CGContextFillPath(context);
}

- (void)setRGBFillColor:(BOOL)isRunning withContext:(CGContextRef)context
{
    if (!isRunning)
    {
        CGContextSetRGBFillColor(context, 0.0, 1.0, 0.0, 0.5); // green color, half transparent
    }
    else
    {
        CGContextSetRGBFillColor(context, 1.0, 0.0, 0.0, 0.5); // red color, half transparent
    }
}

@end
