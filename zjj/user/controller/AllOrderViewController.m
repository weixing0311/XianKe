//
//  AllOrderViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2018/4/13.
//  Copyright © 2018年 ZhiJiangjun-iOS. All rights reserved.
//

#import "AllOrderViewController.h"
#import "OrderViewController.h"
#import "IntegralOrderViewController.h"
@interface AllOrderViewController ()<UIScrollViewDelegate>
@property (nonatomic,strong)OrderViewController * orderVC;
@property (nonatomic,strong)IntegralOrderViewController * IntegralOrderVC;
@end

@implementation AllOrderViewController
{
    UIScrollView * bbScr;
    UIButton * title1Btn;
    UIButton * title2Btn;
    UIView * lineView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self buildTitleView];
    
    bbScr = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    bbScr.pagingEnabled = YES;
    bbScr.delegate = self;
    bbScr.scrollEnabled = NO;
    bbScr .contentSize = CGSizeMake(self.view.frame.size.width *2, 0);
    [self.view addSubview:bbScr];
    
    
    
    self.orderVC = [[OrderViewController alloc] init];
    [self addChildViewController:self.orderVC];
    self.orderVC.getOrderType =IS_ALL;
    [self.orderVC didMoveToParentViewController:self];
    self.orderVC.view.frame = CGRectMake(0, 0, self.view.frame.size.width, bbScr.frame.size.height);
    self.orderVC.tableview.frame =CGRectMake(0, 0, self.view.frame.size.width, bbScr.frame.size.height);
    [bbScr addSubview:self.orderVC.view];
    
    
    
    // Do any additional setup after loading the view.
    
    self.IntegralOrderVC = [[IntegralOrderViewController alloc] init];
    [self addChildViewController:self.IntegralOrderVC];
    self.IntegralOrderVC.getOrderType =IS_ALL;
    [self.IntegralOrderVC didMoveToParentViewController:self];
    self.IntegralOrderVC.view.frame = CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, bbScr.frame.size.height);
    
    [bbScr addSubview:self.IntegralOrderVC.view];

    
    
    
    
    
}

-(void)buildTitleView
{
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    titleView.backgroundColor = [UIColor whiteColor];
    self.navigationItem.titleView = titleView;
    
//    UIView * titleView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 120, 120)];
    title1Btn = [[UIButton alloc]initWithFrame:CGRectMake(titleView.frame.size.width/2-80, 7, 80, 30)];
    [title1Btn setTitle:@"商品订单" forState:UIControlStateNormal];
    [title1Btn addTarget:self action:@selector(showGoodsOrderList) forControlEvents:UIControlEventTouchUpInside];
    [title1Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [titleView addSubview:title1Btn];


    title2Btn = [[UIButton alloc]initWithFrame:CGRectMake(titleView.frame.size.width/2, 7, 80, 30)];
    [title2Btn setTitle:@"积分订单" forState:UIControlStateNormal];
    [title2Btn addTarget:self action:@selector(showIntegralOrderList) forControlEvents:UIControlEventTouchUpInside];
    [title2Btn setTitleColor:HEXCOLOR(0x666666) forState:UIControlStateNormal];

    [titleView addSubview:title2Btn];
    
    lineView = [[UIView alloc]initWithFrame:CGRectMake(25, 39, 50, 5)];
    lineView.backgroundColor = [UIColor greenColor];
    [titleView addSubview:lineView];
    
}
-(void)showGoodsOrderList
{
    if (bbScr.contentOffset.x ==0) {
        return;
    }
    [title1Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [title2Btn setTitleColor:HEXCOLOR(0x666666) forState:UIControlStateNormal];
    [UIView animateWithDuration:0.3 animations:^{
        bbScr.contentOffset = CGPointMake(0, 0);
        lineView.frame = CGRectMake(title1Btn.center.x-25, 39, 50, 5);
    } completion:^(BOOL finished) {
        
    }];

}
-(void)showIntegralOrderList
{
    if (bbScr.contentOffset.x ==JFA_SCREEN_WIDTH) {
        return;
    }

    [title1Btn setTitleColor:HEXCOLOR(0x666666) forState:UIControlStateNormal];
    [title2Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [UIView animateWithDuration:0.3 animations:^{
        bbScr.contentOffset = CGPointMake(JFA_SCREEN_WIDTH, 0);
        lineView.frame = CGRectMake(title2Btn.center.x-25, 39, 50, 5);

    } completion:^(BOOL finished) {
        
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
