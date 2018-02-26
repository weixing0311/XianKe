//
//  YFWViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2018/1/15.
//  Copyright © 2018年 ZhiJiangjun-iOS. All rights reserved.
//

#import "YFWViewController.h"

@interface YFWViewController ()

@end

@implementation YFWViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title  = @"云服务";
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)pushAppStrore:(id)sender {
    [[UIApplication sharedApplication ] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/id1335471147"]];

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
