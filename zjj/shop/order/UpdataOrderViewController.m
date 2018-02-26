//
//  UpdataOrderViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/6/21.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "UpdataOrderViewController.h"
#import "UpdataAddressCell.h"
#import "UpDateOrderCell.h"
#import "PublicCell.h"
#import "AddressListViewController.h"
#import "shopCarCellItem.h"
#import "GoodsDetailItem.h"
#import "BaseWebViewController.h"
//#import "MyVoucthersViewController.h"
@interface UpdataOrderViewController ()//<myVoucthersDelegate>

@end

@implementation UpdataOrderViewController
{
    NSMutableDictionary * addressDict;
    NSString            * weightStr; //运费
    NSString            * warehouseNo;//仓储编号
    NSMutableDictionary * voucthersDict;//优惠券
    NSString            * payableAmountStr; //付款金额
    NSString            * totalPriceStr;//原始金额
    NSString            * vouchersCountStr;//优惠券数量
    NSString            * vouchersNameStr;

}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.dataArray =[NSMutableArray array];
        self.param = [NSMutableDictionary dictionary];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"提交订单";
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getAddress:) name:kSendAddress object:nil];

    [self setNbColor];
    self.tableview.delegate =self;
    self.tableview.dataSource = self;
    self.priceLabel.adjustsFontSizeToFitWidth = YES;
    payableAmountStr = [self.param safeObjectForKey:@"payableAmount"];
    totalPriceStr = [self.param safeObjectForKey:@"totalPrice"];
    
    addressDict    =[NSMutableDictionary dictionary];
    voucthersDict  =[NSMutableDictionary dictionary];
    [self setExtraCellLineHiddenWithTb:self.tableview];
    [self getDefaultAddressFromNet];
//    [self getVouchersWithArrString:[self getVoucthersInfo]];
    // Do any additional setup after loading the view from its nib.
}
//-(void)getVouchersWithArrString:(NSString *)string
//{
//    [[VouchersModel shareInstance] getMyUseVoucthersArrayWithproductArr:string Success:^(NSArray *resultArr) {
//
//
//
//        if (resultArr.count ==0) {
//            vouchersCountStr = @"暂无优惠券";
//        }else{
//            vouchersCountStr = [NSString stringWithFormat:@"您有%lu张优惠券",(unsigned long)resultArr.count];
//        }
//        [self.tableview reloadData];
//
//    } fail:^(NSString *errorStr) {
//        vouchersCountStr = @"暂无优惠券";
//        [self.tableview reloadData];
//
//    }];
//
////    [[VouchersModel shareInstance]getMyUseVoucthersWithproductArr:string Success:^(NSDictionary *dic) {
////        DLog(@"dic--%@",dic);
////        [voucthersDict setDictionary:dic];
////        [self changePriceWithVouchers];
////
////    } fail:^(NSString *errorStr) {
////        DLog(@"error--%@",errorStr);
////        [voucthersDict removeAllObjects];
////        [self.tableview reloadData];
////    }];
//}

//-(void)changePriceWithVouchers
//{
//    int type = [[voucthersDict objectForKey:@"type"]intValue];
//    float amount = [[voucthersDict safeObjectForKey:@"amount"]floatValue];
//
//    if (type ==4) {
//        self.priceLabel.text =[NSString stringWithFormat:@"实付款：￥%.2f",[payableAmountStr floatValue]];
//
//    }else if (type ==5)
//    {
//        self.priceLabel.text =[NSString stringWithFormat:@"实付款：￥%.2f",[payableAmountStr floatValue]-(([weightStr floatValue]-amount)>0?([weightStr floatValue]-amount):0)];
//    }else
//    {
//        if ([payableAmountStr floatValue]+[weightStr floatValue]>amount) {
//            self.priceLabel.text =[NSString stringWithFormat:@"实付款：￥%.2f",[payableAmountStr floatValue]+[weightStr floatValue]-amount];
//        }else{
//            self.priceLabel.text =[NSString stringWithFormat:@"实付款：￥0.00"];
//        }
//    }
//    [self.tableview reloadData];
//
//}

