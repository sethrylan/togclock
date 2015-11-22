
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

-(void)drawRect:(CGRect)rect
{
    [self drawVdownButton:rect];
    [self drawVupButton:rect];
}

-(void)drawVupButton:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 8.0); // this is set from now on until you explicitly change it
    CGContextStrokePath(context); // do actual stroking
    CGContextSetRGBFillColor(context, 0.0, 1.0, 0.0, 0.5); // green color, half transparent
    CGContextFillRect(context, CGRectMake(5, 90, 490, 80)); // a square at the bottom left-hand corner
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
    
//    CGContextSetRGBStrokeColor(context, 1.0, 1.0, 0.0, 1.0); // yellow line
//    CGContextBeginPath(context);
//    CGContextMoveToPoint(context, 50.0, 50.0); //start point
//    CGContextAddLineToPoint(context, 250.0, 100.0);
//    CGContextAddLineToPoint(context, 250.0, 350.0);
//    CGContextAddLineToPoint(context, 50.0, 350.0); // end path
//    CGContextClosePath(context); // close path
    
    CGContextSetLineWidth(context, 8.0); // this is set from now on until you explicitly change it
    CGContextStrokePath(context); // do actual stroking
    CGContextSetRGBFillColor(context, 0.0, 1.0, 0.0, 0.5); // green color, half transparent
    CGContextFillRect(context, CGRectMake(5, 5, 425.0, 80.0)); // a square at the bottom left-hand corner

    // CGContextSetLineWidth(context, 2); // Choose for a unfilled triangle
    // CGContextStrokePath(context);      // Choose for a unfilled triangle

 
    
}


@end
