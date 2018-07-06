
//
//  WaBaoViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2018/5/7.
//  Copyright © 2018年 ZhiJiangjun-iOS. All rights reserved.
//

#import "WaBaoViewController.h"
#import "WaBaoGoodsViewController.h"
#import "WaBaoRecordViewController.h"
#import "WaBaoRecordDetailViewController.h"
@interface WaBaoViewController ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *detailScrView;
@property (weak, nonatomic) IBOutlet UIView *animView;
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;

@end
@implementation WaBaoViewController
{
    BOOL is_UserRecord;
    CGPoint scrPoint;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [self setTBWhiteColor];
    _detailScrView.contentOffset = scrPoint;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"挖宝";
    scrPoint =CGPointMake(0, 0);
    UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithTitle:@"中奖记录" style:UIBarButtonItemStylePlain target:self action:@selector(didClickRightBtn:)];
    self.navigationItem.rightBarButtonItem = item;

    _animView.frame = CGRectMake(0, 115, JFA_SCREEN_WIDTH/2, 5);
    _btn1.selected = YES;
    _btn2.selected = NO;
    
    _detailScrView.delegate = self;
    _detailScrView.scrollEnabled = NO;
    
    WaBaoGoodsViewController *newHealthHistoryListVC = [[WaBaoGoodsViewController alloc] init];
    [self addChildViewController:newHealthHistoryListVC];
    [newHealthHistoryListVC didMoveToParentViewController:self];
    newHealthHistoryListVC.view.frame = CGRectMake(0, 0, _detailScrView.frame.size.width, _detailScrView.frame.size.height);
    newHealthHistoryListVC.collectionView.frame =CGRectMake(0, 0, _detailScrView.frame.size.width, _detailScrView.frame.size.height);
    [_detailScrView addSubview:newHealthHistoryListVC.view];
    
    
    
    // Do any additional setup after loading the view.
    
    WaBaoRecordViewController *HistoryRlVC = [[WaBaoRecordViewController alloc] init];
    [self addChildViewController:HistoryRlVC];
    [HistoryRlVC didMoveToParentViewController:self];
    HistoryRlVC.view.frame = CGRectMake(JFA_SCREEN_WIDTH, 0, JFA_SCREEN_WIDTH, _detailScrView.frame.size.height);
    HistoryRlVC.tableview.frame =CGRectMake(0, 0, JFA_SCREEN_WIDTH, _detailScrView.frame.size.height);

    [_detailScrView addSubview:HistoryRlVC.view];

}

- (IBAction)tap1:(id)sender {
    if (is_UserRecord ==NO) {
        return;
    }
    is_UserRecord = NO;
    _btn1.selected = YES;
    _btn2.selected = NO;
    [UIView animateWithDuration:.5 animations:^{
        _detailScrView.contentOffset = CGPointMake(0, 0);
        _animView.frame = CGRectMake(0, 115, JFA_SCREEN_WIDTH/2, 5);
        scrPoint =CGPointMake(0, 0);

    }];
}
- (IBAction)tap2:(id)sender {
    if (is_UserRecord ==YES) {
        return;
    }
    is_UserRecord = YES;
    _btn1.selected = NO;
    _btn2.selected = YES;

    [UIView animateWithDuration:.5 animations:^{
        _detailScrView.contentOffset = CGPointMake(JFA_SCREEN_WIDTH, 0);
        _animView.frame = CGRectMake(JFA_SCREEN_WIDTH/2, 115, JFA_SCREEN_WIDTH/2, 5);
        scrPoint =CGPointMake(JFA_SCREEN_WIDTH, 0);

    }];

    
}
-(void)didClickRightBtn:(UIBarButtonItem*)item
{
    WaBaoRecordDetailViewController * re =[[WaBaoRecordDetailViewController alloc]init];
    [self.navigationController pushViewController:re animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

