//
//  HistoryTotalViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/11/1.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "HistoryTotalViewController.h"
#import "HistoryInfoViewController.h"
#import "NewHealthHistoryListViewController.h"
#import "NewCharViewController.h"
#import "ShareListView.h"
#import "WriteArtcleViewController.h"
@interface HistoryTotalViewController ()<UIScrollViewDelegate>

@end

@implementation HistoryTotalViewController
{
    NewHealthHistoryListViewController * newHealthHistoryListVC;
    HistoryInfoViewController * HistoryRlVC;
    NewCharViewController * charVC;
    UIScrollView * bbScr;
    UIButton * btn1;
    UIButton * btn2;
    UIButton * btn3;

    NSDictionary * infoDict;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [self.navigationController setNavigationBarHidden:YES animated:animated];
//    [self setTBWhiteColor];
//    self.title = @"体脂趋势";
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.view.backgroundColor = HEXCOLOR(0xffffff);
//    UIBarButtonItem * rightitem =[[UIBarButtonItem alloc]initWithImage:getImage(@"share_") style:UIBarButtonItemStylePlain target:self action:@selector(didClickShare)];
    infoDict = [NSDictionary  dictionary];
//    UIBarButtonItem * right1item  = [[UIBarButtonItem alloc]initWithImage:getImage(@"daka_") style:UIBarButtonItemStylePlain target:self action:@selector(didClickQD)];
//
//
//
//    UIImage * image = getImage(@"shareWhite_");
//    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//
//
//
//
//    UIBarButtonItem * right2item  = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(didClickShare)];
//
//
//
//
//    self.navigationItem.rightBarButtonItems = @[right1item,right2item];
    
    
    
    bbScr = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, JFA_SCREEN_WIDTH, self.view.frame.size.height -55-64)];
    bbScr.pagingEnabled = YES;
    bbScr.delegate = self;
    bbScr.scrollEnabled = NO;
    bbScr .contentSize = CGSizeMake(JFA_SCREEN_WIDTH *3, 0);