#pragma mark ---notifation
-(void)getAddress:(NSNotification*)noti
{
    vouchersNameStr = nil;
    voucthersDict = nil;
    [addressDict setDictionary:noti.userInfo];
    [self getwarehousingWithproviceId:[addressDict objectForKey:@"provinceId"]];

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

        addressDict =[NSMutableDictionary dictionaryWithDictionary:[dic objectForKey:@"data"]];
        [self.tableview reloadData];

        [self getwarehousingWithproviceId:[addressDict objectForKey:@"provinceId"]];
        
    } failure:^(NSError *error) {
        DLog(@"error --%@",error);

    }];
    
}
/**
 *  获取仓储
 */
-(void)getwarehousingWithproviceId:(NSString *)proviceId
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[self getWarehousingUpdateInfo] forKey:@"products"];
    [param setObject:proviceId forKey:@"proviceId"];
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/orderList/getWarehouseNo.do" HiddenProgress:NO paramters:param success:^(NSDictionary *dic) {
        NSDictionary * dict = [dic safeObjectForKey:@"data"];
        warehouseNo = [dict safeObjectForKey:@"warehouseNo"];
        [self getTransfortationPriceWithproviceId:proviceId warehouseNo:warehouseNo];
    } failure:^(NSError *error) {
        DLog(@"error --%@",error);
    }];
    

}


///获取运费
-(void)getTransfortationPriceWithproviceId:(NSString *)proviceId warehouseNo:(NSString*)warehouseNo1
{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param safeSetObject:[self getufUpdatainfo] forKey:@"products"];
    [param safeSetObject:proviceId forKey:@"proviceId"];
    [param safeSetObject:warehouseNo1 forKey:@"warehouseNo"];
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/freigthCount/freigthProductCount.do" HiddenProgress:NO paramters:param success:^(NSDictionary *dic) {
        weightStr = [[dic objectForKey:@"data"]objectForKey:@"freight"];
        
        
//        if (voucthersDict&&[voucthersDict allKeys].count>0) {
//            float amount = [[voucthersDict safeObjectForKey:@"amount"]floatValue];
//            if ([payableAmountStr floatValue]+[weightStr floatValue]>amount) {
//                self.priceLabel.text =[NSString stringWithFormat:@"实付款：￥%.2f",[payableAmountStr floatValue]+[weightStr floatValue]-amount];
//            }else{
//                self.priceLabel.text =[NSString stringWithFormat:@"实付款：￥0.00"];
//            }
//        }else{
            self.priceLabel.text =[NSString stringWithFormat:@"实付款：￥%.2f",[[self.param objectForKey:@"payableAmount"]floatValue]+[weightStr floatValue]];
//        }

        
        [self.tableview reloadData];
    } failure:^(NSError *error) {
        DLog(@"error --%@",error);
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section ==1)
    {
        return _dataArray.count;
    }
    else if (section ==3)
    {
        return 3;
    }
    else
    {
        return 1;
    }
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
        
        if (self.orderType==IS_FROM_SHOPCART) {
           
            shopCarCellItem *item = [self.dataArray objectAtIndex:indexPath.row];
            [cell setUpCellWithShopCarCellItem:item];
            
        }else if(self.orderType ==IS_FROM_GOODSDETAIL){
            GoodsDetailItem *item = [self.dataArray objectAtIndex:indexPath.row];
            [cell setUpCellWithGoodsDetailItem:item];
            cell.countLabel.text = [NSString stringWithFormat:@"x%d",self.goodsCount];
        }else{
            NSDictionary * dic = [self.dataArray objectAtIndex:indexPath.row];
            [cell setUpCellWithDict:dic];
            cell.countLabel.text = [NSString stringWithFormat:@"x%@",[dic objectForKey:@"quantity"]];
        }
        return cell;

    }else if (indexPath.section ==2){
        static NSString *identifier = @"PublicCell";
        PublicCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [self getXibCellWithTitle:identifier];
        }
        cell.headImageView.image = [UIImage imageNamed:@"car_"];
        cell.titleLabel.text = @"配送方式";
        cell.secondLabel.text =@"快递配送";
        return cell;

