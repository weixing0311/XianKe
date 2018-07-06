//
//  RentBalanceViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2018/5/18.
//  Copyright © 2018年 ZhiJiangjun-iOS. All rights reserved.
//

#import "RentBalanceViewController.h"
#import "RentBlanceUpdateViewController.h"
#import "BaseWebViewController.h"
#import "RefundTheDepositViewController.h"
#import "RefundScheduleViewController.h"
#import "RentBlanceHelpViewController.h"

@interface RentBalanceViewController ()
@property (weak, nonatomic) IBOutlet UILabel *datelb;
@property (weak, nonatomic) IBOutlet UILabel *pricelb;
@property (weak, nonatomic) IBOutlet UIView *getGoodsView;
@property (weak, nonatomic) IBOutlet UIView *goodsView;
@property (weak, nonatomic) IBOutlet UIButton *secondBtn;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;
@property (weak, nonatomic) IBOutlet UIView *firstBgView;
@property (nonatomic,strong)NSDictionary *infoDict;
@property (weak, nonatomic) IBOutlet UIButton *defaultBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@end

@implementation RentBalanceViewController
{
    NSString * statusNumber;//cargo   1出库 2 已发货 3 发起退款 4 卖家收货 5 拒绝退款 10 已退款
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [self getInfo];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"体脂称";
    [self setTBWhiteColor];
    self.defaultBtn.layer.borderColor = HEXCOLOR(0x45b2ad).CGColor;
    self.defaultBtn.layer.borderWidth = 1;
    self.goodsImage.layer.borderColor = HEXCOLOR(0xeeeeee).CGColor;
    self.goodsImage.layer.borderWidth = 1;
    UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithImage:getImage(@"zuc_help_") style:UIBarButtonItemStylePlain target:self action:@selector(helpage)];
    self.navigationItem.rightBarButtonItem = item;

    self.infoDict = [NSDictionary dictionary];
    // Do any additional setup after loading the view from its nib.
    
}

