//
//  NewRentBlanceViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2018/6/7.
//  Copyright © 2018年 ZhiJiangjun-iOS. All rights reserved.
//

#import "NewRentBlanceViewController.h"
#import "RentBlanceUpdateViewController.h"
#import "BaseWebViewController.h"
#import "RefundTheDepositViewController.h"
#import "RefundScheduleViewController.h"
#import "RentBlanceHelpViewController.h"
#import "SuperiorViewController.h"
#import "ADCarouselView.h"
@interface NewRentBlanceViewController ()
@property (weak, nonatomic) IBOutlet UIView *bannerBgView;
@property (weak, nonatomic) IBOutlet UILabel *redPricelb;
@property (weak, nonatomic) IBOutlet UILabel *pricelb;
@property (weak, nonatomic) IBOutlet UILabel *titlelb;
@property (weak, nonatomic) IBOutlet UIButton *psBtn;
@property (weak, nonatomic) IBOutlet UIButton *ztBtn;
@property (weak, nonatomic) IBOutlet UIView *goodsView;
@property (weak, nonatomic) IBOutlet UIButton *defaultBtn;
@property (weak, nonatomic) IBOutlet UIButton *secondBtn;
@property (weak, nonatomic) IBOutlet UILabel *datelb;
@property (weak, nonatomic) IBOutlet UILabel *GoodsPricelb;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;
@property (weak, nonatomic) IBOutlet UIScrollView *defScr;
@property (weak, nonatomic) IBOutlet UIButton *zhuyiBtn;
@property (weak, nonatomic) IBOutlet UIButton *gsBtn;
@property (weak, nonatomic) IBOutlet UIButton *csBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *connectScr;
@property (nonatomic,strong)NSDictionary *infoDict;
@property (nonatomic,strong)ADCarouselView * goodscarouselView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;


@end

@implementation NewRentBlanceViewController
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
    self.title = @"申领减脂套装";
    [self setTBWhiteColor];
    self.defaultBtn.layer.borderColor = HEXCOLOR(0x45b2ad).CGColor;
    self.defaultBtn.layer.borderWidth = 1;
    self.goodsImage.layer.borderColor = HEXCOLOR(0xeeeeee).CGColor;
    self.goodsImage.layer.borderWidth = 1;
    UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithImage:getImage(@"zuc_help_") style:UIBarButtonItemStylePlain target:self action:@selector(helpage)];
    self.navigationItem.rightBarButtonItem = item;
    
    self.infoDict = [NSDictionary dictionary];
    self.defScr.contentSize = CGSizeMake(0, 250+JFA_SCREEN_WIDTH*8.45);

    // Do any additional setup after loading the view from its nib.
