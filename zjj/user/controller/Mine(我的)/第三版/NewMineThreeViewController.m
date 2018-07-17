//
//  NewMineThreeViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2018/5/10.
//  Copyright © 2018年 ZhiJiangjun-iOS. All rights reserved.
//

#import "NewMineThreeViewController.h"
#import "EditUserInfoViewController.h"
#import "AddFriendsViewController.h"
#import "IntegralShopViewController.h"
#import "GrowthStstemViewController.h"
#import "GuanZViewController.h"
#import "NewMineHomePageViewController.h"
#import "IntegralOrderViewController.h"
#import "NewMineTableViewCell.h"
#import "CommunityViewController.h"
#import "HomePageViewController.h"
#import "OrderViewController.h"
#import "VouchersGetViewController.h"
#import "InvitationFriendsViewController.h"
#import "SuperiorViewController.h"
#import "RentBalanceViewController.h"
#import "HelpViewController.h"
@interface NewMineThreeViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNamelb;
@property (weak, nonatomic) IBOutlet UILabel *jjlb;
@property (weak, nonatomic) IBOutlet UILabel *gzlb;
@property (weak, nonatomic) IBOutlet UILabel *funslb;
@property (weak, nonatomic) IBOutlet UILabel *integrallb;
@property (weak, nonatomic) IBOutlet UILabel *levelLb;
@property (nonatomic,strong) NSMutableDictionary * infoDict;
@property (weak, nonatomic) IBOutlet UILabel *tzslb;
@property (weak, nonatomic) IBOutlet UILabel *locationlb;
@end

@implementation NewMineThreeViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    self.tabBarController.tabBar.hidden = NO;
    
    [self getUserInfo];
    //    [self getMyMessageCountInfo];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[UserModel shareInstance].headUrl]placeholderImage:getImage(@"head_default")];

    self.nickNamelb.text = [UserModel shareInstance].nickName;
    self.jjlb.text = [UserModel shareInstance].jjStr;
    self.sexImageView.image = [UserModel shareInstance].gender==1?getImage(@"man_"):getImage(@"woman_");
    self.locationlb.text = [UserModel shareInstance].locationStr;
    self.tzslb.text  = [UserModel shareInstance].gradeName;
}
- (IBAction)didSearchFriends:(id)sender {
    AddFriendsViewController * add =[[AddFriendsViewController alloc]init];
    add.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:add animated:YES];
}

-(void)getUserInfo
{
    //    app/user/getUserHome.do
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/user/getUserHome.do" HiddenProgress:NO paramters:params success:^(NSDictionary *dic) {
        
        _infoDict = [dic safeObjectForKey:@"data"];
        DLog(@"%@",dic);
        [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[_infoDict safeObjectForKey:@"headimgurl"]]placeholderImage:getImage(@"head_default")];
        self.nickNamelb.text  = [_infoDict safeObjectForKey:@"nickName"];
        NSString * introduction = [_infoDict safeObjectForKey:@"introduction"];
        if (introduction.length<1) {
            self.jjlb.text = @"您还没有编辑简介~";
        }else{
            self.jjlb.text = [NSString stringWithFormat:@"简介：%@",introduction];
        }
        self.funslb.text  = [_infoDict safeObjectForKey:@"fansNum"];
        self.gzlb.text  = [_infoDict safeObjectForKey:@"followNum"];
        self.integrallb.text  = [_infoDict safeObjectForKey:@"integral"];
        self.sexImageView.image = [[_infoDict safeObjectForKey:@"sex"]isEqualToString:@"1"]?getImage(@"man_"):getImage(@"woman_");
        self.levelLb.text = [NSString stringWithFormat:@"LV%@",[_infoDict safeObjectForKey:@"integralGrade"]];


    } failure:^(NSError *error) {
    }];
    
    
}
- (IBAction)showGzPage:(id)sender {
    GuanZViewController * gz =[[GuanZViewController alloc]init];
    gz.title = @"关注";
    gz.pageType = IS_GZ;
    gz.hidesBottomBarWhenPushed=YES;
    
    [self.navigationController pushViewController:gz animated:YES];

}
- (IBAction)showFunsPage:(id)sender {
    GuanZViewController * gz =[[GuanZViewController alloc]init];
    gz.title = @"粉丝";
    gz.pageType = IS_FUNS;
    gz.hidesBottomBarWhenPushed=YES;
    
    [self.navigationController pushViewController:gz animated:YES];

}
- (IBAction)showIntegralPage:(id)sender {
}