//    }
//    else if (indexPath.section ==3){
//
//        static NSString *identifier = @"VotchersCell";
//        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//        if (!cell) {
//            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
//        }
//
//        cell.textLabel.text = @"优惠券";
    
//        if (voucthersDict&&[voucthersDict allKeys].count>0) {
//            int type = [[voucthersDict safeObjectForKey:@"type"]intValue];
//            if (type ==2) {
//                cell.detailTextLabel.text = [NSString stringWithFormat:@"%.0f折",[[voucthersDict safeObjectForKey:@"discountAmount"]floatValue]*10];
//            }else{
//                cell.detailTextLabel.text = [NSString stringWithFormat:@"-%@",[voucthersDict safeObjectForKey:@"discountAmount"]];
//            }
//        }else{
//        cell.detailTextLabel.text = vouchersNameStr?vouchersNameStr:vouchersCountStr;
////        }
//        cell.detailTextLabel.textColor = [UIColor redColor];
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        return cell;
    }else{
        static NSString *identifier = @"cell";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        }
        cell.detailTextLabel.textColor =[UIColor redColor];
        if (indexPath.row ==0) {
            cell.textLabel.text = @"商品金额";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"+￥%.2f",[[self.param objectForKey:@"totalPrice"]floatValue]];
        }else if (indexPath.row ==1)
        {
            cell.textLabel.text = @"立减";
            
            float amount = [[VouchersModel shareInstance]getUhpriceWithDict:voucthersDict weightPrice:weightStr];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"-￥%.2f",[[self.param objectForKey:@"totalPrice"]floatValue]-[[self.param objectForKey:@"payableAmount"]floatValue]+amount];
        }else{
            
            cell.textLabel.text = @"运费";

            int type = [[voucthersDict objectForKey:@"type"]intValue];
            float amount = [[voucthersDict safeObjectForKey:@"amount"]floatValue];
            
            if (type ==4) {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"+￥0.00"];
                
            }else if (type ==5)
            {
                cell.detailTextLabel.text =[NSString stringWithFormat:@"￥%.2f",([weightStr floatValue]-amount>0?([weightStr floatValue]-amount):0)];
            }
            else
            {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"+￥%.2f",[weightStr floatValue]];
            }
        }
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
//    else if(indexPath.section ==3)
//    {
//        MyVoucthersViewController * voucher = [[MyVoucthersViewController alloc]init];
//        voucher.myType = IS_FROM_SHOPDG;
//        voucher.delegate = self;
//        voucher.chooseDict = voucthersDict;
//        voucher.productArr = [self getVoucthersInfo];
//        [self.navigationController pushViewController:voucher animated:YES];
//    }
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
        return 44;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)didBuy:(id)sender {
    
    
    if (!addressDict||[addressDict allKeys].count<1) {
        [[UserModel shareInstance]showInfoWithStatus:@"请选择地址"];
        return;
    }
    
    [self.param safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
    [self.param safeSetObject:[addressDict safeObjectForKey:@"receiver"] forKey:@"consigneeName"];
    [self.param safeSetObject:[addressDict safeObjectForKey:@"phone"] forKey:@"consigneePhone"];
    [self.param safeSetObject:[addressDict safeObjectForKey:@"addr"] forKey:@"consigneeAddress"];
    [self.param safeSetObject:[addressDict safeObjectForKey:@"provinceId"] forKey:@"province"];
    [self.param safeSetObject:[addressDict safeObjectForKey:@"cityId"] forKey:@"city"];
    [self.param safeSetObject:[addressDict safeObjectForKey:@"countyId"] forKey:@"county"];
    
    
    float totalPrice = [totalPriceStr floatValue];
    float payableAmount = [payableAmountStr floatValue];
    
    
    totalPrice+=[weightStr floatValue];
    [self.param safeSetObject:@(totalPrice) forKey:@"totalPrice"];
    [self.param safeSetObject:@([self getTruePayAmountPrice:payableAmount]) forKey:@"payableAmount"];
    [self.param safeSetObject:@([self getWeightPrice]) forKey:@"freight"];
    
    
//    if (voucthersDict&&[voucthersDict allKeys].count>0) {
//        [self.param safeSetObject:[voucthersDict safeObjectForKey:@"couponNo"] forKey:@"couponNo"];
//    }
    [self.param safeSetObject:warehouseNo forKey:@"warehouseNo"];
    
    
    DLog(@"上传数据---%@",self.param);
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/order/saveOrderInfo.do" HiddenProgress:NO paramters:self.param success:^(NSDictionary *dic) {
        DLog(@"下单成功--%@",dic);
        
        NSDictionary * dataDict =[dic safeObjectForKey:@"data"];
        
        [[UserModel shareInstance]showSuccessWithStatus:@"提交成功"];
        BaseWebViewController *web = [[BaseWebViewController alloc]init];
        web.urlStr = @"app/checkstand.html";
        web.payableAmount = [dataDict safeObjectForKey:@"payableAmount"];
        //payType 1 消费者订购 2 配送订购 3 服务订购 4 充值
        web.payType =1;
        web.opt =1;
        web.orderNo = [dataDict safeObjectForKey:@"orderNo"];
        web.title  =@"收银台";
        [self.navigationController pushViewController:web animated:YES];

        
        
        
        
    } failure:^(NSError *error) {
//        [[UserModel shareInstance]showErrorWithStatus:@"提交失败"];

        DLog(@"下单失败--%@",error);
    }];
}

