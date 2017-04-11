
#import <UIKit/UIKit.h>

@interface PointCircleView : UIView

//Circle
@property (nonatomic, assign) NSInteger lineWidth;  //default 5
@property (nonatomic, assign) float gapWidth;       //default 0.013
@property (nonatomic, assign) float radians;        //default 180 (0~360)
@property (nonatomic, assign) float point;          //default 0 (0~100)

@property (nonatomic, strong) NSArray<NSNumber *> *scales;   //default = [0,1], bounce = [1,2,1], '1' means original 'scale'
@property (nonatomic, strong) NSArray<NSValue *> *ranges;           //0 ~ 100, default = tint color
@property (nonatomic, strong) NSArray<UIColor *> *strokeColors;     //default = tint color
@property (nonatomic, strong) CALayer *circlePoint;
@property (nonatomic, assign) float circlePointRadius;  //default 8

//Count label
@property (nonatomic, assign) NSTimeInterval duration;  //default 1;

@property (nonatomic, assign) BOOL animate;

+ (PointCircleView *)getCircleView:(CGRect)rect;
- (void)updateView;
@end
