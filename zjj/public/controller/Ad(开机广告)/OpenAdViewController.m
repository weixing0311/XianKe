//
//  OpenAdViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2018/7/10.
//  Copyright © 2018年 ZhiJiangjun-iOS. All rights reserved.
//

#import "OpenAdViewController.h"
#import "TabbarViewController.h"
@interface OpenAdViewController ()
@property (weak, nonatomic) IBOutlet UIButton *bgBtn;
@property (weak, nonatomic) IBOutlet UIButton *stopBtn;

@property (weak, nonatomic) IBOutlet UIImageView *bgimg;
@end

@implementation OpenAdViewController
{
    NSInteger timeNumber;
    NSTimer * _timer;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    timeNumber = 4;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refreshTime) userInfo:nil repeats:YES];
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];

    NSString *imageFilePath = [path stringByAppendingPathComponent:@"MyImage"];
    UIImage *image = [UIImage imageWithContentsOfFile:imageFilePath];
//    [self.bgBtn setImage:image forState:UIControlStateNormal];
    
    
    
//    [self.bgBtn sd_setImageWithURL:[NSURL URLWithString:[[UserModel shareInstance].adDict objectForKey:@"bgimg"]] forState:UIControlStateNormal placeholderImage:image];
    
    
    self.bgimg.image = image;
    
    
//    [self.bgimg sd_setImageWithURL:[NSURL URLWithString:[[UserModel shareInstance].adDict objectForKey:@"bgimg"]] placeholderImage:image completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//        if (error) {
//            DLog(@"加载开机图失败");
//            return ;
//        }
//        self.bgimg.image = image;
//    }];
    
}
- (IBAction)showMessage:(id)sender {
    [self showTabbarView];
    
    [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"kShowAdcPage"];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"kShowAdcPage" object:nil];

    
}
- (IBAction)hiddenMe:(id)sender {
    [self showTabbarView];
}

-(void)showTabbarView
{
    TabbarViewController * tabbar = [[TabbarViewController alloc]init];
    [UserModel shareInstance].tabbarStyle = @"health";
    self.view.window.rootViewController = tabbar;

    
    
}






-(void)refreshTime
{
    if (timeNumber ==0) {
        [_timer invalidate];
        [self showTabbarView];
        return;
    }
    NSLog(@"%ld",(long)timeNumber);
    [self.stopBtn setTitle:[NSString stringWithFormat: @"%ld 跳过",(long)timeNumber] forState:UIControlStateNormal];
    timeNumber --;
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