//    [self setBannerView];
}
-(void)setBannerView
{
    _goodscarouselView = [ADCarouselView carouselViewWithFrame:CGRectMake(0, 0, JFA_SCREEN_WIDTH, JFA_SCREEN_WIDTH*0.45)];
    _goodscarouselView.loop = YES;
    _goodscarouselView.imgs=  @[@"zuCheng_banner1",@"zuCheng_banner2"];
    _goodscarouselView.automaticallyScrollDuration = 5;
    _goodscarouselView.placeholderImage = [UIImage imageNamed:@"reducedFat_Default"];
    [self.bannerBgView addSubview:_goodscarouselView];
}
-(void)getInfo
{
    NSMutableDictionary * parmas =[NSMutableDictionary dictionary];
    [parmas safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
    self.currentTasks =[[BaseSservice sharedManager]post1:@"app/ordertrail/queryOrderTrialDetail.do" HiddenProgress:NO paramters:parmas success:^(NSDictionary *dic) {
        [self hiddenEmptyView];
        
        NSDictionary * dataDict = [dic safeObjectForKey:@"data"];
        self.infoDict = dataDict;
        
        if ([[dataDict safeObjectForKey:@"isReceive"]isEqualToString:@"1"]) {
            self.defScr.hidden =YES;
            self.bottomView.hidden = YES;
            self.goodsView.hidden = NO;
        }
        else
        {
            self.defScr.hidden = NO;
            self.bottomView.hidden = NO;
            self.goodsView.hidden = YES;
        }
        
        statusNumber = [dataDict safeObjectForKey:@"cargo"];
        [self setStatus];
        [self.goodsImage sd_setImageWithURL:[NSURL URLWithString:[dataDict safeObjectForKey:@"defPicture"]] placeholderImage:getImage(@"default_")];
        self.datelb.text = [[dataDict safeObjectForKey:@"dataTime"]yyyymmdd];
        self.GoodsPricelb.text = [NSString stringWithFormat:@"￥%@",[dataDict safeObjectForKey:@"productPrice"]];
        self.redPricelb.text =[NSString stringWithFormat:@"押金￥%@",[dataDict safeObjectForKey:@"productPrice"]];
        self.titlelb.text = [dataDict safeObjectForKey:@"productName"];
    } failure:^(NSError *error) {
        [self showEmptyViewWithTitle:@"请求失败"];
    }];
}
-(void)setStatus
{
    
    //cargo   1出库 2 已发货 3 发起退款 4 卖家收货 5 拒绝退款 10 已退款
    if ([statusNumber isEqualToString:@"1"]) {
        [self.defaultBtn setTitle:@"正在出库" forState:UIControlStateNormal];
        self.defaultBtn.userInteractionEnabled = NO;
        self.secondBtn.hidden = NO;
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
        [self.defaultBtn setTitle:@"退款进度" forState:UIControlStateNormal];
        self.defaultBtn.userInteractionEnabled = YES;
        self.secondBtn.hidden = YES;
        
        
    }
    else if ([statusNumber isEqualToString:@"5"])
    {
        [self.defaultBtn setTitle:@"拒绝退款" forState:UIControlStateNormal];
        self.defaultBtn.userInteractionEnabled = YES;
        self.secondBtn.hidden = YES;
        
    }
    else if ([statusNumber isEqualToString:@"已退款"])
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
        RefundScheduleViewController * re = [[RefundScheduleViewController alloc]init];
        re.orderNo = [_infoDict safeObjectForKey:@"orderNo"];
        re.price = [_infoDict safeObjectForKey:@"productPrice"];
        [self.navigationController pushViewController:re animated:YES];

        
    }
    else if ([statusNumber isEqualToString:@"5"])
    {
        //       拒绝退款
        
    }
    
}
- (IBAction)RefundThedDeposit:(id)sender {
    //退押金
    
    RefundTheDepositViewController * re = [[RefundTheDepositViewController alloc]init];
    re.orderNo = [_infoDict safeObjectForKey:@"orderNo"];
    [self.navigationController pushViewController:re animated:YES];
    
}
- (IBAction)getGooods:(id)sender {
    
    if (self.zhuyiBtn.selected !=YES) {
        [[UserModel shareInstance]showInfoWithStatus:@"请查看注意事项"];
        return;
    }

    RentBlanceUpdateViewController * re =[[RentBlanceUpdateViewController alloc]init];
    if (self.psBtn.selected==YES||self.ztBtn.selected==YES) {
        if (self.psBtn.selected ==YES) {
            re.isAddress =@"1";
        }else{
            re.isAddress = @"0";
        }
    }else{
        return;
    }

    re.infoDict =self.infoDict;
    [self.navigationController pushViewController:re animated:YES];
}
-(void)helpage
{
    RentBlanceHelpViewController * re =[[RentBlanceHelpViewController alloc]init];
    
    

    
    [self.navigationController pushViewController:re animated:YES];
    
}
- (IBAction)showZhuyiInfo:(id)sender {
    [self helpage];
}
- (IBAction)didClickUj:(id)sender {
    if (self.psBtn.selected ==NO) {
        self.psBtn.selected =YES;
        self.ztBtn.selected = NO;
    }
}

- (IBAction)didClickZy:(id)sender {
    if (self.zhuyiBtn.selected ==NO) {
        self.zhuyiBtn.selected =YES;
//        self.ztBtn.selected =NO;

    }

}

- (IBAction)didClickZt:(id)sender {
    
    
    //supGrade 0 消费者  1普通 2铜牌  3银牌   4 金牌 5 铂金
    if ([UserModel shareInstance].superiorDict&&[[UserModel shareInstance].superiorDict allKeys].count>0) {
        NSString * supGrade =[[UserModel shareInstance].superiorDict safeObjectForKey:@"supGrade"];
        if (![supGrade isEqualToString:@"4"]&&![supGrade isEqualToString:@"5"]) {
            UIAlertController * al =[UIAlertController alertControllerWithTitle:@"" message:@"您的上级非金牌及以上体脂师，无法为您配送体脂秤，您可以选择邮寄方式领取。" preferredStyle:UIAlertControllerStyleAlert];
            [al addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
            
            [self presentViewController:al animated:YES completion:nil];

        }
        else
        {
            if (self.ztBtn.selected ==NO) {
                self.ztBtn.selected =YES;
                self.psBtn.selected = NO;
            }

        }
        
        
        
    }else{
        UIAlertController * al =[UIAlertController alertControllerWithTitle:@"" message:@"您还没有推荐人" preferredStyle:UIAlertControllerStyleAlert];
        [al addAction:[UIAlertAction actionWithTitle:@"去添加" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            SuperiorViewController * sub =[[SuperiorViewController alloc]init];
            [self.navigationController pushViewController:sub animated:YES];
        }]];
        [al addAction:[UIAlertAction actionWithTitle:@"算了吧" style:UIAlertActionStyleCancel handler:nil]];

        [self presentViewController:al animated:YES completion:nil];
        
    }
}
- (IBAction)showGsBtn:(id)sender {
    if (self.gsBtn.selected ==YES) {
        return;
    }
    self.gsBtn.selected =YES;
    self.csBtn.selected = NO;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.connectScr.contentOffset = CGPointMake(0, 0);
    }];
    self.defScr.contentSize = CGSizeMake(0, 250+JFA_SCREEN_WIDTH*8.45);
}
- (IBAction)showCSBtn:(id)sender {
    if (self.csBtn.selected ==YES) {
        return;
    }
    self.gsBtn.selected = NO;
    self.csBtn.selected = YES;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.connectScr.contentOffset = CGPointMake(JFA_SCREEN_WIDTH, 0);
    }];
    self.defScr.contentSize = CGSizeMake(0, 250+JFA_SCREEN_WIDTH*2.61);

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
