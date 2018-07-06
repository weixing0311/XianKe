//
//  RentBlanceUpdateViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2018/5/18.
//  Copyright © 2018年 ZhiJiangjun-iOS. All rights reserved.
//

#import "RentBlanceUpdateViewController.h"
#import "AddressListViewController.h"
#import "BaseWebViewController.h"
@interface RentBlanceUpdateViewController ()
@property (weak, nonatomic) IBOutlet UILabel *addressTitlelb;
@property (weak, nonatomic) IBOutlet UILabel *addressPhonelb;
@property (weak, nonatomic) IBOutlet UILabel *addresslb;
@property (weak, nonatomic) IBOutlet UILabel *pricelb;
@property (nonatomic,strong)NSMutableDictionary * addressDict;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *phoneNum;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UIView *addressView;

@property (weak, nonatomic) IBOutlet UIView *userBgView;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;
@property (weak, nonatomic) IBOutlet UILabel *goodsTitlelb;

@property (weak, nonatomic) IBOutlet UILabel *goodsPricelb;



@end

@implementation RentBlanceUpdateViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.infoDict =[NSDictionary dictionary];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTBWhiteColor];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getAddress:) name:kSendAddress object:nil];

    _addressDict = [NSMutableDictionary dictionary];
    if ([self.isAddress isEqualToString:@"1"]) {
        self.addressView.hidden = NO;
        self.userBgView.hidden = YES;
        [self getDefaultAddressFromNet];

    }else{
        self.addressView.hidden = YES;
        self.userBgView.hidden = NO;

    }
    
    [self.goodsImage sd_setImageWithURL:[NSURL URLWithString:[self.infoDict safeObjectForKey:@"defPicture"]] placeholderImage:getImage(@"default_")];
    self.goodsTitlelb.text = [self.infoDict safeObjectForKey:@"productName"];
    self.goodsPricelb.text = [NSString stringWithFormat:@"￥%@",[self.infoDict safeObjectForKey:@"productPrice"]];
    
    
    
    [self.headImageView setImageWithURL:[NSURL URLWithString:[[UserModel shareInstance].superiorDict safeObjectForKey:@"headimgurl"]] placeholderImage:getImage(@"head_default")];
    self.nickName.text =[[UserModel shareInstance].superiorDict safeObjectForKey:@"userName"];
    self.phoneNum       .adjustsFontSizeToFitWidth = YES;
    self.phoneNum.text =[[UserModel shareInstance]changeTelephone:[ [UserModel shareInstance].superiorDict safeObjectForKey:@"phone"] ];
    
    
    self.pricelb.text =[NSString stringWithFormat:@"￥%@",[self.infoDict safeObjectForKey:@"productPrice"]];
}
-(void)addAddressDict:(NSDictionary *)addressDict
{
    
    [_addressDict setDictionary:addressDict];
    if (!_addressDict||[_addressDict allKeys].count==0) {
        self.addresslb.text = @"您还没有收货地址，请先添加。";
    }else{
        self.addressTitlelb.text = [_addressDict safeObjectForKey:@"receiver"];
        self.addressPhonelb.text = [[UserModel shareInstance]changeTelephone:[_addressDict safeObjectForKey:@"phone"]];
        self.addresslb.text = [NSString stringWithFormat:@"%@%@%@%@",
                               [_addressDict safeObjectForKey:@"province"]?[_addressDict safeObjectForKey:@"province"]:@"",
                               [_addressDict safeObjectForKey:@"city"]?[_addressDict safeObjectForKey:@"province"]:@"",
                               [_addressDict safeObjectForKey:@"county"]?[_addressDict safeObjectForKey:@"county"]:@"",
                               [_addressDict safeObjectForKey:@"addr"]?[_addressDict safeObjectForKey:@"addr"]:@""];
    }

}
-(void)getDefaultAddressFromNet
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[UserModel shareInstance].userId forKey:@"userId"];
    
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/order/getDefaultAddress.do" HiddenProgress:NO paramters:param success:^(NSDictionary *dic) {
        DLog(@"success --%@",dic);
        [self addAddressDict:[dic safeObjectForKey:@"data"] ];
        
    } failure:^(NSError *error) {
        DLog(@"error --%@",error);
        
    }];
    
}
- (IBAction)didPay:(id)sender {
    if ((!_addressDict||[_addressDict allKeys].count<1)&&[self.isAddress isEqualToString:@"1"]) {
        [[UserModel shareInstance]showInfoWithStatus:@"请选择地址"];
        return;
    }
    NSMutableDictionary * params =[NSMutableDictionary dictionary];
    [params safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
    [params safeSetObject:[_addressDict safeObjectForKey:@"id"]?[_addressDict safeObjectForKey:@"id"]:@" " forKey:@"addressID"];
    [params safeSetObject:[self.infoDict safeObjectForKey:@"productNo"] forKey:@"productNo"];
    [params safeSetObject:@"1" forKey:@"quantity"];
    [params safeSetObject:[self.infoDict safeObjectForKey:@"productPrice"] forKey:@"payableAmount"];
    [params safeSetObject:[self.infoDict safeObjectForKey:@"productPrice"] forKey:@"totalPrice"];
    [params safeSetObject:self.isAddress forKey:@"isAddress"];
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

-(void)getAddress:(NSNotification*)noti
{
    [self addAddressDict:noti.userInfo];
    
}

- (IBAction)changeAddresss:(id)sender {
    AddressListViewController *add = [[AddressListViewController alloc]init];
    add.isComeFromOrder = YES;
    add.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:add animated:YES];

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
