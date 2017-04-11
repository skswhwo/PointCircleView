
#import "PointCircleView.h"

#define DEGREES_TO_RADIANS(angle) (angle * M_PI / 180)

@interface PointCircleView ()
@property (nonatomic, strong) NSMutableArray <CAShapeLayer *> *layers;
@property (nonatomic, strong) CAShapeLayer *progressCircle;
@property (nonatomic, strong) CAShapeLayer *backgroundCircle;
@end

@implementation PointCircleView
#pragma mark - Interface
+ (PointCircleView *)getCircleView:(CGRect)rect
{
    PointCircleView *view = [[PointCircleView alloc] initWithFrame:rect];
    return view;
}

#pragma mark - Initializer
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self initializer];
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    [self initializer];
    return self;
}

- (void)initializer
{
    self.backgroundColor = [UIColor clearColor];
    _scales = @[@(0),@(1)];
    _duration = 1.0;
    _radians = 180;
    _point = 0;
    _lineWidth = 5;
    _gapWidth = 0.014;
    _circlePointRadius = 8;
    _ranges = @[[NSValue valueWithRange:NSMakeRange(0, 100)]];
    _strokeColors = @[self.tintColor];
    _animate = true;
}

#pragma mark - Setter
- (void)setGapWidth:(float)gapWidth
{
    _gapWidth = gapWidth;
    [self updateView];
}
- (void)setLineWidth:(NSInteger)lineWidth
{
    _lineWidth = lineWidth;
    [self updateView];
}
- (void)setRanges:(NSArray<NSValue *> *)ranges
{
    _ranges = ranges;
    [self updateView];
}
- (void)setPoint:(float)point
{
    _point = point;
    [self updateView];
}
- (void)setCirclePointRadius:(float)circlePointRadius
{
    _circlePointRadius = circlePointRadius;
    [self updateView];
}

#pragma mark - Circle View
- (void)updateView
{
    for (CAShapeLayer *layer in self.layers) {
        [layer removeFromSuperlayer];
    }
    
    self.layers = [NSMutableArray array];
    for (NSValue *rangeValue in self.ranges) {
        NSRange range = [rangeValue rangeValue];
        CAShapeLayer *layer =  [self getCircleLayerWithRange:range color:[self getColorForIndex:[self.ranges indexOfObject:rangeValue]]];
        [self.layers addObject:layer];
        [self.layer addSublayer:layer];
    }
    
    [self updateCirclePoint];
}

- (CAShapeLayer *)getCircleLayerWithRange:(NSRange)range color:(UIColor *)color
{
    UIBezierPath *circlePath    = [self getCirclePathWithRange:range];
    CAShapeLayer *layer         = [CAShapeLayer layer];
    layer.backgroundColor       = [UIColor whiteColor].CGColor; //
    layer.lineCap               = kCALineCapRound;
    layer.lineWidth             = self.lineWidth;
    layer.fillColor             = [UIColor clearColor].CGColor;
    layer.strokeColor           = color.CGColor;
    layer.path                  = circlePath.CGPath;
    layer.zPosition             = 1;
    return layer;
}

- (void)updateCirclePoint
{
    if (self.circlePoint) {
        [self.circlePoint removeFromSuperlayer];
    }
    float adjustedPoint = 0;
    UIColor *color = self.tintColor;
    for (NSValue *rangeValue in self.ranges) {
        NSRange range = [rangeValue rangeValue];
        if (range.location <= self.point && self.point < range.location+range.length) {
            adjustedPoint = (self.point + 2) - 3*(float)(self.point - range.location)/(float)range.length;
            color = [self getColorForIndex:[self.ranges indexOfObject:rangeValue]];
            break;
        }
    }
    self.circlePoint = [CALayer layer];
    [self.layer addSublayer:self.circlePoint];
    self.circlePoint.frame              = CGRectMake(0, 0, self.circlePointRadius*2, self.circlePointRadius*2);
    self.circlePoint.borderWidth        = self.lineWidth;
    self.circlePoint.cornerRadius       = self.circlePointRadius;
    self.circlePoint.borderColor        = color.CGColor;
    self.circlePoint.zPosition          = 2;
    self.circlePoint.backgroundColor    = [UIColor whiteColor].CGColor;
    self.circlePoint.position = [self getPositionAtAngle:DEGREES_TO_RADIANS([self getAngle:adjustedPoint/100.0f delta:0])];
    [self startAnimation];
}

#pragma mark - Animation

- (void)startAnimation
{
    if (self.animate && self.scales.count > 1) {
        [self.circlePoint removeAllAnimations];
        [self scaleAnimation:0];
    }
}
- (void)scaleAnimation:(NSInteger)index
{
    float start = [[self.scales objectAtIndex:index] floatValue];
    float end = [[self.scales objectAtIndex:index+1] floatValue];
    [CATransaction begin];
    {
        [CATransaction setCompletionBlock:^{
            if (self.scales.count > index+2) {
                [self scaleAnimation:index+1];
            }
        }];
        [self animateFrom:start to:end];
    }
    [CATransaction commit];
}

- (void)animateFrom:(float)fromScale to:(float)toScale
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.duration = self.duration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.fromValue = [NSNumber numberWithFloat:fromScale];
    animation.toValue = [NSNumber numberWithFloat:toScale];
    animation.removedOnCompletion = NO;
    
    animation.fillMode = kCAFillModeForwards;
    [self.circlePoint addAnimation:animation forKey:@"scale_animation"];
}

#pragma mark - Private
- (UIColor *)getColorForIndex:(NSInteger)index
{
    if (index < self.strokeColors.count) {
        return [self.strokeColors objectAtIndex:index];
    }
    return self.tintColor;
}

- (UIBezierPath *)getCirclePathWithRange:(NSRange)range
{
    float startAngle = [self getStartAngle:range.location/100.0f];
    float endAngle = [self getEndAngle:(range.location+range.length)/100.0f];
    return [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width/2.0f, self.bounds.size.height)
                                          radius:[self getRadius]
                                      startAngle:DEGREES_TO_RADIANS(startAngle)
                                        endAngle:DEGREES_TO_RADIANS(endAngle)
                                       clockwise:YES];
}
- (float)getStartAngle:(float)progress
{
    return [self getAngle:progress delta:(progress == 0 ? self.gapWidth/2 : self.gapWidth)];
}
- (float)getEndAngle:(float)progress
{
    return [self getAngle:progress delta:(progress == 1 ? -self.gapWidth/2 : -self.gapWidth)];
}
- (float)getAngle:(float)progress delta:(float)delta
{
    return (-180 + self.radians*(progress + delta));
}
- (float)getRadius
{
    return (self.bounds.size.width * 0.5) - (self.lineWidth/2.0f);
}
- (CGPoint)getPositionAtAngle:(CGFloat)theta
{
    float radius = [self getRadius];
    CGPoint point = CGPointZero;
    point.x = self.center.x + radius * cos(theta);
    point.y = self.frame.size.height + radius * sin(theta);
    point.x -= self.frame.origin.x;
    return point;
}

@end