- (IBAction)didEnterEditPage:(id)sender {
    EditUserInfoViewController * ne = [[EditUserInfoViewController alloc]init];
    ne.hidesBottomBarWhenPushed=YES;
    ne.infoDict = self.infoDict;
    [ne.upDataDict safeSetObject:[_infoDict safeObjectForKey:@"nickName"] forKey:@"nickName"];
    [ne.upDataDict safeSetObject:[_infoDict safeObjectForKey:@"sex"] forKey:@"sex"];
    [ne.upDataDict safeSetObject:[_infoDict safeObjectForKey:@"height"] forKey:@"heigth"];
    [ne.upDataDict safeSetObject:[_infoDict safeObjectForKey:@"birthday"] forKey:@"birthday"];
    
    [self.navigationController pushViewController:ne animated:YES];

}
- (IBAction)didEnterNextPage:(UIButton *)sender {
    if(sender.tag==4)
    {
        DLog(@"邀请好友");

        InvitationFriendsViewController * vo = [[InvitationFriendsViewController alloc]init];
        vo.hidesBottomBarWhenPushed=YES;
        //            vo.myType = 5;
        [self.navigationController pushViewController:vo animated:YES];

//        NewMineHomePageViewController * page = [[NewMineHomePageViewController alloc]init];
//        page.hidesBottomBarWhenPushed=YES;
//        page.userId = [UserModel shareInstance].userId;
//        [self.navigationController pushViewController:page animated:YES];
        
    }
    else if(sender.tag ==5)
    {
        DLog(@"纤客订单");
        OrderViewController * ord = [[OrderViewController alloc]init];
        ord.hidesBottomBarWhenPushed=YES;
        ord.getOrderType =IS_ALL;
        [self.navigationController pushViewController:ord animated:YES];

    }
    else if(sender.tag==6)
    {
        DLog(@"纤客商城");
        HomePageViewController * ord = [[HomePageViewController alloc]init];
        ord.hidesBottomBarWhenPushed=YES;
        
        [self.navigationController pushViewController:ord animated:YES];

    }
    else if (sender.tag ==7)
    {
        DLog(@"购买记录");
        SuperiorViewController * sp =[[SuperiorViewController alloc]init];
        sp.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:sp animated:YES];

    }
    else if (sender.tag ==8)
    {
        DLog(@"积分商城");
        IntegralShopViewController * its = [[IntegralShopViewController alloc]init];
        its.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:its animated:YES];

        
    }
    else if (sender.tag ==9)
    {
        DLog(@"积分订单");

        IntegralOrderViewController * ord = [[IntegralOrderViewController alloc]init];
        ord.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:ord animated:YES];

    }
    else if (sender.tag ==10)
    {
    }
    else if (sender.tag ==11)
    {
        DLog(@"成长体系");
        GrowthStstemViewController * gs = [[GrowthStstemViewController alloc]init];
        gs.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:gs animated:YES];

        
//        InvitationFriendsViewController * vo = [[InvitationFriendsViewController alloc]init];
//        vo.hidesBottomBarWhenPushed=YES;
//        //            vo.myType = 5;
//        [self.navigationController pushViewController:vo animated:YES];
        
    }else if (sender.tag ==12){
        
        
        HelpViewController * rent =[[HelpViewController alloc]init];
        rent.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:rent animated:YES];
        
        

    }else if (sender.tag ==13)
    {
        NSURL * url = [NSURL URLWithString:@"Zhijiangjun://"];
        if ([[UIApplication sharedApplication]canOpenURL:url]) {
    
            [[UIApplication sharedApplication]openURL:url options:@{} completionHandler:nil];
        }else{
            [[UIApplication sharedApplication ] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/id1335471147"]];
        }
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
