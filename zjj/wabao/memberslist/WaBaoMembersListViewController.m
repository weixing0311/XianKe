//
//  WaBaoMembersListViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2018/5/8.
//  Copyright © 2018年 ZhiJiangjun-iOS. All rights reserved.
//

#import "WaBaoMembersListViewController.h"
#import "WBMembersCell.h"
@interface WaBaoMembersListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic)  UITableView *tableview;
@property (nonatomic,strong)NSMutableArray * dataArray;

@end

@implementation WaBaoMembersListViewController
{
    int page;
    int pageSize;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"所有参赛者记录";
    [self setTBWhiteColor];
    // Do any additional setup after loading the view.
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 70, JFA_SCREEN_WIDTH, JFA_SCREEN_HEIGHT-70) style:UITableViewStylePlain];
    self.tableview.delegate =self;
    self.tableview.dataSource =self;
    self.tableview.separatorColor = HEXCOLOR(0xeeeeee);
    self.tableview.backgroundColor = HEXCOLOR(0xeeeeee);
    [self setExtraCellLineHiddenWithTb:self.tableview];
    [self.view addSubview:self.tableview];
    _dataArray = [NSMutableArray array];
    [self setRefrshWithTableView:self.tableview];
    [self.tableview.mj_header beginRefreshing];

}
-(void)headerRereshing
{
    page =1;
    [self getDataInfo];
}
-(void)footerRereshing
{
    page++;
    [self getDataInfo];
}

-(void)getDataInfo
{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params safeSetObject:self.periodGoodID forKey:@"periodGoodID"];
    [params safeSetObject:@(page) forKey:@"page"];
    [params safeSetObject:@(30) forKey:@"pageSize"];

    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/periodOrder/queryPeriodOrderPart.do" HiddenProgress:NO paramters:params success:^(NSDictionary *dic) {
        [self.tableview.mj_footer endRefreshing];
        [self.tableview.mj_header endRefreshing];
        [self hiddenEmptyView];
        if (page ==1) {
            [self.dataArray removeAllObjects];
            self.tableview.mj_footer.hidden = NO;
            
        }
        NSDictionary * dataDic  = [dic safeObjectForKey:@"data"];
        NSArray * infoArr = [dataDic safeObjectForKey:@"array"];

        if (infoArr.count<30) {
            [self.tableview.mj_footer setHidden:YES];
        }
        [self.dataArray addObjectsFromArray:infoArr];
        [self.tableview reloadData];

        
    } failure:^(NSError *error) {
        [self.tableview.mj_footer endRefreshing];
        [self.tableview.mj_header endRefreshing];

        if ([error code] ==402) {
            [_dataArray removeAllObjects];
            [self.tableview reloadData];
            
            [self showEmptyViewWithTitle:@"还没有人挖宝"];
        }

    }];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier  =@"WBMembersCell";
    WBMembersCell * cell =[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [self getXibCellWithTitle:identifier];
    }
    cell.tag = indexPath.row;
    NSDictionary  * dict = [_dataArray objectAtIndex:indexPath.row];
    [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:[dict safeObjectForKey:@"headimgurl"]]placeholderImage:getImage(@"default")];
    
    cell.nicknamelb.text = [dict safeObjectForKey:@"nickName"];
    cell.timelb.text = [dict safeObjectForKey:@"createTime"];
    cell.countlb.text = [NSString stringWithFormat:@"拥有%@注",[dict safeObjectForKey:@"quantitySum"]];
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
