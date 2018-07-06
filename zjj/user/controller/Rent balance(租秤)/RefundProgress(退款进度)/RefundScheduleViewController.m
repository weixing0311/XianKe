//
//  RefundScheduleViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2018/5/18.
//  Copyright © 2018年 ZhiJiangjun-iOS. All rights reserved.
//

#import "RefundScheduleViewController.h"

@interface RefundScheduleViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lb1;
@property (weak, nonatomic) IBOutlet UILabel *lb2;
@property (weak, nonatomic) IBOutlet UILabel *lb3;
@property (weak, nonatomic) IBOutlet UILabel *lb4;
@property (weak, nonatomic) IBOutlet UILabel *pricelb;

@end

@implementation RefundScheduleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"退款进度";
    [self setTBWhiteColor];
    self.pricelb.text = [NSString stringWithFormat:@"￥%@",self.price];
    // Do any additional setup after loading the view from its nib.
    [self getInfo];
}
-(void)getInfo {
    NSMutableDictionary * params =[NSMutableDictionary dictionary];
    [params safeSetObject:self.orderNo forKey:@"orderNO"];
    
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/ordertrail/refundProcess.do" HiddenProgress:NO paramters:params success:^(NSDictionary *dic) {
        NSString * type1 = [[dic safeObjectForKey:@"data"]safeObjectForKey:@"DepositStatus"];
        [self changeColorWithStatus:type1];
        
    } failure:^(NSError *error) {
        
    }];
    
}
-(void)changeColorWithStatus:(NSString *)status
{
    if ([status isEqualToString:@"3"]) {
        self.lb1.backgroundColor = HEXCOLOR(0xEE782B);
        self.lb2.backgroundColor = HEXCOLOR(0xEE782B);
        self.lb3.backgroundColor = HEXCOLOR(0xeeeeee);
        self.lb4.backgroundColor = HEXCOLOR(0xeeeeee);

    }
    else if ([status isEqualToString:@"4"])
    {
        self.lb1.backgroundColor = HEXCOLOR(0xEE782B);
        self.lb2.backgroundColor = HEXCOLOR(0xEE782B);
        self.lb3.backgroundColor = HEXCOLOR(0xEE782B);
        self.lb4.backgroundColor = HEXCOLOR(0xeeeeee);

    }
    else if ([status isEqualToString:@"5"])
    {
        self.lb1.backgroundColor = HEXCOLOR(0xEE782B);
        self.lb2.backgroundColor = HEXCOLOR(0xEE782B);
        self.lb3.backgroundColor = HEXCOLOR(0xEE782B);
        self.lb4.backgroundColor = [UIColor redColor];

    }
    else if ([status isEqualToString:@"10"])
    {
        self.lb1.backgroundColor = HEXCOLOR(0xEE782B);
        self.lb2.backgroundColor = HEXCOLOR(0xEE782B);
        self.lb3.backgroundColor = HEXCOLOR(0xEE782B);
        self.lb4.backgroundColor = HEXCOLOR(0xEE782B);

    }

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
