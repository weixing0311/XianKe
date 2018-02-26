//
//  NewMineViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/9/19.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "NewMineViewController.h"
#import "NewMineHeaderCell.h"
#import "NewMineRelationsCell.h"
#import "PublicCell.h"
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
#import "NewMy1Cell.h"
#import "NewMy2Cell.h"
//#import "Yd1View.h"
//#import "Yd2View.h"
//#import "Yd3View.h"
//#import "Yd4View.h"
//#import "Yd5View.h"
//#import "Yd6View.h"
#import "SuperiorViewController.h"

@interface NewMineViewController ()<UITableViewDelegate,UITableViewDataSource,mineRelationsCellDelegate,mineRelationsCellDelegate,UICollectionViewDelegate,UICollectionViewDataSource,NewMy1CellDelegate>
@property (nonatomic,strong)NSMutableDictionary * infoDict;
@end

@implementation NewMineViewController
{
    int notifacationCount;
    NSArray * titleArray;
#pragma mark ---guide
//    Yd1View * yd1 ;
//    Yd2View * yd2 ;
//    Yd3View * yd3 ;
//    Yd4View * yd4 ;
//    Yd5View * yd5 ;
//    Yd5View * yd6 ;

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    self.tabBarController.tabBar.hidden = NO;

    [self setTBWhiteColor];
    [self getUserInfo];
    [self getMyMessageCountInfo];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的";
;
    
    [self setNavi];
    
//    [self buildGuidePage];
    _infoDict = [NSMutableDictionary dictionary];
    
//    self.tableview.delegate = self;
//    self.tableview.dataSource = self;
//    self.tableview.separatorColor = HEXCOLOR(0xeeeeee);
//    self.tableview.backgroundColor = HEXCOLOR(0xeeeeee);
//    [self setExtraCellLineHiddenWithTb:self.tableview];
    
    titleArray =@[@"个人中心",@"成长体系",@"积分商城",@"我的订单",@"我的推荐人",@"纤客商城",@"纤客订单"];
    
    
    self.collectionView.delegate = self;
    self.collectionView.alwaysBounceVertical = YES;//实现代理
    self.collectionView.dataSource = self;                  //实现数据源方法
    self.collectionView.backgroundColor= [UIColor whiteColor ];
    self.collectionView.allowsMultipleSelection = YES;      //实现多选，默认是NO
    self.collectionView.frame = CGRectMake(0, 0, JFA_SCREEN_WIDTH, self.view.frame.size.height-self.tabBarController.tabBar.frame.size.height);
    [self.view addSubview:self.collectionView];
    
    
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"NewMy1Cell"bundle:nil]forCellWithReuseIdentifier:@"NewMy1Cell"];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"NewMy2Cell"bundle:nil]forCellWithReuseIdentifier:@"NewMy2Cell"];

    
    
//    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headView"];

    
    
    // Do any additional setup after loading the view from its nib.
}

-(void)setNavi
{
    UIBarButtonItem * leftItem =[[UIBarButtonItem alloc]initWithTitle:@"添加关注" style:UIBarButtonItemStylePlain target:self action:@selector(addFriends)];
    
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"home_edit_"] style:UIBarButtonItemStylePlain target:self action:@selector(didClickEidt)];
    
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
}