//    bbScr.backgroundColor = HEXCOLOR(0xadc123);
    [self.view addSubview:bbScr];
    
    

    newHealthHistoryListVC = [[NewHealthHistoryListViewController alloc] init];
    [self addChildViewController:newHealthHistoryListVC];
    [newHealthHistoryListVC didMoveToParentViewController:self];
    newHealthHistoryListVC.view.frame = CGRectMake(0, 0, JFA_SCREEN_WIDTH, bbScr.frame.size.height);
    newHealthHistoryListVC.tableview.frame =CGRectMake(0, 134, JFA_SCREEN_WIDTH, bbScr.frame.size.height-134);
    [bbScr addSubview:newHealthHistoryListVC.view];

    
    
    // Do any additional setup after loading the view.
    
    HistoryRlVC = [[HistoryInfoViewController alloc] init];
    [self addChildViewController:HistoryRlVC];
    [HistoryRlVC didMoveToParentViewController:self];
    HistoryRlVC.view.frame = CGRectMake(JFA_SCREEN_WIDTH, 0, JFA_SCREEN_WIDTH, bbScr.frame.size.height);

    [bbScr addSubview:HistoryRlVC.view];

    
    charVC = [[NewCharViewController alloc] init];
    [self addChildViewController:charVC];
    [charVC didMoveToParentViewController:self];
    charVC.view.frame = CGRectMake(JFA_SCREEN_WIDTH*2, 0, JFA_SCREEN_WIDTH, bbScr.frame.size.height);
    
    [bbScr addSubview:charVC.view];


    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-51, JFA_SCREEN_WIDTH, 1)];
    lineView.backgroundColor = HEXCOLOR(0xeeeeee);
    [self.view addSubview:lineView];
    btn1 = [UIButton new];
    btn2 = [UIButton new];
    btn3 = [UIButton new];

    btn1.backgroundColor = [UIColor orangeColor];
    
    [btn1 addTarget:self action:@selector(change1:) forControlEvents:UIControlEventTouchUpInside];
    [btn1 setTitle:@"列表模式" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [btn1 setTitleColor:HEXCOLOR(0x666666) forState:UIControlStateNormal];
    btn1.selected = YES;
    btn1.tag = 1;
    [self.view addSubview:btn1];
    
    [btn2 addTarget:self action:@selector(change2:) forControlEvents:UIControlEventTouchUpInside];
    [btn2 setTitle:@"日历模式" forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [btn2 setTitleColor:HEXCOLOR(0x666666) forState:UIControlStateNormal];
    [self.view addSubview:btn2];
    btn2.tag =2;
    btn2.backgroundColor = [UIColor whiteColor];
    
    
    [btn3 addTarget:self action:@selector(change3:) forControlEvents:UIControlEventTouchUpInside];
    [btn3 setTitle:@"曲线模式" forState:UIControlStateNormal];
    [btn3 setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [btn3 setTitleColor:HEXCOLOR(0x666666) forState:UIControlStateNormal];
    [self.view addSubview:btn3];
    btn3.tag =3;
    btn3.backgroundColor = [UIColor whiteColor];

    
    btn1.frame = CGRectMake(0, self.view.frame.size.height-50, JFA_SCREEN_WIDTH/3, 50);
   btn2.frame = CGRectMake(JFA_SCREEN_WIDTH/3, self.view.frame.size.height-50, JFA_SCREEN_WIDTH/3, 50);
    btn3.frame = CGRectMake(JFA_SCREEN_WIDTH/3*2, self.view.frame.size.height-50, JFA_SCREEN_WIDTH/3, 50);
    [self setNavigationBar];

    [self getShareInfo];
}
-(void)setNavigationBar
{
    UIView * titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, JFA_SCREEN_WIDTH, 64)];
    titleView.backgroundColor  = [UIColor whiteColor];
    
    UIButton * button =[[UIButton alloc]initWithFrame:CGRectMake(0, 20, 44, 44)];
    [button setImage:getImage(@"black_back") forState:UIControlStateNormal];
    [button addTarget:self action:@selector(myBack) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:button];
    
    
    UILabel * titlelb = [[UILabel alloc]initWithFrame:CGRectMake(JFA_SCREEN_WIDTH/2-70, 0, 140, 44)];
    titlelb.center = CGPointMake(JFA_SCREEN_WIDTH/2, 42);
    titlelb.textAlignment = NSTextAlignmentCenter;
    titlelb.font = [UIFont boldSystemFontOfSize:18];
    titlelb.text = @"体脂趋势";
    [titleView addSubview: titlelb];
    
    
    UIButton * right1btn =[[UIButton alloc]initWithFrame:CGRectMake(JFA_SCREEN_WIDTH-85, 20, 44, 44)];
    [right1btn setImage:getImage(@"healthHistory_Right_1") forState:UIControlStateNormal];
    [right1btn addTarget:self action:@selector(didDk) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:right1btn];
    right1btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;//(需要何值请参看API文档)

    
    UIButton * right2btn =[[UIButton alloc]initWithFrame:CGRectMake(JFA_SCREEN_WIDTH-40, 20, 44, 44)];
    [right2btn setImage:getImage(@"healthHistory_Right_2") forState:UIControlStateNormal];
    [right2btn addTarget:self action:@selector(didMyShare) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:right2btn];
    right2btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;//(需要何值请参看API文档)

    
    
    [self.view addSubview:titleView];
    
    
    
}
-(void)myBack
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)getShareInfo
{
    NSMutableDictionary *param =[NSMutableDictionary dictionary];
    [param safeSetObject:[UserModel shareInstance].subId forKey:@"subUserId"];
    
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/evaluatData/queryShareEvaluatList.do" HiddenProgress:YES paramters:param success:^(NSDictionary *dic) {
        DLog(@"%@",dic);
        infoDict = [dic safeObjectForKey:@"data"];
        
        
        
        
    } failure:^(NSError *error) {
        DLog(@"%@",error);
    }];
    
    

}
-(void)didDk
{
    if (!infoDict||[infoDict allKeys].count<2) {
        [[UserModel shareInstance]showInfoWithStatus:@"您的体测数据少于两条，请体测后再分享"];
        return;
    }
    UIImage * image = [self showShareView];
    WriteArtcleViewController*postVC = [[WriteArtcleViewController alloc]init];
    postVC.firstImage = image;
    postVC.shareType  =nil;
    postVC.textStr = [NSString stringWithFormat:@"[减脂第%d天]共减重%.1fkg，坚持，只为遇见更好的自己！",[[infoDict safeObjectForKey:@"useDays"]intValue],[[infoDict safeObjectForKey:@"subtractWeight"]doubleValue]];
    [self.navigationController pushViewController:postVC animated:YES];

}
-(void)didMyShare
{
    
    [newHealthHistoryListVC enterRightPage];
}
-(UIImage *)showShareView
{
    
    NSString * qrCode = [UserModel shareInstance].qrcodeImageUrl;
    if (!qrCode||qrCode.length<1) {
        [[UserModel shareInstance]getbalance];
    }
    ShareListView * shareTr = [self getXibCellWithTitle:@"ShareListView"];
    ShareHealthItem * item1 = [infoDict safeObjectForKey:@"first"];
    ShareHealthItem * item2 =[infoDict safeObjectForKey:@"last"];
    
    
    
    
    
    NSMutableArray * arr =[NSMutableArray array];
    [arr addObject:item1];
    [arr addObject:item2];
    [shareTr setInfoWithArr:arr];
    [self.view addSubview:shareTr];
    [self.view bringSubviewToFront:shareTr];
    
    
    
    return   [self getImageWithView:shareTr];
    
}

