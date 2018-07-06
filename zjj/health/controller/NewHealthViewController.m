//
//  NewHealthViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/10/12.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "NewHealthViewController.h"
#import "LoignViewController.h"
#import "UserCellCell.h"
#import "UserListView.h"
#import "ShareViewController.h"
#import "HealthModel.h"
#import "JPUSHService.h"
#import "ADDChengUserViewController.h"
#import "UserDirectionsViewController.h"
#import "HistoryInfoViewController.h"
#import "HealthDetailViewController.h"
#import "WeighingViewController.h"
#import "HistoryTotalViewController.h"
#import "NewHealthCell.h"
#import "HealthMainCell.h"
#import "GrowthStstemViewController.h"
#import "HomePageWebViewController.h"
#import "IntegralSignInView.h"
#import "AdvertisingView.h"
#import "HealthBtnCell.h"
#import "SXSRulerControl.h"
#import "WaBaoViewController.h"
#import "NewRentBlanceViewController.h"

@interface NewHealthViewController ()<userListDelegate,weightingDelegate,UITableViewDelegate,UITableViewDataSource,newHealthCellDelegate,HealthBtnCellDelegate>
@property (nonatomic,strong)UIView * userBackView;
@property (nonatomic,strong)UserListView * userListView;

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIView *targetWeightView;
@property (weak, nonatomic) IBOutlet UIView *ruleBgView;
@property (weak, nonatomic) IBOutlet UILabel *rulelb;


@end

@implementation NewHealthViewController
{
    NSMutableArray * headerArr;
    BOOL isrefresh;
    BOOL enterDetailPage;///称重完成后进去详情页面
    UIView * bgView;
    AdvertisingView * adv;
    NSString * adLinkUrl;
    SXSRulerControl * _ruler;

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    self.tabBarController.tabBar.hidden = NO;
    [self refreshMyInfoView];
    
    [[UserModel shareInstance]getUpdateInfo];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pushIntegralPage) name:@"QDSuccess" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didShowAdUrlpage:) name:@"kShowAdcPage" object:nil];
     
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bg_navbar.png"] forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
    headerArr = [NSMutableArray array];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    [self buildUserListView];
    [self buildRuleView];
    [[UserModel shareInstance]getbalance];

    
    
    
//    [self.tableview addHeaderWithTarget:self action:@selector(headerRereshing)];
//    self.tableview.headerPullToRefreshText = @"下拉可以刷新了";
//    self.tableview.headerReleaseToRefreshText = @"松开马上刷新了";
//    self.tableview.headerRefreshingText = @"刷新中..";
    self.tableview.separatorStyle =UITableViewCellSeparatorStyleNone;

    [self setJpush];
    //删除评测数据返回后刷新
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshPcInfo) name:@"deletePCINFO" object:nil];
    [self getHeaderInfo];
//    [self buildProgressView];
    [self getIntegralInfo];
    //广告
    [self showAd];
}
-(void)headerRereshing
{
    [self getHeaderInfo];
}
#pragma mark -----
-(void)setJpush
{
    [JPUSHService setTags:nil alias:[UserModel shareInstance].userId fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
        DLog(@"设置jpush用户id为%@--是否成功-%d",[UserModel shareInstance].userId,iResCode);
        if (iResCode!=0) {
            [self setJpush];
        }
    }];
    
}
-(void)buildUserListView
{
    self.userListView = [[UserListView alloc]initWithFrame:CGRectMake(0, 20, JFA_SCREEN_WIDTH, self.view.frame.size.height-20)];
    self.userListView.backgroundColor =RGBACOLOR(0/225.0f, 0/225.0f, 0/225.0f, .3);
    self.userListView.hidden = YES;
    self.userListView.delegate = self;
    
    [self.view addSubview:self.userListView];
    
}
-(void)weightingSuccessWithSubtractMaxWeight:(NSString *)subtractMaxWeight dataId:(NSString *)dataId shareDict:(NSDictionary *)shareDict
{
    [self getHeaderInfo];
    HealthDetailViewController * hd =[[HealthDetailViewController alloc]init];
    hd.hidesBottomBarWhenPushed=YES;
    hd.subtractMaxWeight = subtractMaxWeight;
    hd.dataId =dataId;
    hd.shareDict = [NSMutableDictionary dictionaryWithDictionary:shareDict];
    [self.navigationController pushViewController:hd animated:YES];

}
-(void)getHeaderInfo
{
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param safeSetObject:[UserModel shareInstance].subId forKey:@"subUserId"];
    
    self.currentTasks = [[BaseSservice sharedManager]post1:kuHeaderserReviewUrl HiddenProgress:NO paramters:param success:^(NSDictionary *dic) {
        [self.tableview.mj_header endRefreshing];
        
        [headerArr removeAllObjects];
        HealthItem *item =[[HealthItem alloc]init];
        [item setobjectWithDic:[dic objectForKey:@"data"]];
        [headerArr addObject:item];
        [self.tableview reloadData];;
        
    } failure:^(NSError *error) {
        if (error.code ==402) {
            [headerArr removeAllObjects];
        }
        [self.tableview reloadData];
        [self.tableview.mj_header endRefreshing];

        
    }];
}

