//
//  TriangleView.m
//  toggled
//

#import "TriangleView.h"

@implementation TriangleView

// stars: http://stackoverflow.com/questions/8445786/how-to-draw-stars-using-quartz-core/8446655#8446655
// triangle: http://stackoverflow.com/questions/25578090/draw-triangle-ios
// mix/max x/y: http://stackoverflow.com/questions/6697614/how-to-draw-a-triangle-programmatically
// CGPathAddLineToPoint: http://stackoverflow.com/questions/2249683/how-to-draw-polygons-with-cgpath
// CGContextAddLineToPoint: http://stackoverflow.com/questions/16462604/drawing-a-polygon-with-one-color-for-stroke-and-a-different-one-for-fill
// UIBezierPath: http://stackoverflow.com/questions/24769050/creating-a-triangle-shape-in-a-uibutton

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

-(void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    int sides = 3;
    double size = 100.0;
    CGPoint center = CGPointMake(160.0, 100.0);
    
    double radius = size / 2.0;
    double theta = 2.0 * M_PI / sides;
    
    CGContextMoveToPoint(context, center.x, center.y-radius);
    for (NSUInteger k=1; k<sides; k++) {
        float x = radius * sin(k * theta);
        float y = radius * cos(k * theta);
        CGContextAddLineToPoint(context, center.x+x, center.y-y);
    }
    CGContextClosePath(context);
    
    [[UIColor redColor] setFill];
    [[UIColor blackColor] setStroke];
    
    CGContextFillPath(context);           // Choose for a filled triangle
    // CGContextSetLineWidth(context, 2); // Choose for a unfilled triangle
    // CGContextStrokePath(context);      // Choose for a unfilled triangle
}

@end
