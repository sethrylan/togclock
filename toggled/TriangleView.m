//
//  TriangleView.m
//  toggled
//

#import "TriangleView.h"

@implementation TriangleView

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
    
    CGContextFillPath(context);           // Choose for a filled triangle
    // CGContextSetLineWidth(context, 2); // Choose for a unfilled triangle
    // CGContextStrokePath(context);      // Choose for a unfilled triangle
}

@end