-(void)getUserInfo
{
    //    app/user/getUserHome.do
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/user/getUserHome.do" HiddenProgress:NO paramters:params success:^(NSDictionary *dic) {
        
        _infoDict = [dic safeObjectForKey:@"data"];
        //        [self.tableview reloadData];
        [self.collectionView reloadData];
        DLog(@"%@",dic);
    } failure:^(NSError *error) {
    }];
    
    
}
-(void)getMyMessageCountInfo
{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
    
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/community/articlepage/queryMsgDynamic.do" HiddenProgress:NO paramters:params success:^(NSDictionary *dic) {
        
        NSString * dynamicTimes = [[dic safeObjectForKey:@"data"]safeObjectForKey:@"dynamicTimes"];
        notifacationCount = [dynamicTimes intValue];
        [self.tableview reloadData];
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark ---collectionView Delegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section ==0) {
        return 1;
    }
    else{
        return titleArray.count;
    }
}
////定义每个Section的四边间距

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (section ==0) {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return UIEdgeInsetsMake(10, 20, 10, 20);//分别为上、左、下、右
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0) {
        NewMy1Cell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NewMy1Cell" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
        cell.delegate = self;
        [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:[_infoDict safeObjectForKey:@"headimgurl"]]placeholderImage:getImage(@"head_default")];
        cell.namelb.text  = [_infoDict safeObjectForKey:@"nickName"];
        NSString * introduction = [_infoDict safeObjectForKey:@"introduction"];
        if (introduction.length<1) {
            cell.jjlb.text = @"您还没有编辑简介~";
        }else{
            cell.jjlb.text = [NSString stringWithFormat:@"简介：%@",introduction];
        }
        cell.gzCountlb.text = [_infoDict safeObjectForKey:@"followNum"];
        cell.funsCountlb.text = [_infoDict safeObjectForKey:@"fansNum"];

        return cell;
    }else{
        NewMy2Cell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NewMy2Cell" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
        cell.titlelb.text = titleArray[indexPath.row];
        NSString * img = [NSString stringWithFormat:@"home_%ld_",indexPath.row+1];
        cell.headImageView.image = getImage(img);
        if ((notifacationCount==0||!notifacationCount)||indexPath.row !=1) {
            cell.notifationCountLb.hidden = YES;
        }else{
            cell.notifationCountLb.hidden = NO;
        }
        cell.notifationCountLb.text =[NSString stringWithFormat:@"%d",notifacationCount];
        return cell;
    }
}

//设置item大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0) {
        return CGSizeMake(JFA_SCREEN_WIDTH, JFA_SCREEN_WIDTH*0.50);
    }else{
        return CGSizeMake((JFA_SCREEN_WIDTH-40)/3-10, (JFA_SCREEN_WIDTH-20)/3-10);
    }
}
//这个是两行cell之间的间距（上下行cell的间距）

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}
//两个cell之间的间距（同一行的cell的间距）

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (indexPath.section ==1) {
        if(indexPath.row ==0)
        {
            NewMineHomePageViewController * page = [[NewMineHomePageViewController alloc]init];
            page.hidesBottomBarWhenPushed=YES;
            page.userId = [UserModel shareInstance].userId;
            [self.navigationController pushViewController:page animated:YES];
            
        }
        else if(indexPath.row ==1)
        {
            DLog(@"成长体系");
            GrowthStstemViewController * gs = [[GrowthStstemViewController alloc]init];
            gs.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:gs animated:YES];

        }
        else if(indexPath.row==2)
        {
            DLog(@"积分商城");
            IntegralShopViewController * its = [[IntegralShopViewController alloc]init];
            its.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:its animated:YES];
        }
        else if (indexPath.row ==3)
        {
            DLog(@"购买记录");
            IntegralOrderViewController * ord = [[IntegralOrderViewController alloc]init];
            ord.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:ord animated:YES];
        }
        else if (indexPath.row ==4)
        {
            SuperiorViewController * sp =[[SuperiorViewController alloc]init];
            sp.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:sp animated:YES];
            
        }
        else if (indexPath.row ==5)
        {
            DLog(@"纤客商城");
            HomePageViewController * ord = [[HomePageViewController alloc]init];
            ord.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:ord animated:YES];
        }
        else if (indexPath.row ==6)
        {
            DLog(@"纤客订单");
            OrderViewController * ord = [[OrderViewController alloc]init];
            ord.hidesBottomBarWhenPushed=YES;
            ord.getOrderType =IS_ALL;
            [self.navigationController pushViewController:ord animated:YES];
        }
        else if (indexPath.row ==7)
        {
            VouchersGetViewController * vo = [[VouchersGetViewController alloc]init];
            vo.hidesBottomBarWhenPushed=YES;
            vo.myType = 5;
            [self.navigationController pushViewController:vo animated:YES];
            
        }

        
    }
    
}
- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    NewMy2Cell *cell = (NewMy2Cell*)[collectionView cellForItemAtIndexPath:indexPath];
    [cell setBackgroundColor:HEXCOLOR(0xeeeeee)];

}


- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    NewMy2Cell *cell = (NewMy2Cell*)[collectionView cellForItemAtIndexPath:indexPath];
    [cell setBackgroundColor:HEXCOLOR(0xffffff)];

}











-(void)enterMessagePage
{
    CommunityViewController * comm = [[CommunityViewController alloc]init];
    comm.isMyMessagePage =YES;
    comm.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:comm animated:YES];

}



