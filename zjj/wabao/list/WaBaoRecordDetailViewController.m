//
//  WaBaoRecordDetailViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2018/5/16.
//  Copyright © 2018年 ZhiJiangjun-iOS. All rights reserved.
//

#import "WaBaoRecordDetailViewController.h"
#import "WaBaoPersonJLCell.h"
@interface WaBaoRecordDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic,strong)NSMutableArray * dataArray;
@property (nonatomic,assign)int   page;
@property (nonatomic,assign)int   count;

@end

@implementation WaBaoRecordDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"中奖记录";
    [self setTBWhiteColor];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    _dataArray = [NSMutableArray array];
    [self setExtraCellLineHiddenWithTb:self.tableview];
    [self setRefrshWithTableView:self.tableview];

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
    
    self.currentTasks =[[BaseSservice sharedManager]post1:@"app/periodOrder/queryPeriodOrderWinning.do" HiddenProgress:NO paramters:param success:^(NSDictionary *dic) {
        [self hiddenEmptyView];
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
            if (self.page==1) {
                [self showEmptyViewWithTitle:@"暂无中奖记录"];
            }
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
    return 60;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"WaBaoPersonJLCell";
    WaBaoPersonJLCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [self getXibCellWithTitle:identifier];
    }
    NSDictionary * dic = [_dataArray objectAtIndex:indexPath.row];
    [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:[dic safeObjectForKey:@"defPicture"]] placeholderImage:getImage(@"default_")];
    cell.nicknamelb.text = [NSString stringWithFormat:@"[第%@期]%@",[dic safeObjectForKey:@"dateNo"],[dic safeObjectForKey:@"viceTitle"]];
    cell.countlb.text = [NSString stringWithFormat:@"拥有%@注",[dic safeObjectForKey:@"quantitySum"]];
    cell.timelb.text = [dic safeObjectForKey:@"createTime"];
    
    
    
    
    
    return cell;
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