-(void)change1:(UIButton *)sender
{
    if (btn1.selected==YES) {
        return;
    }
    btn1.selected = YES;
    btn1.backgroundColor = [UIColor orangeColor];
    btn2.selected =NO;
    btn2.backgroundColor =[UIColor whiteColor];
    btn3.selected =NO;
    btn3.backgroundColor =[UIColor whiteColor];

    
    
    bbScr.contentOffset = CGPointMake(0, 0);
    UIBarButtonItem * rightitem =[[UIBarButtonItem alloc]initWithTitle:@"分享" style:UIBarButtonItemStylePlain target:self action:@selector(didClickShare)];
    self.navigationItem.rightBarButtonItem = rightitem;

}
-(void)change2:(UIButton *)sender
{
    if (btn2.selected==YES) {
        return;
    }

    btn2.selected = YES;
    btn2.backgroundColor = [UIColor orangeColor];
    btn1.selected =NO;
    btn1.backgroundColor =[UIColor whiteColor];
    btn3.selected =NO;
    btn3.backgroundColor =[UIColor whiteColor];

    bbScr.contentOffset = CGPointMake(JFA_SCREEN_WIDTH, 0);
   self.navigationItem.rightBarButtonItem = nil;
}
-(void)change3:(UIButton *)sender
{
    if (btn3.selected==YES) {
        return;
    }
    btn3.selected = YES;
    btn3.backgroundColor = [UIColor orangeColor];

    btn2.selected = NO;
    btn2.backgroundColor = [UIColor whiteColor];
    btn1.selected =NO;
    btn1.backgroundColor =[UIColor whiteColor];
    
    bbScr.contentOffset = CGPointMake(JFA_SCREEN_WIDTH*2, 0);
    self.navigationItem.rightBarButtonItem = nil;
}


- (void)changeControllerFromOldController:(UIViewController *)oldController toNewController:(UIViewController *)newController
{
    [self addChildViewController:newController];
    /**
     *  切换ViewController
     */
    [self transitionFromViewController:oldController toViewController:newController duration:0.3 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        //做一些动画
        
    } completion:^(BOOL finished) {
        
        if (finished) {
            
            //移除oldController，但在removeFromParentViewController：方法前不会调用willMoveToParentViewController:nil 方法，所以需要显示调用
            [newController didMoveToParentViewController:self];
            [oldController willMoveToParentViewController:nil];
            [oldController removeFromParentViewController];
//            currentVC = newController;
            
        }else
        {
//            currentVC = oldController;
        }
        
    }];
}

-(UIImage *)getImageWithView:(UIView*)view
{
    UIGraphicsBeginImageContext(view.bounds.size);     //currentView 当前的view  创建一个基于位图的图形上下文并指定大小为
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];//renderInContext呈现接受者及其子范围到指定的上下文
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();//返回一个基于当前图形上下文的图片
    UIGraphicsEndImageContext();//移除栈顶的基于当前位图的图形上下文
    //    UIImageWriteToSavedPhotosAlbum(viewImage, nil, nil, nil);//然后将该图片保存到图片图
    [view removeFromSuperview];
    return viewImage;
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
