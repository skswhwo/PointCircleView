//
//  ViewController.m
//  PointCircleView
//
//  Created by Jaehyun Cho on 2017. 4. 11..
//  Copyright © 2017년 Jaehyun Cho. All rights reserved.
//

#import "ViewController.h"
#import "PointCircleView.h"

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@interface ViewController ()
{
}
@property (weak, nonatomic) IBOutlet PointCircleView *circleView;
@property (weak, nonatomic) IBOutlet UILabel *lineWidthLabel;
@property (weak, nonatomic) IBOutlet UILabel *gapLabel;
@property (weak, nonatomic) IBOutlet UILabel *circlePointRadiusLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointLabel;
@property (weak, nonatomic) IBOutlet UISlider *pointSlider;
@property (weak, nonatomic) IBOutlet UILabel *largePointLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    
    self.circleView.radians = 360;  //0 ~ 360
    self.circleView.scales = @[@(0),@(1)];
    self.circleView.duration = 1;
    [self.view addSubview:self.circleView];
    [self.circleView updateView];
    
    [self updateScreen];
}

- (void)updateScreen
{
    self.lineWidthLabel.text = [NSString stringWithFormat:@"%@",@(self.circleView.lineWidth)];
    self.gapLabel.text = [NSString stringWithFormat:@"%.03f",self.circleView.gapWidth];
    self.circlePointRadiusLabel.text = [NSString stringWithFormat:@"%@",@(self.circleView.circlePointRadius)];
    NSInteger value = roundf(self.pointSlider.value);
    self.pointLabel.text = [NSString stringWithFormat:@"%@",@(value)];
}
- (IBAction)lineWidthChanged:(UISlider *)sender
{
    self.circleView.animate = NO;
    self.circleView.lineWidth = sender.value;
    [self updateScreen];
}
- (IBAction)gapChanged:(UISlider *)sender
{
    self.circleView.animate = NO;
    self.circleView.gapWidth = sender.value;
    [self updateScreen];
}
- (IBAction)radiusChanged:(UISlider *)sender
{
    NSInteger value = roundf(sender.value);
    self.circleView.animate = NO;
    [self.circleView setCirclePointRadius:value];
    [self updateScreen];
}
- (IBAction)pointChanged:(UISlider *)sender
{
    self.circleView.animate = NO;
    NSInteger value = roundf(self.pointSlider.value);
    [self.circleView setPoint:value];

    [self updateScreen];
}
- (IBAction)applyButtonClicked:(id)sender
{
    self.circleView.animate = YES;
    NSInteger value = roundf(self.pointSlider.value);
    [self.circleView setPoint:value];
    
    [self updateLargePoint];
}

- (void)updateLargePoint
{
    float duration = 0.5;
    float interval = 0.001;
    NSInteger totalCount = duration/interval;
    NSInteger value = roundf(self.pointSlider.value);
    __block float checkPoint = (float)totalCount/(float)value;
    __block NSInteger count = 0;

    [NSTimer scheduledTimerWithTimeInterval:interval repeats:true block:^(NSTimer * _Nonnull timer) {
        count = count + 1;
        NSInteger newValue = count/checkPoint;
        self.largePointLabel.text = [NSString stringWithFormat:@"%@",@(newValue)];
        if (totalCount == count) {
            [timer invalidate];
        }
    }];
}

@end
