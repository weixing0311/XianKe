//
//  PaySuccessViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/8/24.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "PaySuccessViewController.h"
#import "BaseWebViewController.h"
#import "IntegralOrderViewController.h"
#import "IntegralOrderDetailViewController.h"
@interface PaySuccessViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *statusImageView;
@property (weak, nonatomic) IBOutlet UILabel *statuslb;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@end

@implementation PaySuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"支付";
    [self setTBRedColor];
    UIBarButtonItem * backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back_"] style:UIBarButtonItemStylePlain target:self action:@selector(didClickBack)];
    self.navigationItem.leftBarButtonItem = backItem;
    
    if (self.orderType !=4) {
        UIBarButtonItem * rightitem =[[UIBarButtonItem alloc]initWithTitle:@"查看订单" style:UIBarButtonItemStylePlain target:self action:@selector(enterRightPage)];
        self.navigationItem.rightBarButtonItem = rightitem;
   
    }
    [self changePageWithPayStatus];
}



-(void)changePageWithPayStatus
{
    if (self.paySuccess==YES) {
        self.statuslb.text = @"支付成功";
        self.statusImageView.image = getImage(@"zhiTrue");
        self.backBtn.backgroundColor = HEXCOLOR(0x1AAD18);

    }else{
        self.statuslb.text = @"支付失败";
        self.statusImageView.image = getImage(@"zhiFalse_");
        self.backBtn.backgroundColor = [UIColor redColor];

    }
}





-(void)didClickBack
{
    NSMutableArray * arr = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    NSMutableArray * array = [NSMutableArray array];
    [array addObject:arr[0]];
    if (![arr[1]isKindOfClass:[BaseWebViewController class]]) {
        [array addObject:arr[1]];
    }
    
    
    [self.navigationController setViewControllers:array];

}
-(void)enterRightPage
{
    [self paySuccessBackWithType:self.orderType];
}

- (IBAction)didpopToRootVc:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

//支付成功跳转返回
-(void)paySuccessBackWithType:(int )orderType
{
    //        1 消费者订购 2 配送订购 3 服务订购 4 充值 5积分
    
     if (orderType ==5)
    {
        for (UIViewController * controller in self.navigationController.viewControllers) {
            
            if ([controller isKindOfClass:[IntegralOrderDetailViewController class]]) {
                [self.navigationController popToViewController:controller animated:YES];
                //                DLog(@"我曹草草草");
                return ;
            }
            else if ([controller isKindOfClass:[IntegralOrderViewController class]])
            {
                [self.navigationController popToViewController:controller animated:YES];
                return;
            }
        }
        IntegralOrderViewController * mdVC = [[IntegralOrderViewController alloc]init];
        mdVC.hidesBottomBarWhenPushed = YES;
        
        NSMutableArray * arr = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
        [arr removeLastObject];
        [arr removeLastObject];
        [arr addObject:mdVC];
        [self.navigationController setViewControllers:arr];
    }
    else
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
        
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
