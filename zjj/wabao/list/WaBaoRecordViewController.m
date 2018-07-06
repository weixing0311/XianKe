//
//  WaBaoRecordViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2018/5/16.
//  Copyright © 2018年 ZhiJiangjun-iOS. All rights reserved.
//

#import "WaBaoRecordViewController.h"
#import "WaBaoJlCell.h"
#import "WaBaoMembersListViewController.h"
@interface WaBaoRecordViewController ()<UITableViewDelegate,UITableViewDataSource,wabaojldelegate>
@property (nonatomic,strong)NSMutableArray * dataArray;
@property (nonatomic,assign)int   page;
@property (nonatomic,assign)int   count;

@end

@implementation WaBaoRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 134, JFA_SCREEN_WIDTH, self.view.frame.size.height-70) style:UITableViewStylePlain];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.view addSubview:self.tableview];
    _dataArray = [NSMutableArray array];
    [self setExtraCellLineHiddenWithTb:self.tableview];
    [self setRefrshWithTableView:self.tableview];
    // Do any additional setup after loading the view from its nib.
}
-(void)headerRereshing
{
    [super headerRereshing];
    self.page =1;
    self.count =30;
    [self getUserJl];
    
}
-(void)footerRereshing
{
    [super footerRereshing];
    self.page ++;
    [self getUserJl];
}

-(void)getUserJl
{
    
    NSMutableDictionary *param =[NSMutableDictionary dictionary];
    [param setObject:@(self.page) forKey:@"page"];
    [param setObject:@(self.count) forKey:@"pageSize"];
    [param setObject:[UserModel shareInstance].userId forKey:@"userID"];
    
    self.currentTasks =[[BaseSservice sharedManager]post1:@"app/periodOrder/queryEffectivePeriodGoodDetail.do" HiddenProgress:NO paramters:param success:^(NSDictionary *dic) {
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
        
        NSArray * infoArr =[[dic objectForKey:@"data"] objectForKey:@"array"];

        
        if (self.page ==1) {
            [_dataArray removeAllObjects];
            self.tableview.mj_footer.hidden = NO;
            
        }
        if (infoArr.count<30) {
            self.tableview.mj_footer.hidden =YES;
        }
        [self.dataArray  addObjectsFromArray:infoArr];
        
        [self.tableview reloadData];
        
    } failure:^(NSError *error) {
        if ([error code]==402) {
            [_dataArray removeAllObjects];
            [self.tableview reloadData];
            
            
        }
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
    }];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dic = [_dataArray objectAtIndex:indexPath.row];
    NSDictionary * userInfoDict = [dic safeObjectForKey:@"winningUser"];
    if ([userInfoDict allKeys].count>0) {
        return 243;
    }
    else{
        return 120;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"WaBaoJlCell";
    WaBaoJlCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [self getXibCellWithTitle:identifier];
    }
    cell.tag = indexPath.row;
    cell.delegate = self;
    NSDictionary * dic = [_dataArray objectAtIndex:indexPath.row];
    [cell.goodsImage sd_setImageWithURL:[NSURL URLWithString:[dic safeObjectForKey:@"defPicture"]] placeholderImage:getImage(@"default_")];
    cell.periodCountlb.text = [NSString stringWithFormat:@"[第%@期]",[dic safeObjectForKey:@"dateNo"]];
    cell.titlelb.text  =[dic safeObjectForKey:@"goodName"];
    cell.pricelb.text = [NSString stringWithFormat:@"￥%.2f",[[dic safeObjectForKey:@"payableAmount"]doubleValue]];


    //判断是否已开奖
    NSString * isOpen = [dic safeObjectForKey:@"isLottery"];
    if (![isOpen isEqualToString:@"1"]) {
        cell.wennerNumlb.text = @"未开奖";

    }else{
        
        
        cell.wennerNumlb.text = [NSString stringWithFormat:@"本期开奖挖宝号码：%@",[dic safeObjectForKey:@"winningCode"]];
        ///判断是否中奖 iswinning  0未中奖  1 中奖
//        NSString * isOpen = [dic safeObjectForKey:@"iswinning"];
//        if ([isOpen isEqualToString:@"1"]) {
//            cell.wennerNumlb.text = @"已中奖";
//        }else{
//            cell.wennerNumlb.text = @"未中奖";
//        }
    }
    NSDictionary * userInfoDict = [dic safeObjectForKey:@"winningUser"];
    
    if ([userInfoDict allKeys].count>0) {
        cell.memberView.hidden = NO;
        [cell.headImage sd_setImageWithURL:[NSURL URLWithString:[userInfoDict safeObjectForKey:@"headimgurl"]] placeholderImage:getImage(@"default_")];
        cell.nicknamelb.text =[userInfoDict safeObjectForKey:@"nickName"];
//        cell.startTime.text = [userInfoDict safeObjectForKey:@"nickName"];
//        cell.endTimelb.text = [userInfoDict safeObjectForKey:@"nickName"];
        cell.countlb.text = [NSString stringWithFormat:@"[获奖者本期获得注数：%@注]",[userInfoDict safeObjectForKey:@"quantity"]];

    }else{
        cell.memberView.hidden = YES;
        
    }
    return cell;
}
-(void)showMemberWithCell:(WaBaoJlCell*)cell
{
    NSDictionary * dic =[_dataArray objectAtIndex:cell.tag];
    WaBaoMembersListViewController * mb = [[WaBaoMembersListViewController alloc]init];
    mb.periodGoodID =[dic safeObjectForKey:@"periodGoodID"];
    [self.navigationController pushViewController:mb animated:YES];
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