#pragma mark ---voucthersDelegate
//-(void)getVoucthersToUseWithId:(NSDictionary * )voucthersId
//{
//    DLog(@"voucthers--%@",voucthersId);
//    if (voucthersDict&&[voucthersDict allKeys].count>0) {
//        NSString * couponNo= [voucthersId safeObjectForKey:@"couponNo"];
//        NSString * indexCouponNo = [voucthersDict safeObjectForKey:@"couponNo"];
//        if ([couponNo isEqualToString:indexCouponNo]) {
//            voucthersDict =nil;
//            self.priceLabel.text =[NSString stringWithFormat:@"实付款：￥%.2f",[payableAmountStr floatValue]+[weightStr floatValue]];
//            vouchersNameStr = nil;
//        }else{
//            voucthersDict  =[NSMutableDictionary dictionaryWithDictionary:voucthersId];
//            vouchersNameStr =[voucthersDict safeObjectForKey:@"grantName"];
//
//            float amount = [[voucthersDict safeObjectForKey:@"amount"]floatValue];
//            int type = [[voucthersDict safeObjectForKey:@"type"]intValue];
//
//            if (type==4||type==5) {
//                float weightPrice = [weightStr floatValue];
//                if (type ==4) {
//                    weightPrice = 0.0;
//                }else{
//                    weightPrice = weightPrice-amount>0?weightPrice-amount:0.0;
//                }
//                self.priceLabel.text =[NSString stringWithFormat:@"实付款：￥%.2f",[payableAmountStr floatValue]+weightPrice];
//            }else{
//
//            if ([payableAmountStr floatValue]+[weightStr floatValue]>amount) {
//                self.priceLabel.text =[NSString stringWithFormat:@"实付款：￥%.2f",[payableAmountStr floatValue]+[weightStr floatValue]-amount];
//            }else{
//                self.priceLabel.text =[NSString stringWithFormat:@"实付款：￥0.00"];
//            }
//        }
//        }
//    }else{
//        voucthersDict  =[NSMutableDictionary dictionaryWithDictionary:voucthersId];
//        vouchersNameStr =[voucthersDict safeObjectForKey:@"grantName"];
//        float amount = [[voucthersDict safeObjectForKey:@"amount"]floatValue];
//        int type = [[voucthersDict safeObjectForKey:@"type"]intValue];
//
//        if (type==4||type==5) {
//            float weightPrice = [weightStr floatValue];
//            if (type ==4) {
//                weightPrice = 0.0;
//            }else{
//                weightPrice = weightPrice-amount>0?weightPrice-amount:0.0;
//            }
//            self.priceLabel.text =[NSString stringWithFormat:@"实付款：￥%.2f",[payableAmountStr floatValue]+weightPrice];
//        }else{
//
//        if ([payableAmountStr floatValue]+[weightStr floatValue]>amount) {
//            self.priceLabel.text =[NSString stringWithFormat:@"实付款：￥%.2f",[payableAmountStr floatValue]+[weightStr floatValue]-amount];
//        }else{
//            self.priceLabel.text =[NSString stringWithFormat:@"实付款：￥0.00"];
//        }
//        }
//    }
//    [self.tableview reloadData];
//}


