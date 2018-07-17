//
//  MessageDetail1ViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2018/7/13.
//  Copyright © 2018年 ZhiJiangjun-iOS. All rights reserved.
//

#import "MessageDetail1ViewController.h"

@interface MessageDetail1ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titlelb;
@property (weak, nonatomic) IBOutlet UILabel *timelb;
@property (weak, nonatomic) IBOutlet UILabel *contentlb;

@end

@implementation MessageDetail1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTBWhiteColor];
    self.title = @"系统消息";
    self.titlelb.text = [self.infoDict safeObjectForKey:@"title"];
    self.timelb.text = [self.infoDict safeObjectForKey:@"sendTime"];
    self.contentlb.text = [self.infoDict safeObjectForKey:@"sendcontent"];

    // Do any additional setup after loading the view from its nib.
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
