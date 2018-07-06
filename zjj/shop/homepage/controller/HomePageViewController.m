//
//  HomePageViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/6/12.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "HomePageViewController.h"
#import "GoodsDetailViewController.h"
#import "GoodSCell.h"
#import "Goods2Cell.h"
#import "HomeModel.h"
#import "BannerItem.h"
#import "FootView.h"
#import "GoodsItem.h"
#import "UIButton+AFNetworking.h"
#import "HomeHeadView.h"
#import "HomePageWebViewController.h"
@interface HomePageViewController ()<footViewDelegate>
@property (nonatomic,assign)int   page;
@property (nonatomic,assign)int   count;

@end

@implementation HomePageViewController
{
    NSMutableArray * _dataArray;
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setTBWhiteColor];
    self.title = @"商城";
    [self.navigationController setNavigationBarHidden:NO animated:animated];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray =[NSMutableArray array];

    self.layout.headerReferenceSize = CGSizeMake(JFA_SCREEN_WIDTH, 200);
    
    
    
    self.collectionView.delegate = self;
    self.collectionView.alwaysBounceVertical = YES;//实现代理
    self.collectionView.dataSource = self;                  //实现数据源方法
    self.collectionView.backgroundColor= HEXCOLOR(0xf8f8f8);
    self.collectionView.allowsMultipleSelection = YES;      //实现多选，默认是NO
    self.collectionView.frame = CGRectMake(0, 0, JFA_SCREEN_WIDTH, self.view.frame.size.height-self.tabBarController.tabBar.frame.size.height);
    [self.view addSubview:self.collectionView];
    
    
    
     [self.collectionView registerNib:[UINib nibWithNibName:@"GoodSCell"bundle:nil]forCellWithReuseIdentifier:@"GoodSCell"];

    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headView"];

    
    [self setRefrshWithTableView:(UITableView *)self.collectionView];
    [self.collectionView.mj_header beginRefreshing];
    
//    [self getBanner];
}
-(void)headerRereshing
{
    [super headerRereshing];
    self.page =1;
    self.count =30;
    
    [self getGoodsListInfo];
    
}
-(void)footerRereshing
{
    [super footerRereshing];
    self.page ++;
    [self getGoodsListInfo];
    
}
-(void)getGoodsListInfo
{
    NSMutableDictionary *param =[NSMutableDictionary dictionary];
    [param setObject:@(self.page) forKey:@"page"];
    [param setObject:@(self.count) forKey:@"pageSize"];
    [param setObject:[UserModel shareInstance].userId forKey:@"userId"];
    
    self.currentTasks = [[BaseSservice sharedManager]post1:kgetGoodsListInfo HiddenProgress:NO paramters:param success:^(NSDictionary *dic) {
        DLog(@"goods---%@--message_%@",dic,[dic objectForKey:@"message"]);
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];

        if (self.page ==1) {
            [_dataArray removeAllObjects];
            self.collectionView.mj_footer.hidden = NO;

        }
        
        NSArray *array = [[dic objectForKey:@"data"] objectForKey:@"array"];
        if ( array.count<30) {
            self.collectionView.mj_footer.hidden = YES;
        }
        for (NSDictionary *dict  in array) {
            GoodsItem *item = [[GoodsItem alloc]init];
            [item setGoodsInfoWithDict:dict];
            [_dataArray addObject:item];
        }
        
        [self.collectionView reloadData];
        
    } failure:^(NSError *error) {
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];

        if ([error code]==402) {
            
            [[UserModel shareInstance]showInfoWithStatus:@"没有更多商品了"];
        }
    }];
}
//-(void)getBanner
//{
//    self.currentTasks = [[BaseSservice sharedManager]post1:kBannerListUrl HiddenProgress:NO paramters:nil success:^(NSDictionary *dic) {
//        DLog(@"bannerdic---%@",dic);
//        NSMutableArray *arr =[[dic objectForKey:@"data"]objectForKey:@"array"];
//        NSMutableArray *array =[[HomeModel shareInstance]arraySortingWithArray:arr];
//
//        [_bannerArray removeAllObjects];
//        [_bannerInfoArray removeAllObjects];
//
//        for (NSDictionary *dict  in array) {
//            BannerItem *item = [[BannerItem alloc]init];
//            [item setBannerInfoWithDict:dict];
//            [_bannerInfoArray addObject:item];
//            if ([item.recommendID isEqualToString:@"1"]) {
//                [_bannerArray addObject:item];
//            }
//        }
//
//        [self.collectionView reloadData];
//
//    } failure:^(NSError *error) {
//
//    }];
//
//}

