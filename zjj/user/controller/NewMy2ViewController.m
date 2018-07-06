
//
//  NewMy2ViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2018/4/12.
//  Copyright © 2018年 ZhiJiangjun-iOS. All rights reserved.
//

#import "NewMy2ViewController.h"
#import "AddFriendsViewController.h"
#import "ShopCarViewController.h"
#import "GuanZViewController.h"
#import "IntegralShopViewController.h"
#import "OrderViewController.h"
#import "AddressListViewController.h"
#import "IntegralShopViewController.h"
#import "InvitationFriendsViewController.h"
#import "EditUserInfoViewController.h"
#import "GrowthStstemViewController.h"
#import "NewMineHomePageViewController.h"
#import "CommunityViewController.h"
#import "SuperiorViewController.h"
#import "AllOrderViewController.h"
@interface NewMy2ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *headBtn;
@property (weak, nonatomic) IBOutlet UILabel *nickNamelb;
@property (weak, nonatomic) IBOutlet UILabel *levellb;
@property (weak, nonatomic) IBOutlet UILabel *jjlb;
@property (weak, nonatomic) IBOutlet UILabel *gzCountlb;
@property (weak, nonatomic) IBOutlet UILabel *funsCountlb;
@property (weak, nonatomic) IBOutlet UILabel *integrallb;
@property (nonatomic,strong)NSMutableDictionary * infoDict;

@end

@implementation NewMy2ViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    self.tabBarController.tabBar.hidden = NO;
    
    [self setTBWhiteColor];
    [self getUserInfo];
//    [self getMyMessageCountInfo];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _infoDict = [NSMutableDictionary dictionary];
    [self.headBtn sd_setImageWithURL:[NSURL URLWithString:[UserModel shareInstance].headUrl] forState:UIControlStateNormal];
    self.nickNamelb.text = [UserModel shareInstance].nickName;
    self.jjlb.text = [UserModel shareInstance].jjStr;
    [self getUserInfo];
}

-(void)getUserInfo
{
    //    app/user/getUserHome.do
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/user/getUserHome.do" HiddenProgress:NO paramters:params success:^(NSDictionary *dic) {
        
        _infoDict = [dic safeObjectForKey:@"data"];
        //        [self.tableview reloadData];
        DLog(@"%@",dic);
        [self.headBtn sd_setImageWithURL:[NSURL URLWithString:[_infoDict safeObjectForKey:@"headimgurl"]] forState:UIControlStateNormal];
        self.nickNamelb.text = [_infoDict safeObjectForKey:@"nickName"];
        self.jjlb.text = [_infoDict safeObjectForKey:@"introduction"];
        self.funsCountlb.text  = [_infoDict safeObjectForKey:@"fansNum"];
        self.gzCountlb.text  = [_infoDict safeObjectForKey:@"followNum"];
        self.integrallb.text  = [_infoDict safeObjectForKey:@"integral"];

    } failure:^(NSError *error) {
    }];
    
    
}

- (IBAction)enterMyInfoPage:(id)sender {
    NewMineHomePageViewController * ne = [[NewMineHomePageViewController alloc]init];
    ne.hidesBottomBarWhenPushed=YES;
    ne.userId = [UserModel shareInstance].userId;
    
//    ne.infoDict = self.infoDict;
//    [ne.upDataDict safeSetObject:[_infoDict safeObjectForKey:@"nickName"] forKey:@"nickName"];
//    [ne.upDataDict safeSetObject:[_infoDict safeObjectForKey:@"sex"] forKey:@"sex"];
//    [ne.upDataDict safeSetObject:[_infoDict safeObjectForKey:@"height"] forKey:@"heigth"];
//    [ne.upDataDict safeSetObject:[_infoDict safeObjectForKey:@"birthday"] forKey:@"birthday"];
    
    [self.navigationController pushViewController:ne animated:YES];

}
- (IBAction)didAddFriends:(id)sender {
    AddFriendsViewController * addf = [[AddFriendsViewController alloc]init];
    addf.hidesBottomBarWhenPushed=YES;
    
    [self.navigationController pushViewController:addf animated:YES];

}
- (IBAction)didEnterNotiPage:(id)sender {
}
- (IBAction)enterGzPage:(id)sender {
    GuanZViewController * gz =[[GuanZViewController alloc]init];
    gz.title = @"关注";
    gz.pageType = IS_GZ;
    gz.hidesBottomBarWhenPushed=YES;
    
    [self.navigationController pushViewController:gz animated:YES];

}
- (IBAction)enterFunsPage:(id)sender {
    GuanZViewController * gz =[[GuanZViewController alloc]init];
    gz.title = @"粉丝";
    gz.pageType = IS_FUNS;
    gz.hidesBottomBarWhenPushed=YES;
    
    [self.navigationController pushViewController:gz animated:YES];

}
- (IBAction)enterIntegralPage:(id)sender {
}
- (IBAction)enterAddressPage:(id)sender {
    DLog(@"地址");
    AddressListViewController * ord = [[AddressListViewController alloc]init];
    ord.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:ord animated:YES];

}
- (IBAction)enterShopCarPage:(id)sender {
    DLog(@"纤客购物车");
    ShopCarViewController * ord = [[ShopCarViewController alloc]init];
    ord.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:ord animated:YES];

}
- (IBAction)enterOrderPage:(id)sender {
    DLog(@"纤客订单");
    AllOrderViewController * ord = [[AllOrderViewController alloc]init];
    ord.hidesBottomBarWhenPushed=YES;
//    ord.getOrderType =IS_ALL;
    [self.navigationController pushViewController:ord animated:YES];

}
- (IBAction)enterIntegralTaskPage:(id)sender {
    DLog(@"成长体系");
    GrowthStstemViewController * gs = [[GrowthStstemViewController alloc]init];
    gs.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:gs animated:YES];

}
- (IBAction)enterIntegralShopPage:(id)sender {
    DLog(@"积分商城");
    IntegralShopViewController * its = [[IntegralShopViewController alloc]init];
    its.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:its animated:YES];

}
- (IBAction)enterUpPage:(id)sender {
    SuperiorViewController * sp =[[SuperiorViewController alloc]init];
    sp.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:sp animated:YES];

}
- (IBAction)enterInvitationPage:(id)sender {
    DLog(@"邀请好友");
    
    InvitationFriendsViewController * vo = [[InvitationFriendsViewController alloc]init];
    vo.hidesBottomBarWhenPushed=YES;
    //            vo.myType = 5;
    [self.navigationController pushViewController:vo animated:YES];

}
- (IBAction)enterEditPage:(id)sender {
    EditUserInfoViewController * ne = [[EditUserInfoViewController alloc]init];
    ne.hidesBottomBarWhenPushed=YES;
    ne.infoDict = self.infoDict;
    [ne.upDataDict safeSetObject:[_infoDict safeObjectForKey:@"nickName"] forKey:@"nickName"];
    [ne.upDataDict safeSetObject:[_infoDict safeObjectForKey:@"sex"] forKey:@"sex"];
    [ne.upDataDict safeSetObject:[_infoDict safeObjectForKey:@"height"] forKey:@"heigth"];
    [ne.upDataDict safeSetObject:[_infoDict safeObjectForKey:@"birthday"] forKey:@"birthday"];
    
    [self.navigationController pushViewController:ne animated:YES];

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