-(void)buildRuleView
{
    
    _ruler = [SXSRulerControl new];
    _ruler.frame = CGRectMake(0, 0, JFA_SCREEN_WIDTH-60, 60);
    _ruler.midCount=1;//几个大格标记一个刻度
    _ruler.smallCount=5;//一个大格几个小格
    _ruler.valueStep = 5;// 两个标记刻度之间相差大小
    _ruler.minorScaleSpacing = 10;
    _ruler.minValue = 30;// 最小值
    _ruler.maxValue = 200;// 最大值
    HealthItem * item = headerArr&&headerArr.count>0?headerArr[0]:nil ;
    
    _ruler.selectedValue = item.targetWeight;// 设置默认值
    [self.ruleBgView addSubview:_ruler];
    [_ruler addTarget:self action:@selector(selectedValueChanged:) forControlEvents:UIControlEventValueChanged]; // 添加监听方法

}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
//        return 348;
        return JFA_SCREEN_HEIGHT>560?JFA_SCREEN_HEIGHT:560;
    }
    return 241;
//    return JFA_SCREEN_HEIGHT>560?JFA_SCREEN_HEIGHT:560;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row ==0) {
        
        static NSString * identifier = @"HealthMainCell";
        
        HealthMainCell * cell = [self.tableview dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [self getXibCellWithTitle:identifier];
        }
        cell.delegate = self;
        if (headerArr&&headerArr.count>0) {
            HealthItem * item  = headerArr&&headerArr.count>0?headerArr[0]:nil;
            [cell refreshPageInfoWithItem:item];
        }else{
            [cell refreshPageInfoWithItem:nil];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;


    }else{
        static NSString * identifier = @"HealthBtnCell";
        
        HealthBtnCell * cell = [self.tableview dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [self getXibCellWithTitle:identifier];
        }
        cell.delegate = self;
        cell.targetWeightlb.adjustsFontSizeToFitWidth = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (headerArr&&headerArr.count>0) {
            HealthItem * item  = headerArr&&headerArr.count>0?headerArr[0]:nil;

            cell.targetWeightlb.text =[NSString  stringWithFormat:@"%.1f斤",item.targetWeight];
        }else{
            cell.targetWeightlb.text = [NSString  stringWithFormat:@"0斤"];
        }
        return cell;

    }
}

#pragma mark ---↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑


-(void)refreshMyInfoView
{
    [self.tableview reloadData];
}

-(void)refreshPcInfo
{
    [self getHeaderInfo];
}
#pragma mark ---show subviewdelegate
-(void)changeShowUserWithSubId:(NSString *)subId isAdd:(BOOL)isAdd
{
    if (isAdd) {
        
        ADDChengUserViewController * addc = [[ADDChengUserViewController alloc]init];
        addc.isResignUser = NO;
        addc.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:addc animated:YES];
        
    }else{
        
        if ([subId isEqualToString:[UserModel shareInstance].subId]) {
            [[SubUserItem shareInstance]setInfoWithHealthId:subId];
            [[UserModel shareInstance]setHealthidWithId:subId];

            [self refreshMyInfoView];
            self.userListView.hidden = YES;
            return;
        }
        [[SubUserItem shareInstance]setInfoWithHealthId:subId];
        [[UserModel shareInstance]setHealthidWithId:subId];
        [self reloadAll];
    }
    self.userListView.hidden = YES;
}


