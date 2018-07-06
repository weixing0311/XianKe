//
//  UpdataWBOrderViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2018/5/8.
//  Copyright © 2018年 ZhiJiangjun-iOS. All rights reserved.
//

#import "UpdataWBOrderViewController.h"
#import "UpdataAddressCell.h"
#import "UpDateOrderCell.h"
#import "PublicCell.h"
#import "AddressListViewController.h"
#import "BaseWebViewController.h"
#import "WaBaoOrderPriceCell.h"

@interface UpdataWBOrderViewController ()<UITableViewDelegate,UITableViewDataSource,orderPriceCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end

@implementation UpdataWBOrderViewController
{
    NSMutableDictionary * addressDict;

}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.infoDict =[NSMutableDictionary dictionary];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTBWhiteColor];
    addressDict  = [NSMutableDictionary dictionary];
    self.priceLabel.adjustsFontSizeToFitWidth = YES;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getAddress:) name:kSendAddress object:nil];
    
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self setExtraCellLineHiddenWithTb:self.tableview];
    [self getDefaultAddressFromNet];
    self.priceLabel.text =[NSString stringWithFormat:@"需付款：%.2f元",[[self.infoDict safeObjectForKey:@"goodunit"]doubleValue]*[[self.infoDict safeObjectForKey:@"minCount"]intValue]];
    
        
        
    
}
#pragma mark ---notifation
-(void)getAddress:(NSNotification*)noti
{
    [addressDict setDictionary:noti.userInfo];
    
    [self.tableview reloadData];
}
#pragma mark --接口

//获取默认地址
-(void)getDefaultAddressFromNet
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[UserModel shareInstance].userId forKey:@"userId"];
    
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/order/getDefaultAddress.do" HiddenProgress:NO paramters:param success:^(NSDictionary *dic) {
        DLog(@"success --%@",dic);
        [addressDict setDictionary:[dic objectForKey:@"data"]];
        [self.tableview reloadData];
        
        
    } failure:^(NSError *error) {
        DLog(@"error --%@",error);
        
    }];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (section ==1)
//    {
//        return 1;
//    }
//    else if (section ==3)
//    {
//        return 3;
//    }
//    else
//    {
        return 1;
//    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0) {
        static NSString *identifier = @"UpdataAddressCell";
        UpdataAddressCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [self getXibCellWithTitle:identifier];
        }
        if (!addressDict||[addressDict allKeys].count==0) {
            cell.addressLabel.text = @"您还没有收货地址，请先添加。";
        }else{
            
            cell.titleLabel.text = [addressDict safeObjectForKey:@"receiver"];
            cell.phonenumLabel.text = [[UserModel shareInstance]changeTelephone:[addressDict safeObjectForKey:@"phone"]];
            cell.addressLabel.text = [NSString stringWithFormat:@"%@%@%@%@",[addressDict safeObjectForKey:@"province"]?[addressDict safeObjectForKey:@"province"]:@"",[addressDict safeObjectForKey:@"city"]?[addressDict safeObjectForKey:@"province"]:@"",[addressDict safeObjectForKey:@"county"]?[addressDict safeObjectForKey:@"county"]:@"",[addressDict safeObjectForKey:@"addr"]?[addressDict safeObjectForKey:@"addr"]:@""];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        return cell;
    }
    else if (indexPath.section ==1)
    {
        static NSString *identifier = @"UpDateOrderCell";
        UpDateOrderCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [self getXibCellWithTitle:identifier];
        }
        [cell setUpWbInfoWithDict:self.infoDict];
        cell.countLabel.text = [NSString stringWithFormat:@"x%d",self.goodsCount];
        return cell;
        
    }else
    {
        static NSString *identifier = @"WaBaoOrderPriceCell";
        WaBaoOrderPriceCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [self getXibCellWithTitle:identifier];
        }
        cell.delegate = self;
        cell.pricelb.text =[NSString stringWithFormat:@"￥%.2f",[[self.infoDict safeObjectForKey:@"goodunit"]doubleValue]*self.goodsCount];
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section ==0) {
        AddressListViewController *add = [[AddressListViewController alloc]init];
        add.isComeFromOrder = YES;
        [self.navigationController pushViewController:add animated:YES];
    }
    else if (indexPath.section ==1)
    {
        
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0) {
        return 80;
    }else if (indexPath.section ==1)
    {
        return 100;
    }else{
        return 140;
    }
}
-(void)didPayWithCell:(WaBaoOrderPriceCell *)cell
{
    [self didBuy:nil];
}
- (IBAction)didBuy:(id)sender {
    
    
    if (!addressDict||[addressDict allKeys].count<1) {
        [[UserModel shareInstance]showInfoWithStatus:@"请选择地址"];
        return;
    }
    NSMutableDictionary * params =[NSMutableDictionary dictionary];
    [params safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
    [params safeSetObject:[addressDict safeObjectForKey:@"id"] forKey:@"addressID"];
    [params safeSetObject:@(self.goodsCount) forKey:@"quantitySum"];
    [params safeSetObject:[self.infoDict safeObjectForKey:@"id"] forKey:@"periodGoodID"];
    
    
    DLog(@"上传数据---%@",params);
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/periodOrder/savePeriodOrder.do" HiddenProgress:NO paramters:params success:^(NSDictionary *dic) {
        DLog(@"下单成功--%@",dic);
        
        NSDictionary * dataDict =[dic safeObjectForKey:@"data"];
        
        [[UserModel shareInstance]showSuccessWithStatus:@"提交成功"];
        
        BaseWebViewController *web = [[BaseWebViewController alloc]init];
        web.urlStr = @"app/checkstand.html";
        web.payableAmount = [dataDict safeObjectForKey:@"payableAmount"];
        //payType 1 消费者订购 2 配送订购 3 服务订购 4 充值 5积分购买
        web.payType =6;
        web.opt =4;
        web.integral = @"2";
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
