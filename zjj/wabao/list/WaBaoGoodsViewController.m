//
//  WaBaoGoodsViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2018/5/16.
//  Copyright © 2018年 ZhiJiangjun-iOS. All rights reserved.
//

#import "WaBaoGoodsViewController.h"
#import "WaBaoCell.h"
#import "WaBaoDetailViewController.h"
@interface WaBaoGoodsViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong)NSMutableArray * dataArray;

@end

@implementation WaBaoGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.delegate = self;
    self.collectionView.alwaysBounceVertical = YES;//实现代理
    self.collectionView.dataSource = self;                  //实现数据源方法
    self.collectionView.backgroundColor= HEXCOLOR(0xf8f8f8);
    self.collectionView.allowsMultipleSelection = YES;      //实现多选，默认是NO
    
    
    _dataArray = [NSMutableArray array];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"WaBaoCell"bundle:nil]forCellWithReuseIdentifier:@"WaBaoCell"];
    
    [self setRefrshWithTableView:(UITableView *)self.collectionView];
    [self.collectionView.mj_header beginRefreshing];

    // Do any additional setup after loading the view from its nib.
}
-(void)headerRereshing
{
    [super headerRereshing];
    [self getInfo];    
}

-(void)getInfo
{
    NSMutableDictionary *param =[NSMutableDictionary dictionary];
    
    self.currentTasks =[[BaseSservice sharedManager]post1:@"app/periodGood/queryEffectivePeriodGood.do" HiddenProgress:NO paramters:param success:^(NSDictionary *dic) {
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        
        
        [self.dataArray removeAllObjects];
        self.collectionView.mj_footer.hidden = YES;
            
        NSArray * infoArr =[[dic objectForKey:@"data"] objectForKey:@"array"];
        [self.dataArray  addObjectsFromArray:infoArr];
        
        [self.collectionView reloadData];
        
    } failure:^(NSError *error) {
        
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
    }];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArray.count;
}
////定义每个Section的四边间距

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    return UIEdgeInsetsMake(5, 5, 5, 0);//分别为上、左、下、右
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dict = [_dataArray objectAtIndex:indexPath.row];
    WaBaoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WaBaoCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:[dict safeObjectForKey:@"defPicture"]] placeholderImage:getImage(@"logo")];
    cell.titlelb .text = [dict safeObjectForKey:@"viceTitle"];
    
    cell.pricelb .text = [NSString stringWithFormat:@"￥%@",[dict safeObjectForKey:@"goodunit"]];
    
    int sumCount = [[dict safeObjectForKey:@"sumCount"]intValue];
    int alreadyCount =[[dict safeObjectForKey:@"alreadyBuyCount"]intValue];
    double width = cell.progressView.frame.size.width/sumCount*alreadyCount;
    
    cell.progressView.frame = CGRectMake(0, 0, width, 30);
    cell.countlb.text = [NSString stringWithFormat:@"已被挖走%@件/剩余%d件",[dict safeObjectForKey:@"alreadyBuyCount"],[[dict safeObjectForKey:@"sumCount"]intValue]-[[dict safeObjectForKey:@"alreadyBuyCount"]intValue]];
    return cell;
}

//设置item大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((JFA_SCREEN_WIDTH-20)/2, (JFA_SCREEN_WIDTH-20)/2+70);
}
//这个是两行cell之间的间距（上下行cell的间距）

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}
//两个cell之间的间距（同一行的cell的间距）

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    NSDictionary * dic = [_dataArray objectAtIndex:indexPath.row];
    WaBaoDetailViewController * nmd = [[WaBaoDetailViewController alloc]init];
    nmd.periodGoodID = [dic safeObjectForKey:@"id"];
    nmd.title = [dic safeObjectForKey:@"viceTitle"];
    [self.navigationController pushViewController:nmd animated:YES];
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
