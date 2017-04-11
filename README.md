# PointCircleView

Circle animating view with a small circle point.
![alt text](https://github.com/skswhwo/PointCircleView/blob/master/1.jpeg "demo")
![alt text](https://github.com/skswhwo/PointCircleView/blob/master/2.jpeg "demo")
![alt text](https://github.com/skswhwo/PointCircleView/blob/master/3.jpeg "demo")

## Installation

PointCircleView is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

`
pod "PointCircleView"
`

And then run:

`
$ pod install
`

## Usage

### Init
```objective-c
+ (PointCircleView *)getCircleView:(CGRect)rect;

```

### Trigger
```objective-c
- (void)updateView;
```

### Properties
```objective-c
@property (nonatomic, assign) NSInteger lineWidth;      //default 5
@property (nonatomic, assign) float gapWidth;           //default 0.013
@property (nonatomic, assign) float radians;            //default 180 (0~360)
@property (nonatomic, assign) float point;              //default 0 (0~100)
@property (nonatomic, assign) float circlePointRadius;  //default 8
@property (nonatomic, strong) NSArray<NSNumber *> *scales;   //default = [0,1], bounce = [1,2,1], '1' means original 'scale'
@property (nonatomic, strong) NSArray<NSValue *> *ranges;           //0 ~ 100, default = tint color
@property (nonatomic, strong) NSArray<UIColor *> *strokeColors;     //default = tint color

```

## Usage

```objective-c
#import <PointCircleView/PointCircleView.h>
```

```objective-c
NSMutableArray *ranges = [NSMutableArray array];
[ranges addObject:[NSValue valueWithRange:NSMakeRange(0, 15)]];     //0~14
[ranges addObject:[NSValue valueWithRange:NSMakeRange(15, 35)]];    //15~49
[ranges addObject:[NSValue valueWithRange:NSMakeRange(50, 35)]];    //50~84
[ranges addObject:[NSValue valueWithRange:NSMakeRange(85, 16)]];    //85~100
[self.circleView setRanges:ranges];

NSMutableArray *colors = [NSMutableArray array];
[colors addObject:UIColorFromRGB(0x01579b)];
[colors addObject:UIColorFromRGB(0x0288D1)];
[colors addObject:UIColorFromRGB(0x03A9F4)];
[colors addObject:UIColorFromRGB(0x4FC3F7)];
[self.circleView setStrokeColors:colors];

self.circleView.radians = 180;  //0 ~ 360
self.circleView.scales = @[@(0),@(1)];
self.circleView.duration = 1;

[self.view addSubview:self.circleView];
[self.circleView updateView];
```

## Author

skswhwo, skswhwo@gmail.com

## License

PointCircleView is available under the MIT license. See the LICENSE file for more info.
