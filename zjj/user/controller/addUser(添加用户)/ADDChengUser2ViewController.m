//
//  ADDChengUser2ViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2018/4/12.
//  Copyright © 2018年 ZhiJiangjun-iOS. All rights reserved.
//

#import "ADDChengUser2ViewController.h"
#import "SXSRulerControl.h"
#import "ADDCheng3ViewController.h"
@interface ADDChengUser2ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *birthdaytf;
@property (weak, nonatomic) IBOutlet UILabel *heightlb;
@property (weak, nonatomic) IBOutlet UIView *ruleBgView;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (nonatomic,assign)int  height;
@end

@implementation ADDChengUser2ViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setTBWhiteColor];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.heightlb.text = @"170cm";
     SXSRulerControl *ruler = [[SXSRulerControl alloc]initWithFrame:self.ruleBgView.bounds];
    
    
    ruler.midCount=1;//几个大格标记一个刻度
    ruler.smallCount=5;//一个大格几个小格
    ruler.minValue = 50;// 最小值
    ruler.maxValue = 250;// 最大值
    ruler.valueStep = 5;// 两个标记刻度之间相差大小
    ruler.minorScaleSpacing = 10;
    ruler.selectedValue = 170;// 设置默认值

    
    
    [ruler addTarget:self action:@selector(selectedValueChanged:) forControlEvents:UIControlEventValueChanged]; // 添加监听方法

    [self.ruleBgView addSubview:ruler];
    
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中文
    self.datePicker.locale = locale;
    
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString * mindateStr = @"1900-01-01 00:00:00";
    NSString * defaultDateStr = @"1990-01-01 00:00:00";
    
    NSDate * defaultDate = [formatter dateFromString:defaultDateStr];
    
    NSDate * minDate = [formatter dateFromString:mindateStr];
    NSDate * maxDate = [NSDate date];
    
    [self.datePicker addTarget:self action:@selector(changeValueWithDate:) forControlEvents:UIControlEventValueChanged];
    self.datePicker.minimumDate = minDate;
    self.datePicker.maximumDate = maxDate;
    
    self.datePicker.date = defaultDate;
    
    
    self.birthdaytf.inputView = self.datePicker;
    self.birthdaytf.userInteractionEnabled = NO;
    
    self.birthdaytf.text = [self.datePicker.date yyyymmdd];
    
}
-(void)changeValueWithDate:(UIDatePicker *)datePicker
{
    NSDate* _date = self.datePicker.date;
    self.birthdaytf .text = [_date yyyymmdd];
}
- (void)selectedValueChanged:(SXSRulerControl *)ruler {
    
    self.heightlb.text = [NSString stringWithFormat:@"%0.fcm",ruler.selectedValue];
    _height = ruler.selectedValue;
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"perfectInfodudu" object:nil userInfo:@{@"ruler":@(ruler.selectedValue),@"index":@(self.tag)}];
}
- (IBAction)didNext:(id)sender {
    
    
    
    
    ADDCheng3ViewController * addc2 =[[ADDCheng3ViewController alloc]init];
    addc2.nickname = self.nickname;
    addc2.sex = self.sex;
    addc2.isResignUser = self.isResignUser;
    addc2.birthday = self.birthdaytf.text;
    addc2.height = @(_height);
    
    if (self.imageData) {
        addc2.imageData = self.imageData;
    }
    
    [self.navigationController pushViewController:addc2 animated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