-(void)reloadAll
{
    [self getHeaderInfo];
}


#pragma  mark ----cell delegate


-(void)didShowUserList
{
    if (self.userListView.hidden ==YES) {
        self.userListView.hidden = NO;
        [self.view bringSubviewToFront:self.userListView];
        [self.userListView refreshInfo];
    }else{
        self.userListView.hidden = YES;
    }

}
-(void)didShowSHuoming
{
    UserDirectionsViewController * dis = [[UserDirectionsViewController alloc]init];
    dis.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:dis animated:YES];

}
-(void)didWeighting
{
    WeighingViewController * we = [[WeighingViewController alloc]init];
    we.delegate = self;
    we.currItem = headerArr&&headerArr.count>0?headerArr[0]:nil;
    [self presentViewController:we animated:YES completion:nil];

}
-(void)didEnterDetailVC
{
    if (!headerArr||headerArr.count<1) {
        [[UserModel shareInstance]showInfoWithStatus:@"暂无数据"];
        return;
    }
    HealthItem * item = [headerArr objectAtIndex:0];
    
    HealthDetailViewController * hd =[[HealthDetailViewController alloc]init];
    hd.hidesBottomBarWhenPushed=YES;
    hd.dataId =[NSString stringWithFormat:@"%d",item.DataId];
    
    [self.navigationController pushViewController:hd animated:YES];

}
-(void)didEnterRightVC
{
    HistoryTotalViewController * hist = [[HistoryTotalViewController alloc]init];
    hist.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController: hist animated:YES];
}

-(void)buildProgressView
{
    bgView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, JFA_SCREEN_WIDTH, JFA_SCREEN_HEIGHT)];
    bgView.backgroundColor = RGBACOLOR(0, 0, 0, 0.5);
    
    UIButton * button =[[UIButton alloc]initWithFrame:CGRectMake(30, 100, JFA_SCREEN_WIDTH-60,(JFA_SCREEN_WIDTH-60)/0.875)];
    [button setBackgroundImage:getImage(@"noti_down_app_") forState:UIControlStateNormal];
    [button addTarget:self action:@selector(didDownLoadApp) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:button];
    
    UIButton * closeBtn =[[UIButton alloc]initWithFrame:CGRectMake(JFA_SCREEN_WIDTH/2-25, (JFA_SCREEN_WIDTH-60)/0.875+120, 50,50)];
    [closeBtn setImage: getImage(@"close_whte_") forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(hiddenMe) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:closeBtn];
    
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    
    [window addSubview:bgView];
    
}

