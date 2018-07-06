//
//  NewZuChengViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2018/6/14.
//  Copyright © 2018年 ZhiJiangjun-iOS. All rights reserved.
//

#import "NewZuChengViewController.h"
#import "RentBlanceUpdateViewController.h"
#import "BaseWebViewController.h"
#import "RefundTheDepositViewController.h"
#import "RefundScheduleViewController.h"
#import "RentBlanceHelpViewController.h"
#import "SuperiorViewController.h"
#import "ADCarouselView.h"

#import "ZCBannerCell.h"
#import "ZCTitleCell.h"
#import "ZCPSCell.h"
#import "ZCContentCell.h"
@interface NewZuChengViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *goodsView;

@end

@implementation NewZuChengViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tableView.delegate = self;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            return JFA_SCREEN_WIDTH;
            break;
        case 1:
            return JFA_SCREEN_WIDTH;
            break;
        case 2:
            return JFA_SCREEN_WIDTH;
            break;

        default:
            return 700;
            break;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        static NSString * identifier = @"ZCBannerCell";
        ZCBannerCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [self getXibCellWithTitle:identifier];
        }
        return cell;
    }
    else if(indexPath.row ==1)
    {
        static NSString * identifier = @"ZCTitleCell";
        ZCTitleCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [self getXibCellWithTitle:identifier];
        }
        return cell;

    }
    else if(indexPath.row ==1)
    {
        static NSString * identifier = @"ZCPSCell";
        ZCPSCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [self getXibCellWithTitle:identifier];
        }
        return cell;

    }
    else
    {
        static NSString * identifier = @"ZCContentCell";
        ZCContentCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [self getXibCellWithTitle:identifier];
        }
        return cell;

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