#pragma mark--获取仓储接口上传数据
/**
 *获取仓储接口提交数据
 */
-(NSString *)getWarehousingUpdateInfo
{
    NSMutableArray * arr=[NSMutableArray array];
    for (int i=0; i<_dataArray.count; i++) {
        if (self.orderType==IS_FROM_SHOPCART) {
            shopCarCellItem * item  =[self.dataArray objectAtIndex:i];
            NSString *  productNo  =item.productNo;
            NSString * quantity = item.quantity;
            
            NSMutableDictionary * dict = [NSMutableDictionary dictionary];
            [dict safeSetObject:productNo forKey:@"productNo"];
            [dict safeSetObject:quantity forKey:@"quantity"];
            [arr addObject:dict];
        }
        
        else if(self.orderType ==IS_FROM_GOODSDETAIL)
        {
            GoodsDetailItem * item = [self.dataArray objectAtIndex:i];
            NSString *  productNo  =item.productNo;
            NSString * quantity = [NSString stringWithFormat:@"%d",self.goodsCount];
            
            NSMutableDictionary * dict = [NSMutableDictionary dictionary];
            [dict safeSetObject:productNo forKey:@"productNo"];
            [dict safeSetObject:quantity forKey:@"quantity"];
            [arr addObject:dict];
        }else
        {
            NSDictionary * item = [self.dataArray objectAtIndex:i];
            NSString *  productNo  =[item objectForKey:@"productNo"] ;
            NSString * quantity = [NSString stringWithFormat:@"%@",[item safeObjectForKey:@"quantity"]];
            
            NSMutableDictionary * dict = [NSMutableDictionary dictionary];
            [dict safeSetObject:productNo forKey:@"productNo"];
            [dict safeSetObject:quantity forKey:@"quantity"];
            [arr addObject:dict];
        }
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arr options:NSJSONWritingPrettyPrinted error:nil];
    NSString * str =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    DLog(@"仓储上传信息--%@",str);
    return str;
}
#pragma mark ----计算运费
-(NSString *)getufUpdatainfo
{
    //proviceId 省份 products
    NSMutableArray * arr =[NSMutableArray array];
    NSMutableDictionary * products1 =[NSMutableDictionary dictionary];
    NSMutableDictionary * products2 =[NSMutableDictionary dictionary];
    float weight1 =0.0;
    float weight2 = 0.0;

    for (int i=0; i<_dataArray.count; i++) {
        if (self.orderType==IS_FROM_SHOPCART) {
            
            shopCarCellItem * item  =[self.dataArray objectAtIndex:i];
            int freightTemplateId  =[item.freightTemplateId intValue];
            DLog(@"%@",item.freightTemplateId);
            DLog(@"fre--%d",freightTemplateId);
            float weight = [item.productWeight floatValue];
            float giveWeight = 0.0;//赠品重量
            //获取赠品重量
            if (item.promotList.count>0) {
                for (NSDictionary * dic in item.promotList) {
                    if ([[dic safeObjectForKey:@"promotionType"]intValue]==2) {
                        float productWeight = [[dic safeObjectForKey:@"productWeight"]floatValue];
                        int giveQuantity = [[dic safeObjectForKey:@"giveQuantity"]intValue];
                        giveWeight +=productWeight*giveQuantity;
                    }
                }
            }
            
            
            int count = [item.quantity intValue];
            if (freightTemplateId ==0) {
                weight1 +=weight*count;
                weight1 +=giveWeight;
            }else{
                weight2 +=weight * count;
                weight2 +=giveWeight;
            }

        }else if(self.orderType ==IS_FROM_GOODSDETAIL)
        {
            GoodsDetailItem * item = [self.dataArray objectAtIndex:i];
            int freightTemplateId  =[item.freightTemplateId intValue];
            DLog(@"%@",item.freightTemplateId);
            DLog(@"fre--%d",freightTemplateId);
            float weight = [item.productWeight floatValue];
            int count = self.goodsCount;
            
            float giveWeight = 0.0;//赠品重量
            //获取赠品重量
            if (item.promotList.count>0) {
                for (NSDictionary * dic in item.promotList) {
                    if ([[dic safeObjectForKey:@"promotionType"]intValue]==2) {
                        float productWeight = [[dic safeObjectForKey:@"productWeight"]floatValue];
                        int giveQuantity = [[dic safeObjectForKey:@"giveQuantity"]intValue];

                        int maxCount = [[dic safeObjectForKey:@"maxQuantity"]intValue];
                        int minCount = [[dic safeObjectForKey:@"minQuantity"]intValue];
                        if (self.goodsCount>=minCount&&self.goodsCount<maxCount) {
  
                            giveWeight +=productWeight*giveQuantity;
                        }
                        
                    }
                }
            }
            
            if (freightTemplateId ==0) {
                weight1 +=weight*count;
                weight1 +=giveWeight;
            }else{
                weight2 +=weight * count;
                weight2 +=giveWeight;
            }
        }else
        {
            NSDictionary * item = [self.dataArray objectAtIndex:i];
            int freightTemplateId  =[[item safeObjectForKey:@"freightTemplateId"] intValue];
            DLog(@"%@",[item safeObjectForKey:@"freightTemplateId"]);
            DLog(@"fre--%d",freightTemplateId);
            float weight = [[item safeObjectForKey:@"productWeight"] floatValue];
            int count = self.goodsCount;
            
            float giveWeight = 0.0;//赠品重量
            
            NSArray * promotListArr = [item safeObjectForKey:@"promotList"];
            
            //获取赠品重量
            if (promotListArr.count>0) {
                for (NSDictionary * dic in promotListArr) {
                    if ([[dic safeObjectForKey:@"promotionType"]intValue]==2) {
                        float productWeight = [[dic safeObjectForKey:@"productWeight"]floatValue];
                        int giveQuantity = [[dic safeObjectForKey:@"giveQuantity"]intValue];
                        
                        int maxCount = [[dic safeObjectForKey:@"maxQuantity"]intValue];
                        int minCount = [[dic safeObjectForKey:@"minQuantity"]intValue];
                        if (self.goodsCount>=minCount&&self.goodsCount<maxCount) {
                            
                            giveWeight +=productWeight*giveQuantity;
                        }
                        
                    }
                }
            }
            
            if (freightTemplateId ==0) {
                weight1 +=weight*count;
                weight1 +=giveWeight;
                
            }else{
                weight2 +=weight * count;
                weight2 +=giveWeight;
                
            }
        }

        
    }
    [products1 setObject:@(weight1) forKey:@"weight"];
    [products1 setObject:@(0) forKey:@"freightTemplateId"];
    [products2 setObject:@(weight2) forKey:@"weight"];
    [products2 setObject:@(1) forKey:@"freightTemplateId"];
    if (weight1>0) {
        [arr addObject:products1];
    }
    if (weight2>0) {
        [arr addObject:products2];
    }
    
    DLog(@"计算运费参数 arr-%@",arr);
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arr options:NSJSONWritingPrettyPrinted error:nil];
    NSString * str =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

    return str;
}