-(void)enterGzPage
{
    [self showGZ];
}
-(void)enterFunsPage
{
    [self showFuns];
}
-(void)enterEditPage
{
    EditUserInfoViewController * ne = [[EditUserInfoViewController alloc]init];
    ne.hidesBottomBarWhenPushed=YES;
    ne.infoDict = self.infoDict;
    [ne.upDataDict safeSetObject:[_infoDict safeObjectForKey:@"nickName"] forKey:@"nickName"];
    [ne.upDataDict safeSetObject:[_infoDict safeObjectForKey:@"sex"] forKey:@"sex"];
    [ne.upDataDict safeSetObject:[_infoDict safeObjectForKey:@"height"] forKey:@"heigth"];
    [ne.upDataDict safeSetObject:[_infoDict safeObjectForKey:@"birthday"] forKey:@"birthday"];
    
    [self.navigationController pushViewController:ne animated:YES];

}

-(void)didClickEidt
{
    EditUserInfoViewController * ne = [[EditUserInfoViewController alloc]init];
    ne.hidesBottomBarWhenPushed=YES;
    ne.infoDict = self.infoDict;
    [ne.upDataDict safeSetObject:[_infoDict safeObjectForKey:@"nickName"] forKey:@"nickName"];
    [ne.upDataDict safeSetObject:[_infoDict safeObjectForKey:@"sex"] forKey:@"sex"];
    [ne.upDataDict safeSetObject:[_infoDict safeObjectForKey:@"height"] forKey:@"heigth"];
    [ne.upDataDict safeSetObject:[_infoDict safeObjectForKey:@"birthday"] forKey:@"birthday"];

    [self.navigationController pushViewController:ne animated:YES];
}
-(void)addFriends
{
    AddFriendsViewController * addf = [[AddFriendsViewController alloc]init];
    addf.hidesBottomBarWhenPushed=YES;

    [self.navigationController pushViewController:addf animated:YES];
}

#pragma mark ----delegate


