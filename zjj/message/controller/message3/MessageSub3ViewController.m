//
//  MessageSub3ViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2018/7/5.
//  Copyright © 2018年 ZhiJiangjun-iOS. All rights reserved.
//

#import "MessageSub3ViewController.h"
#import "MsgSub3TableViewCell.h"
#import "HomePageWebViewController.h"
#import "jzsSchoolWebViewController.h"

@interface MessageSub3ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic,strong)NSMutableArray * dataArray;

@end

@implementation MessageSub3ViewController
{
    int page;
    int pageSize;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setTBWhiteColor];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"优惠活动";
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.backgroundColor = HEXCOLOR(0xeeeeee);
    self.tableview.separatorColor = HEXCOLOR(0xeeeeee);
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    pageSize =30;
    self.dataArray = [NSMutableArray array];
    self.view.backgroundColor = [UIColor grayColor];
    [self setExtraCellLineHiddenWithTb:self.tableview];
    [self setRefrshWithTableView:self.tableview];
    [self.tableview.mj_header beginRefreshing];
    self.tableview.tableFooterView.backgroundColor = [UIColor orangeColor];
    // Do any additional setup after loading the view from its nib.
}
-(void)headerRereshing
{
    page =1;
    [self getinfo];
}
-(void)footerRereshing
{
    page++;
    [self getinfo];
}
-(void)getinfo
{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params safeSetObject:@(page) forKey:@"page"];
    [params safeSetObject:@(pageSize) forKey:@"pageSize"];
    [params safeSetObject:[UserModel shareInstance].userId forKey:@"userID"];
    [params safeSetObject:@"3" forKey:@"classId"];
    
    self.currentTasks =[[BaseSservice sharedManager]post1:@"app/msg/queryNewMsgList.do " HiddenProgress:NO paramters:params success:^(NSDictionary *dic) {
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
        
        if (page ==1) {
            [self.dataArray removeAllObjects];
            self.tableview.mj_footer.hidden = NO;
            
        }
        NSDictionary * dataDic  = [dic safeObjectForKey:@"data"];
        NSArray * infoArr = [dataDic safeObjectForKey:@"array"];
        if (infoArr.count<30) {
            self.tableview.mj_footer.hidden = YES;
        }
        [self.dataArray addObjectsFromArray:infoArr];
        
        [self.tableview reloadData];
        
        
        
        
    } failure:^(NSError *error) {
        
        
        
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
        
    }];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    return 164+(JFA_SCREEN_WIDTH-20)/3*2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"MsgSub3TableViewCell";
    MsgSub3TableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [self getXibCellWithTitle:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary * dic =[self.dataArray objectAtIndex:indexPath.row];
    cell.tag = indexPath.row;
    [cell setInfoWithDict:dic];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dic = [self.dataArray objectAtIndex:indexPath.row];
    //    jzsSchoolWebViewController * home = [[jzsSchoolWebViewController alloc]init];
    HomePageWebViewController * home = [[HomePageWebViewController alloc]init];
    home.urlStr = [dic safeObjectForKey:@"linkUrl"];
    home.isShare = YES;
    home.title = @"消息详情";
    home.titleStr = [dic safeObjectForKey:@"title"];
    home.contentStr = [dic safeObjectForKey:@"sendcontent"];
    home.imageUrl = [dic safeObjectForKey:@"imgUrl"];
    home.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController: home animated:YES];
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