-(void)getInfo
{
    
    NSMutableDictionary * parmas =[NSMutableDictionary dictionary];
    [parmas safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
    self.currentTasks =[[BaseSservice sharedManager]post1:@"app/ordertrail/queryOrderTrialDetail.do" HiddenProgress:NO paramters:parmas success:^(NSDictionary *dic) {
        NSDictionary * dataDict = [dic safeObjectForKey:@"data"];
        self.infoDict = dataDict;
        
        self.nextBtn.userInteractionEnabled = YES;
        if ([[dataDict safeObjectForKey:@"isReceive"]isEqualToString:@"1"]) {
            self.getGoodsView.hidden =YES;
            self.goodsView.hidden = NO;
        }
        else
        {
            self.getGoodsView.hidden = NO;
            self.goodsView.hidden = YES;
        }

        statusNumber = [dataDict safeObjectForKey:@"cargo"];
        [self setStatus];
        [self.goodsImage sd_setImageWithURL:[NSURL URLWithString:[dataDict safeObjectForKey:@"defPicture"]] placeholderImage:getImage(@"default_")];
        self.datelb.text = [[dataDict safeObjectForKey:@"dataTime"]yyyymmdd];
        self.pricelb.text = [NSString stringWithFormat:@"￥%@",[dataDict safeObjectForKey:@"productPrice"]];
    } failure:^(NSError *error) {
        
    }];
}
-(void)setStatus
{
    
        //cargo   1出库 2 已发货 3 发起退款 4 卖家收货 5 拒绝退款 10 已退款
        if ([statusNumber isEqualToString:@"1"]) {
            [self.defaultBtn setTitle:@"正在出库" forState:UIControlStateNormal];
            self.defaultBtn.userInteractionEnabled = NO;
            self.secondBtn.hidden = YES;
        }
        else if ([statusNumber isEqualToString:@"2"]){
            [self.defaultBtn setTitle:@"查看物流" forState:UIControlStateNormal];
            self.defaultBtn.userInteractionEnabled = YES;
            self.secondBtn.hidden = NO;

        }
        else if ([statusNumber isEqualToString:@"3"])
        {
            [self.defaultBtn setTitle:@"退款进度" forState:UIControlStateNormal];
            self.defaultBtn.userInteractionEnabled = YES;
            self.secondBtn.hidden = YES;

        }
        else if ([statusNumber isEqualToString:@"4"])
        {
            [self.defaultBtn setTitle:@"退押金" forState:UIControlStateNormal];
            self.defaultBtn.userInteractionEnabled = YES;
            self.secondBtn.hidden = YES;


        }
        else if ([statusNumber isEqualToString:@"5"])
        {
            [self.defaultBtn setTitle:@"拒绝退款" forState:UIControlStateNormal];
            self.defaultBtn.userInteractionEnabled = YES;
            self.secondBtn.hidden = YES;

        }

        
    

}
- (IBAction)searchLogistics:(id)sender {
    
    
    
    //cargo   1出库 2 已发货 3 发起退款 4 卖家收货 5 拒绝退款 10 已退款
    if ([statusNumber isEqualToString:@"1"]) {
        //正在出库
    }
    else if ([statusNumber isEqualToString:@"2"]){
        BaseWebViewController * web =[[BaseWebViewController alloc]init];
        web.title = @"我的配送";
        NSString * orderNo = [_infoDict safeObjectForKey:@"orderNo"];
        if (orderNo.length<1) {
            return;
        }
        web.urlStr = [NSString stringWithFormat:@"app/fatTeacher/logisticsInformation.html?orderNo=%@",orderNo];
        [self.navigationController pushViewController:web animated:YES];

    }
    else if ([statusNumber isEqualToString:@"3"])
    {
//        退款进度
        RefundScheduleViewController * re = [[RefundScheduleViewController alloc]init];
        re.orderNo = [_infoDict safeObjectForKey:@"orderNo"];
        re.price = [_infoDict safeObjectForKey:@"productPrice"];
        [self.navigationController pushViewController:re animated:YES];

    }
    else if ([statusNumber isEqualToString:@"4"])
    {
        RefundTheDepositViewController * re = [[RefundTheDepositViewController alloc]init];
        re.orderNo = [_infoDict safeObjectForKey:@"orderNo"];
        [self.navigationController pushViewController:re animated:YES];

        
    }
    else if ([statusNumber isEqualToString:@"5"])
    {
//       拒绝退款
        
    }

    
    
    

    
}
- (IBAction)RefundThedDeposit:(id)sender {
    RefundTheDepositViewController * re = [[RefundTheDepositViewController alloc]init];
    re.orderNo = [_infoDict safeObjectForKey:@"orderNo"];
    [self.navigationController pushViewController:re animated:YES];

}
- (IBAction)getGooods:(id)sender {
    RentBlanceUpdateViewController * re =[[RentBlanceUpdateViewController alloc]init];
    re.infoDict =self.infoDict;
    [self.navigationController pushViewController:re animated:YES];
}
-(void)helpage
{
    
    RentBlanceHelpViewController * re =[[RentBlanceHelpViewController alloc]init];
    [self.navigationController pushViewController:re animated:YES];

}
- (IBAction)getGoodsWithOutPs:(id)sender {
    
    NSMutableDictionary * params =[NSMutableDictionary dictionary];
    [params safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
    [params safeSetObject:@"" forKey:@"addressID"];
    [params safeSetObject:[self.infoDict safeObjectForKey:@"productNo"] forKey:@"productNo"];
    [params safeSetObject:@"1" forKey:@"quantity"];
    [params safeSetObject:[self.infoDict safeObjectForKey:@"productPrice"] forKey:@"payableAmount"];
    [params safeSetObject:[self.infoDict safeObjectForKey:@"productPrice"] forKey:@"totalPrice"];
    [params safeSetObject:@"0" forKey:@"isAddress"];
    [params safeSetObject:[self.infoDict safeObjectForKey:@"warehouseNo"] forKey:@"warehouseNo"];
    
    DLog(@"上传数据---%@",params);
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/ordertrail/saveOrderTrial.do" HiddenProgress:NO paramters:params success:^(NSDictionary *dic) {
        DLog(@"下单成功--%@",dic);
        
        NSDictionary * dataDict =[dic safeObjectForKey:@"data"];
        
        [[UserModel shareInstance]showSuccessWithStatus:@"提交成功"];
        
        BaseWebViewController *web = [[BaseWebViewController alloc]init];
        web.urlStr = @"app/checkstand.html";
        web.payableAmount = [dataDict safeObjectForKey:@"payableAmount"];
        //payType 1 消费者订购 2 配送订购 3 服务订购 4 充值 5积分购买
        web.payType =7;
        web.opt =5;
        web.integral = @"3";
        web.orderNo = [dataDict safeObjectForKey:@"orderNo"];
        web.title  =@"收银台";
        [self.navigationController pushViewController:web animated:YES];
        
        
    } failure:^(NSError *error) {
        //        [[UserModel shareInstance]showErrorWithStatus:@"提交失败"];
        
        DLog(@"下单失败--%@",error);
    }];

    
    
    
    
    
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
