
#import "ButtonMaskView.h"

@implementation ButtonMaskView

// stars: http://stackoverflow.com/questions/8445786/how-to-draw-stars-using-quartz-core/8446655#8446655
// triangle: http://stackoverflow.com/questions/25578090/draw-triangle-ios
// mix/max x/y: http://stackoverflow.com/questions/6697614/how-to-draw-a-triangle-programmatically
// CGPathAddLineToPoint: http://stackoverflow.com/questions/2249683/how-to-draw-polygons-with-cgpath
// CGContextAddLineToPoint: http://stackoverflow.com/questions/16462604/drawing-a-polygon-with-one-color-for-stroke-and-a-different-one-for-fill
// UIBezierPath: http://stackoverflow.com/questions/24769050/creating-a-triangle-shape-in-a-uibutton
// getting the alpha value for a pixel: http://stackoverflow.com/questions/1042830/retrieving-a-pixel-alpha-value-for-a-uiimage/3763313#3763313

// http://stackoverflow.com/questions/1694529/allowing-interaction-with-a-uiview-under-another-uiview

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    
//    
//}
//
//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    
//}

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
    
//    CGContextSetLineWidth(context, 8.0); // this is set from now on until you explicitly change it
//    CGContextStrokePath(context); // do actual stroking
    
    [self setRGBFillColor:self.vupRunning withContext:context];
    
    self.vupPath = CGPathCreateMutable();
    CGPathMoveToPoint(self.vupPath, nil, 490, 0);        // start point
    CGPathAddLineToPoint(self.vupPath, nil, 490, 310);   // down
    CGPathAddLineToPoint(self.vupPath, nil, 290, 310);   // left
    CGPathAddLineToPoint(self.vupPath, nil, 290, 140);   // up
    CGPathAddLineToPoint(self.vupPath, nil, 465, 0);     // up and right
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
    CGPathAddLineToPoint(self.vdownPath, nil, 350, 120);  // down and to left
    CGPathAddLineToPoint(self.vdownPath, nil, 0, 120);    // left across
    CGPathAddLineToPoint(self.vdownPath, nil, 0, 10);     // up
    CGPathAddLineToPoint(self.vdownPath, nil, 400, 10);   // right
    CGPathAddLineToPoint(self.vdownPath, nil, 405, 0);    // up and right
    CGContextAddPath(context, self.vdownPath);            // close path
    CGContextFillPath(context);
    
//    CGContextSetLineWidth(context, 8.0); // this is set from now on until you explicitly change it
//    CGContextStrokePath(context); // do actual stroking

//    self.vdownRect = CGRectMake(0, 10, 425.0, 80.0);
//    CGContextFillRect(context, self.vdownRect); // a square at the bottom left-hand corner
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