-(void)didback
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"changeOtherItem" object:nil];
}




#pragma mark ---collectionView Delegate
//设置HeadView
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
        return CGSizeMake(JFA_SCREEN_WIDTH, JFA_SCREEN_WIDTH/2.2+20+JFA_SCREEN_WIDTH*0.1);
    
}
//-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
//{
//    return CGSizeMake(JFA_SCREEN_WIDTH, 530);
//}
//创建headview
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
            withReuseIdentifier:@"headView"forIndexPath:indexPath];

//        headView.backgroundColor = [UIColor whiteColor];
//
//        NSMutableArray * images =[NSMutableArray array];
//        for (int i =0; i<_bannerArray.count; i++) {
//            BannerItem *item = [_bannerArray objectAtIndex:i];
//            [images addObject:item.imageUrl];
//        }
//
//
//        ADCarouselView *carouselView = [ADCarouselView carouselViewWithFrame:CGRectMake(0, 0, JFA_SCREEN_WIDTH, _bannerHight)];
//        carouselView.loop = YES;
//        carouselView.delegate = self;
//        carouselView.automaticallyScrollDuration = 5;
//
//        carouselView.imgs = images;
//        carouselView.placeholderImage = [UIImage imageNamed:@"zhanweifu"];
//        [headView addSubview:carouselView];
//
//        HomeHeadView *hh =[self getXibCellWithTitle:@"HomeHeadView"];
//        hh.frame = CGRectMake(0, _bannerHight, JFA_SCREEN_WIDTH, 44);
//        [headView addSubview:hh];
        UIImageView * imageView =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, JFA_SCREEN_WIDTH, JFA_SCREEN_WIDTH/2.2)];

        imageView.image = getImage(@"shopTop_");
        [headView addSubview:imageView];
        
        
        UIView * lineView =[[UIView alloc]initWithFrame:CGRectMake(0, JFA_SCREEN_WIDTH/2.2, JFA_SCREEN_WIDTH, 10)];
        lineView.backgroundColor = HEXCOLOR(0xeeeeee);
        [headView addSubview:lineView];
        
        
        UIImageView * imageView2 =[[UIImageView alloc]initWithFrame:CGRectMake(0, JFA_SCREEN_WIDTH/2.2+10, JFA_SCREEN_WIDTH, JFA_SCREEN_WIDTH*0.1)];
        
        imageView2.image = getImage(@"hotGoodsTitle_");
        [headView addSubview:imageView2];
        
        
        UIView * lineView2 =[[UIView alloc]initWithFrame:CGRectMake(0, JFA_SCREEN_WIDTH/2.2+10+JFA_SCREEN_WIDTH*0.1, JFA_SCREEN_WIDTH, 10)];
        lineView2.backgroundColor = HEXCOLOR(0xeeeeee);
        [headView addSubview:lineView2];


        return headView;
    }
    return nil;
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
    
    return UIEdgeInsetsMake(5, 5, 5, 5);//分别为上、左、下、右
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
        GoodSCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GoodSCell" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
    GoodsItem *item =[ _dataArray objectAtIndex:indexPath.row];
    [cell updataWithItem:item];
        return cell;
}

//设置item大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
        return CGSizeMake((JFA_SCREEN_WIDTH-20)/2, (JFA_SCREEN_WIDTH-20)/2/167*220+10);
}
//这个是两行cell之间的间距（上下行cell的间距）

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}
//两个cell之间的间距（同一行的cell的间距）

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    GoodsItem * item = [_dataArray objectAtIndex:indexPath.row];

    GoodsDetailViewController *gs = [[GoodsDetailViewController alloc]init];
    gs.productNo = item.productNo;
    gs.hidesBottomBarWhenPushed = YES;
    if (self.couponNo&&self.couponNo.length>3) {
        gs.couponNo = self.couponNo;
    }
//    self.navigationController.navigationBarHidden = NO;

    [self.navigationController pushViewController:gs animated:YES];
    
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