//-(NSString * )getVoucthersInfo
//{
//
//    NSMutableArray * vouArr = [NSMutableArray array];
//    for (int i =0; i<self.dataArray.count; i++) {
//        if (self.orderType==IS_FROM_SHOPCART) {
//            shopCarCellItem *item = [self.dataArray objectAtIndex:i];
//            NSMutableDictionary * dic = [NSMutableDictionary dictionary];
//            [dic safeSetObject:item.oldPrice forKey:@"productPrice"];
//            [dic safeSetObject:item.productNo forKey:@"productNo"];
//            [dic safeSetObject:item.productName forKey:@"productName"];
//            [dic safeSetObject:item.quantity forKey:@"quantity"];
//            [dic safeSetObject:@([item.productPrice floatValue]*[item.quantity intValue]-[self getPreferentialPriceWithID:item.productNo count:[item.quantity intValue]]) forKey:@"itemTotalPrice"];
//
//            [vouArr addObject:dic];
//        }else if(self.orderType ==IS_FROM_GOODSDETAIL){
//            GoodsDetailItem *item = [self.dataArray objectAtIndex:i];
//            NSMutableDictionary * dic = [NSMutableDictionary dictionary];
//            [dic safeSetObject:item.oldPrice forKey:@"productPrice"];
//            [dic safeSetObject:item.productNo forKey:@"productNo"];
//            [dic safeSetObject:item.productName forKey:@"productName"];
//            [dic safeSetObject:@(self.goodsCount) forKey:@"quantity"];
//            [dic safeSetObject:payableAmountStr forKey:@"itemTotalPrice"];
//            [vouArr addObject:dic];
//
//        }
//    }
//
//
//    return [self DataTOjsonString:vouArr];
//}
-(float)getPreferentialPriceWithID:(NSString *)goodsId count:(int)count
{
    shopCarCellItem *currItem = [[shopCarCellItem alloc]init];
    for (shopCarCellItem *item in _dataArray) {
        if ([item.productNo isEqualToString:goodsId]) {
            currItem =item;
        }
    }
    for (NSDictionary *dict in currItem.promotList) {
        if ([[dict objectForKey:@"promotionType"]intValue]==1) {
            int maxCount = [[dict safeObjectForKey:@"maxQuantity"]intValue];
            int minCount = [[dict safeObjectForKey:@"minQuantity"]intValue];
            float reduceAmount =[[dict safeObjectForKey:@"reduceAmount"]floatValue];
            if (count>=minCount&&count<maxCount) {
                return reduceAmount;
            }
        }
    }
    return 0;
}


