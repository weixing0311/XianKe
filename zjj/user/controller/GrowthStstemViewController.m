//
//  GrowthStstemViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/9/20.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "GrowthStstemViewController.h"
#import "PublicCell.h"
#import "GrowthStstemHeaderCell.h"
#import "GrowthCell.h"
#import "LevelSnstructionsViewController.h"
@interface GrowthStstemViewController ()<UITableViewDelegate,UITableViewDataSource,growthHeaderCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic,strong)NSArray * dataArray;
@property (nonatomic,strong)NSDictionary * infoDict;
@end

@implementation GrowthStstemViewController
{
//    GrowthHeader2View * grView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的等级";
    [self setTBRedColor];
    
    UIBarButtonItem * rightitem =[[UIBarButtonItem alloc]initWithImage:getImage(@"Prompt.png") style:UIBarButtonItemStylePlain target:self action:@selector(enterRightPage)];
    self.navigationItem.rightBarButtonItem = rightitem;

    
    
    
    
    _dataArray = [NSArray array];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self setExtraCellLineHiddenWithTb:self.tableview];
//    [self buildHeaderView];
    
    [self getInfo];
    
    
    
    
    // Do any additional setup after loading the view from its nib.
}



-(void)getInfo
{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/integral/growthsystem/queryAll.do" paramters:params success:^(NSDictionary *dic) {
        self.infoDict = [NSDictionary dictionaryWithDictionary:[dic objectForKey:@"data"]];

        self.dataArray = [self.infoDict safeObjectForKey:@"taskArry"];
        
        [self.tableview reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0) {
        return 260 ;
    }else{
    return 60;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    }else{
    return self.dataArray.count;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0) {
        static NSString * identifier = @"GrowthStstemHeaderCell";
        GrowthStstemHeaderCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [self getXibCellWithTitle:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        cell.todayIntegerallb.text = [NSString  stringWithFormat:@"今日获得积分：%d",[[_infoDict safeObjectForKey:@"todayIntegeral"]intValue]];
        cell.totalIntegerallb.text = [NSString  stringWithFormat:@"%@分",[_infoDict safeObjectForKey:@"currentIntegeral"]];
        cell.dayslb.text = [NSString stringWithFormat:@"连续签到%@天",[_infoDict safeObjectForKey:@"cumulDays"]];
        
        
        int  countIntegral = [[self.infoDict objectForKey:@"countIntegral"]intValue];
        int  CurrentInegral = 0;
        NSString * currentLevel;
        NSArray * arr = [self.infoDict objectForKey:@"integeralGrade"];
        for (int i =0; i<arr.count; i++) {
            NSDictionary * dic = [arr objectAtIndex:i];
            int  integral = [[dic objectForKey:@"integral"]intValue];
            DLog(@"i =%d integral=%d",i,integral);

            if (i-1<0) {
                if (countIntegral<integral) {
                    CurrentInegral = integral-countIntegral;
                    currentLevel = [dic objectForKey:@"gradeName"];
                }
            }
            else{
                NSDictionary * dic1 = [arr objectAtIndex:i];
                int  integral1 = [[dic1 objectForKey:@"integral"]intValue];
                NSDictionary * dic2 = [arr objectAtIndex:i-1];
                int  integral2 = [[dic2 objectForKey:@"integral"]intValue];
                
                if (i==arr.count-1)
                {
                    if (countIntegral>=integral) {
                        CurrentInegral = 0;
                        currentLevel = [dic1 objectForKey:@"gradeName"];
                    }else{
                        currentLevel = [dic2 objectForKey:@"gradeName"];
                    }
                }else{
                
                if (countIntegral<integral1&&countIntegral>integral2) {
                    CurrentInegral = integral1-countIntegral;
                    currentLevel = [dic1 objectForKey:@"gradeName"];
                    
                }
                
                }
            }
            
        }
        cell.levellb.text = currentLevel;
        
        //判断是否签到
        
        NSArray * qdArr = [_infoDict safeObjectForKey:@"taskArry"];
        for (NSDictionary *QDdict in qdArr) {
            NSString * taskName = [QDdict safeObjectForKey:@"taskName"];
            if ([taskName isEqualToString:@"签到"]) {
                if ([[QDdict allKeys]containsObject:@"success"]) {
                    cell.qdBtn.selected =YES;
                    cell.qdBtn.userInteractionEnabled =NO;
                }
            }
        }
        return cell;

    }else
    {
        
    static NSString * identifier = @"GrowthCell";
    GrowthCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [self getXibCellWithTitle:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    NSDictionary * dic = [self.dataArray objectAtIndex:indexPath.row];
    cell.titlelb.text = [dic safeObjectForKey:@"taskName"];
    [cell.headerImageView sd_setImageWithURL:[NSURL URLWithString:[dic safeObjectForKey:@"picture"]] placeholderImage:getImage(@"")];
    cell.secondlb.text = [dic safeObjectForKey:@"integral"];
    
    return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark ---subView Delegate
-(void)didClickQdWithCell:(GrowthStstemHeaderCell *)cell
{
    NSMutableDictionary * params  = [NSMutableDictionary dictionary];
    for (NSDictionary * dic in self.dataArray) {
        if ([[dic safeObjectForKey:@"taskName"]isEqualToString:@"签到"]) {
            [params setObject:[dic safeObjectForKey:@"id"] forKey:@"taskId"];
            [params setObject:[dic safeObjectForKey:@"integral"] forKey:@"integeral"];
        }
    }
    [params safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
    
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/integral/growthsystem/gainPoints.do" paramters:params success:^(NSDictionary *dic) {
        DLog(@"签到success-dic:%@",dic);
        [[UserModel shareInstance]showSuccessWithStatus:@"签到成功！"];
        [self getInfo];
    } failure:^(NSError *error) {
        DLog(@"签到失败-error:%@",error);
        
    }];

}
-(void)enterRightPage
{
    LevelSnstructionsViewController * lev = [[LevelSnstructionsViewController alloc]init];
    lev.infoDict =_infoDict;
    [self.navigationController pushViewController:lev animated:YES];
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