-(void)showGZ
{
    GuanZViewController * gz =[[GuanZViewController alloc]init];
    gz.title = @"关注";
    gz.pageType = IS_GZ;
    gz.hidesBottomBarWhenPushed=YES;

    [self.navigationController pushViewController:gz animated:YES];
}
-(void)showFuns
{
    GuanZViewController * gz =[[GuanZViewController alloc]init];
    gz.title = @"粉丝";
    gz.pageType = IS_FUNS;
    gz.hidesBottomBarWhenPushed=YES;

    [self.navigationController pushViewController:gz animated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ---引导页
//-(void)buildGuidePage
//{
//
//    if ([[NSUserDefaults standardUserDefaults]objectForKey:kShowGuidePage2]) {
//        return;
//    }
//
//    [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:kShowGuidePage2];
//    yd1 = [self getXibCellWithTitle:@"Yd1View"];
//    yd2 = [self getXibCellWithTitle:@"Yd2View"];
//    yd3 = [self getXibCellWithTitle:@"Yd3View"];
//    yd4 = [self getXibCellWithTitle:@"Yd4View"];
//    yd5 = [self getXibCellWithTitle:@"Yd5View"];
//    yd6 = [self getXibCellWithTitle:@"Yd6View"];
//
//    yd1.frame = CGRectMake(0, 0, JFA_SCREEN_WIDTH, JFA_SCREEN_HEIGHT);
//    yd2.frame = CGRectMake(0, 0, JFA_SCREEN_WIDTH, JFA_SCREEN_HEIGHT);
//    yd3.frame = CGRectMake(0, 0, JFA_SCREEN_WIDTH, JFA_SCREEN_HEIGHT);
//    yd4.frame = CGRectMake(0, 0, JFA_SCREEN_WIDTH, JFA_SCREEN_HEIGHT);
//    yd5.frame = CGRectMake(0, 0, JFA_SCREEN_WIDTH, JFA_SCREEN_HEIGHT);
//    yd6.frame = CGRectMake(0, 0, JFA_SCREEN_WIDTH, JFA_SCREEN_HEIGHT);
//
//    yd1.tag = 1;
//    yd2.tag = 2;
//    yd3.tag = 3;
//    yd4.tag = 4;
//    yd5.tag = 5;
//    yd6.tag = 6;
//
//
//    yd1.hidden = NO;
//    yd2.hidden = YES;
//    yd3.hidden = YES;
//    yd4.hidden = YES;
//    yd5.hidden = YES;
//    yd6.hidden = YES;
//
//    UIApplication *ap = [UIApplication sharedApplication];
//
//    [ap.keyWindow addSubview:yd1];
//    [ap.keyWindow addSubview:yd2];
//    [ap.keyWindow addSubview:yd3];
//    [ap.keyWindow addSubview:yd4];
//    [ap.keyWindow addSubview:yd5];
//    [ap.keyWindow addSubview:yd6];
//
//    [yd1.nextBtn addTarget:self action:@selector(showNextView:) forControlEvents:UIControlEventTouchUpInside];
//    [yd2.nextBtn addTarget:self action:@selector(showNextView:) forControlEvents:UIControlEventTouchUpInside];
//    [yd3.nextBtn addTarget:self action:@selector(showNextView:) forControlEvents:UIControlEventTouchUpInside];
//    [yd4.nextBtn addTarget:self action:@selector(showNextView:) forControlEvents:UIControlEventTouchUpInside];
//    [yd5.nextBtn addTarget:self action:@selector(showNextView:) forControlEvents:UIControlEventTouchUpInside];
//    [yd6.nextBtn addTarget:self action:@selector(showNextView:) forControlEvents:UIControlEventTouchUpInside];
//
//    [yd1.jumpBtn addTarget:self action:@selector(guideOver:) forControlEvents:UIControlEventTouchUpInside];
//    [yd2.jumpBtn addTarget:self action:@selector(guideOver:) forControlEvents:UIControlEventTouchUpInside];
//    [yd3.jumpBtn addTarget:self action:@selector(guideOver:) forControlEvents:UIControlEventTouchUpInside];
//    [yd4.jumpBtn addTarget:self action:@selector(guideOver:) forControlEvents:UIControlEventTouchUpInside];
//    [yd5.jumpBtn addTarget:self action:@selector(guideOver:) forControlEvents:UIControlEventTouchUpInside];
//    [yd6.jumpBtn addTarget:self action:@selector(guideOver:) forControlEvents:UIControlEventTouchUpInside];
//
//    [yd1 addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showNextsView:)]];
//    [yd2 addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showNextsView:)]];
//    [yd3 addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showNextsView:)]];
//    [yd4 addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showNextsView:)]];
//    [yd5 addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showNextsView:)]];
//
//}
//
//-(void)showNextsView:(UIGestureRecognizer *)gest
//{
//    if (gest.view==yd1) {
//        yd1.hidden = YES;
//        yd2.hidden =NO;
//    }
//    else if(gest.view==yd2)
//    {
//        yd2.hidden = YES;
//        yd3.hidden =NO;
//    }
//    else if(gest.view==yd3)
//    {
//        yd3.hidden = YES;
//        yd4.hidden =NO;
//    }
//    else if(gest.view==yd4)
//    {
//        yd4.hidden = YES;
//        yd5.hidden =NO;
//    }
//    else if(gest.view==yd5)
//    {
//        yd5.hidden = YES;
//        yd6.hidden =NO;
//    }
//}
//
//
//
//-(void)showNextView:(UIButton *)sender
//{
//    if (sender==yd1.nextBtn) {
//        yd1.hidden = YES;
//        yd2.hidden =NO;
//    }
//    else if(sender ==yd2.nextBtn)
//    {
//        yd2.hidden = YES;
//        yd3.hidden =NO;
//    }
//    else if(sender ==yd3.nextBtn)
//    {
//        yd3.hidden = YES;
//        yd4.hidden =NO;
//    }
//    else if(sender ==yd4.nextBtn)
//    {
//        yd4.hidden = YES;
//        yd5.hidden =NO;
//    }
//    else if(sender ==yd5.nextBtn)
//    {
//        yd5.hidden = YES;
//        yd6.hidden =NO;
//    }
//
//    else if(sender ==yd6.nextBtn)
//    {
//        yd6.hidden = YES;
//        [yd1 removeFromSuperview];
//        [yd2 removeFromSuperview];
//        [yd3 removeFromSuperview];
//        [yd4 removeFromSuperview];
//        [yd5 removeFromSuperview];
//        [yd6 removeFromSuperview];
//
//    }
//}
//-(void)guideOver:(UIButton *)sender
//{
//    yd1.hidden = YES;
//    yd2.hidden = YES;
//    yd3.hidden = YES;
//    yd4.hidden = YES;
//    yd5.hidden = YES;
//    yd6.hidden = YES;
//    [yd1 removeFromSuperview];
//    [yd2 removeFromSuperview];
//    [yd3 removeFromSuperview];
//    [yd4 removeFromSuperview];
//    [yd5 removeFromSuperview];
//    [yd6 removeFromSuperview];
//
//}
@end