-(float)getTruePayAmountPrice:(float)payAmountPrice
{
    float weightPrice = [weightStr floatValue];
    
    if (voucthersDict) {
        float amount = [[voucthersDict safeObjectForKey:@"amount"]floatValue];
        int type = [[voucthersDict safeObjectForKey:@"type"]intValue];
        if (type==4||type==5) {
            if (type==4) {
                return payAmountPrice;

            }else{
                weightPrice = weightPrice-amount>0?weightPrice-amount:0.0;
                return payAmountPrice+weightPrice;
            }
        }
        else
        {
           return payAmountPrice+weightPrice-amount>0?payAmountPrice-amount+weightPrice:0;
        }
    }else{
    return payAmountPrice+weightPrice;
    }
}
-(float)getWeightPrice
{
    float weightPrice = [weightStr floatValue];
    if (voucthersDict) {
        float amount = [[voucthersDict safeObjectForKey:@"amount"]floatValue];
        int type = [[voucthersDict safeObjectForKey:@"type"]intValue];
        
        if (type==4||type==5) {
            if (type==4) {
                return   0.0;
            }else{
                return   weightPrice-amount>0?weightPrice-amount:0.0;
            }
        }
        else
        {
            return weightPrice;
        }
    }else{
        return weightPrice;
    }
}
@end