-(void)didDownLoadApp
{
    bgView.hidden = YES;
    [bgView removeFromSuperview];
    
    [[UIApplication sharedApplication ] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/id1335471147"]];
    
}
-(void)hiddenMe
{
    bgView.hidden = YES;
    [bgView removeFromSuperview];
}
///获取积分信息---拿出来是否签到参数 循环ing
-(void)getIntegralInfo
{
    if ([[UserModel shareInstance]getSignInNotifacationStatus]==NO) {
        return;
    }
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
    [[BaseSservice sharedManager]post1:@"app/integral/growthsystem/queryAll.do" HiddenProgress:NO paramters:params success:^(NSDictionary *dic) {
        NSMutableDictionary * infoDict = [dic objectForKey:@"data"];
        NSArray * qdArr = [infoDict safeObjectForKey:@"taskArry"];
        NSDictionary * signInDict = [NSDictionary dictionary];
        for (NSDictionary *QDdict in qdArr) {
            NSString * taskName = [QDdict safeObjectForKey:@"taskName"];
            if ([taskName isEqualToString:@"签到"]) {
                signInDict = QDdict;
            }
        }
        //如果签到成功 直接过 滚蛋ing---否则弹出签到框
        if ([[signInDict allKeys]containsObject:@"success"]) {
            return ;
        }
        [self showSignInView];
    } failure:^(NSError *error) {
        
    }];
}


///显示弹框 然后请求接口
-(void)showSignInView
{
    if ([UserModel shareInstance].isUpdate ==YES) {
        return;
    }
    IntegralSignInView  * signView = [[[NSBundle mainBundle]loadNibNamed:@"IntegralSignInView" owner:nil options:nil]lastObject];
    signView.frame = CGRectMake(0, 0, JFA_SCREEN_WIDTH, JFA_SCREEN_HEIGHT);
    [self.view addSubview:signView];
    [self.view bringSubviewToFront:adv];
    
    
}
//显示广告
-(void)showAd
{
    
    [[BaseSservice sharedManager]post1:@"app/notify/queryNotifyInfo.do" HiddenProgress:NO paramters:nil success:^(NSDictionary *dic) {
        DLog(@"url--%@  dic--%@",@"app/notify/queryNotifyInfo.do",dic);
        
        NSDictionary * dataDict = [dic safeObjectForKey:@"data"];
        NSArray * arr = [dataDict safeObjectForKey:@"array"];
        if (arr.count<1) {
            return ;
        }
        if ([UserModel shareInstance].isUpdate ==YES) {
            return;
        }
        
        NSMutableDictionary * adDict = arr[0];
        NSString * imageUrl = [adDict safeObjectForKey:@"imgUrl"];
        adLinkUrl = [adDict safeObjectForKey:@"linkUrl"];
        adv = [[[NSBundle mainBundle]loadNibNamed:@"AdvertisingView" owner:nil options:nil]lastObject];
        adv.frame = self.view.bounds;
        adv.infoDict =[NSDictionary dictionaryWithDictionary:adDict];
        [self.view addSubview:adv];
        [self.view bringSubviewToFront:adv];
        [adv setImageWithUrl:imageUrl];
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        DLog(@"error--%@",error);
    }];
    
}

-(void)pushIntegralPage
{
    GrowthStstemViewController * growth = [[GrowthStstemViewController alloc]init];
    growth.isShowQDProgress = YES;
    growth.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:growth animated:YES];
}
-(void)didShowAdUrlpage:(NSNotification *)noti
{
    
    HomePageWebViewController * page =[[HomePageWebViewController alloc]init];
    page.urlStr = [noti.userInfo safeObjectForKey:@"linkUrl"];
    page.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:page animated:YES];
}
-(void)didTapOne
{
    self.targetWeightView.hidden = NO;
}
-(void)didTapTwo
{
    HistoryTotalViewController * hist = [[HistoryTotalViewController alloc]init];
    hist.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController: hist animated:YES];

}
-(void)didTapThree
{
    
}
-(void)didTapFour
{
    HealthItem * item = [headerArr objectAtIndex:0];
    HealthDetailViewController * hd =[[HealthDetailViewController alloc]init];
    hd.hidesBottomBarWhenPushed=YES;
    hd.dataId =[NSString stringWithFormat:@"%d",item.DataId];
    
    [self.navigationController pushViewController:hd animated:YES];

}
-(void)didTapFive
{
    WeighingViewController * we = [[WeighingViewController alloc]init];
    we.delegate = self;
    we.currItem = headerArr&&headerArr.count>0?headerArr[0]:nil;
    [self presentViewController:we animated:YES completion:nil];

}
-(void)didTapSix
{
    NewRentBlanceViewController * wb =[[NewRentBlanceViewController alloc]init];
    wb.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:wb animated:YES];
}
- (IBAction)didClickChangeTargetWeight:(id)sender {
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param safeSetObject:[UserModel shareInstance].subId forKey:@"subUserId"];
    [param safeSetObject:@(_ruler.selectedValue) forKey:@"targetWeight"];
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/evaluatUser/updateTargetWeight.do" HiddenProgress:NO paramters:param success:^(NSDictionary *dic) {
        if (headerArr.count>0) {
            HealthItem * item = [headerArr objectAtIndex:0];
            item.targetWeight = _ruler.selectedValue;
            self.targetWeightView.hidden = YES;
            [[UserModel shareInstance]showSuccessWithStatus:@"修改成功"];
            [self.tableview reloadData];
        }

    } failure:^(NSError *error) {
        
    }];

}
-(void)showWaBaoVC
{
    [self didTapSix];
}


- (IBAction)cancelChangeTargetWeight:(id)sender {
    self.targetWeightView.hidden = YES;
}
- (void)selectedValueChanged:(SXSRulerControl *)ruler {
    self.rulelb.text = [NSString stringWithFormat:@"%.1fkg",ruler.selectedValue];

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
