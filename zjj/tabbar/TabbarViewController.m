//
//  TabbarViewController.m
//  zhijiangjun
//
//  Created by iOSdeveloper on 2017/6/11.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "TabbarViewController.h"
//#import "HealthViewController.h"
#import "MessageViewController.h"
#import "foundViewController.h"
#import "YFWViewController.h"
#import "JzSchoolViewController.h"
#import "HomePageWebViewController.h"
#import "FriendsCircleViewController.h"
#import "AppDelegate.h"
#import "NewMineViewController.h"
#import "CommunityViewController.h"
#import "NewHealthViewController.h"
#import "GrowthStstemViewController.h"
#import "HomePageViewController.h"
#import "NewMy2ViewController.h"
#import "NewMineThreeViewController.h"
@interface TabbarViewController ()<UITabBarControllerDelegate>

@end

@implementation TabbarViewController
{
//    HealthViewController *health;
    NewHealthViewController *health;
    MessageViewController *news;
    foundViewController * found;
    UITabBarItem * item2;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    self.delegate = self;
    
    health = [[NewHealthViewController alloc]init];
    
    //    health = [[HealthViewController alloc]init];
    UINavigationController * nav1 = [[UINavigationController alloc]initWithRootViewController:health];
    health.title = @"健康";
    
    
    MessageViewController * message = [[MessageViewController alloc]init];
    UINavigationController * nav2 = [[UINavigationController alloc]initWithRootViewController:message];
    message.title = @"消息";

    
    
    CommunityViewController *found = [[CommunityViewController alloc]init];
    UINavigationController * nav3 = [[UINavigationController alloc]initWithRootViewController:found];
    found.title = @"社群";
//    HomePageViewController *home = [[HomePageViewController alloc]init];
//    UINavigationController * nav3 = [[UINavigationController alloc]initWithRootViewController:home];
//    home.title = @"商城";

    
    
    NewMineThreeViewController * user = [[NewMineThreeViewController alloc]init];
    UINavigationController * nav4 = [[UINavigationController alloc]initWithRootViewController:user];
    user.title = @"我的";
    
    self.viewControllers = @[nav1,nav2,nav3,nav4];
    
    
    UITabBarItem * item1 =[self.tabBar.items objectAtIndex:0];
    item2 =[self.tabBar.items objectAtIndex:1];
    UITabBarItem * item3 =[self.tabBar.items objectAtIndex:2];
    UITabBarItem * item4 =[self.tabBar.items objectAtIndex:3];
    
    item1.image = [UIImage imageNamed:@"health  gray_"];
    item1.selectedImage = [UIImage imageNamed:@"health_"];
    
    

    item2.image = [UIImage imageNamed:@"tab_message_"];
    //    item3.selectedImage = [UIImage imageNamed:@"tab_comm1_"];
    
    item3.image = [UIImage imageNamed:@"tab_comm_"];
//    item3.selectedImage = [UIImage imageNamed:@"discuss_"];

    item4.image = [UIImage imageNamed:@"mine  gray_"];
    item4.selectedImage = [UIImage imageNamed:@"mine_"];
    self.tabBar.backgroundColor = [UIColor whiteColor];
    self.tabBar.tintColor = HEXCOLOR(0xfb0628);

    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didClickNotification:) name:@"GETNOTIFICATIONINFOS" object:nil];
    

    

    
    
    [self getNotiInfo];
}






-(void)didClickNotification:(NSNotification *)noti
{
    //判断是不是mainview
    if (![(AppDelegate *)[UIApplication sharedApplication].delegate.window.rootViewController isKindOfClass:[self class]]) {
        return;
    }
    NSDictionary * dic=noti.userInfo;
    int type =[[dic safeObjectForKey:@"type"]intValue];
    NSString * url = [dic safeObjectForKey:@"url"];
    
    if (type ==1) {
        self.selectedIndex = 1;
        HomePageWebViewController * web= [[HomePageWebViewController alloc]init];
        web.urlStr = url;
        web.title = @"消息详情";
        web.hidesBottomBarWhenPushed = YES;
        [news.navigationController pushViewController:web animated:YES];
    }
    else if (type ==2)
    {
        self.selectedIndex =2;
        FriendsCircleViewController * fr = [[FriendsCircleViewController alloc]init];
        fr.hidesBottomBarWhenPushed = YES;
        [found.navigationController pushViewController:fr animated:YES];
    }
}
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    UITabBarItem* item = tabBarController.tabBarItem;
    
    if (viewController ==self.viewControllers[3]) {
        if (![[UserModel shareInstance].subId isEqualToString:[UserModel shareInstance].healthId]) {
            [[UserModel shareInstance]showInfoWithStatus:@"请切换成主用户再来使用此功能"];
            return NO;
        }else{
            return YES;
        }
    }
    if (viewController ==self.viewControllers[1]) {
        item2.badgeValue = nil;
    }
    return YES;

}


#pragma mark ---获取消息数量
-(void)getNotiInfo
{
   // http: //test234.i851.com/app/community/articlepage/queryMsgDynamic.do
    NSMutableDictionary * params =[NSMutableDictionary dictionary];
    [params safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
    [[BaseSservice sharedManager]post1:@"app/community/articlepage/queryMsgDynamic.do" HiddenProgress:YES paramters:params success:^(NSDictionary *dic) {
        NSDictionary * dataDict =[dic safeObjectForKey:@"data"];
        NSString * lastMsgTime = [dataDict safeObjectForKey:@"lastMsgTime"];
        NSString * defTimes =[[NSUserDefaults standardUserDefaults]objectForKey:@"NotiMessageTimes"];
        
        if (defTimes&&defTimes.length>0) {
            if ([defTimes isEqualToString:lastMsgTime]) {
                item2.badgeValue = nil;
                return ;
            }
            item2.badgeValue = @"";
        }
        {
            item2.badgeValue = @"";

        }
        [[NSUserDefaults standardUserDefaults]setValue:lastMsgTime forKey:@"NotiMessageTimes"];

    } failure:^(NSError *error) {
        item2.badgeValue = nil;

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
