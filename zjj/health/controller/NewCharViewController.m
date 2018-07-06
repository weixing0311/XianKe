//
//  NewCharViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2018/4/16.
//  Copyright © 2018年 ZhiJiangjun-iOS. All rights reserved.
//

#import "NewCharViewController.h"
#import "NewCharCell.h"
@interface NewCharViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableview;
@property (nonatomic,strong) NSMutableDictionary * infoDict;
@property (nonatomic,strong) NSMutableArray * dataArray;
@property(nonatomic,assign) int                 timeLength;
@property(nonatomic,copy  ) NSDate         *    startDate;
@property(nonatomic,copy  ) NSDate         *    endDate;
@property (nonatomic,assign) int       tabCount;
@end

@implementation NewCharViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabCount = 0;
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 70, JFA_SCREEN_WIDTH, self.view.frame.size.height-120) style:UITableViewStylePlain];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.view addSubview:self.tableview];
    _infoDict = [NSMutableDictionary dictionary];
    _dataArray = [NSMutableArray array];
    self.timeLength = 400;
    self.endDate = [NSDate date];
    self.startDate =[self.endDate dateByAddingTimeInterval:(-self.timeLength * 24 * 60 * 60)];

    [self getListInfo];

    // Do any additional setup after loading the view from its nib.
}
-(void)getListInfo
{
    NSMutableDictionary * param  = [NSMutableDictionary dictionary];
    [param safeSetObject:[UserModel shareInstance].subId forKey:@"subUserId"];
    [param safeSetObject:self.startDate forKey:@"startDate"];
    [param safeSetObject:self.endDate forKey:@"endDate"];
    
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/evaluatData/queryEvaluatTrend.do" HiddenProgress:NO paramters:param success:^(NSDictionary *dic) {
        NSDictionary * dataDict =[dic safeObjectForKey:@"data"];
        NSArray * arr = [dataDict safeObjectForKey:@"array"];
        [_dataArray removeAllObjects];
        for (int i =0; i<arr.count; i++) {
            NSDictionary * dict =[arr objectAtIndex:i];
            ShareHealthItem * item =[[ShareHealthItem alloc]init];
            [item setobjectWithDic:dict];
            [_dataArray addObject:item];
        }
        self.tabCount = 6;
        
        [self.tableview reloadData];
        DLog(@"%@",dic);
    } failure:^(NSError *error) {
        if (error.code ==402) {
            [self.dataArray removeAllObjects];
            [self.tableview reloadData];
            
        }
        
    }];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 250;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _tabCount;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"NewCharCell";
    NewCharCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [self getXibCellWithTitle:identifier];
    }
    cell.tag = indexPath.row;

    if (indexPath.row==0) {
        cell.titlelb.text = @"体重";
        cell.subTitlelb.text = @"(单位:kg)";
    }else if (indexPath.row ==1) {
        cell.titlelb.text = @"BMI";
        cell.subTitlelb.text = @"(单位:%)";

    }
    else if (indexPath.row ==2) {
        cell.titlelb.text = @"水分";
        cell.subTitlelb.text = @"(单位:%)";

    }
    else if (indexPath.row ==3) {
        cell.titlelb.text = @"内脂";
        cell.subTitlelb.text = @"(单位:%)";

    }
    else if (indexPath.row ==4) {
        cell.titlelb.text = @"骨量";
        cell.subTitlelb.text = @"(单位:%)";

    }
    else
    {
        cell.titlelb.text = @"体脂率";
        cell.subTitlelb.text = @"(单位:%)";
    }
    
    [cell setInfoWithArray:self.dataArray];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
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
