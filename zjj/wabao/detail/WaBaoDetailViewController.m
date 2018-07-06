//
//  WaBaoDetailViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2018/5/8.
//  Copyright © 2018年 ZhiJiangjun-iOS. All rights reserved.
//

#import "WaBaoDetailViewController.h"
#import "WaBaoMembersListViewController.h"
#import "ADCarouselView.h"
#import "UpdataWBOrderViewController.h"
@interface WaBaoDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *pagelb;
@property (weak, nonatomic) IBOutlet UIView *imageBgView;
@property (weak, nonatomic) IBOutlet UILabel *countlb;
@property (weak, nonatomic) IBOutlet UILabel *progressView;
@property (weak, nonatomic) IBOutlet UILabel *pricelb;
@property (weak, nonatomic) IBOutlet UILabel *qlb;
@property (weak, nonatomic) IBOutlet UILabel *titlelb;
@property (weak, nonatomic) IBOutlet UIImageView *stateImg;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@end

@implementation WaBaoDetailViewController
{
    NSDictionary * infoDict;
    ADCarouselView * goodscarouselView;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView.hidden = YES;
    [self setTBWhiteColor];
    // Do any additional setup after loading the view from its nib.
    [self buildSegment];
    infoDict = [NSDictionary dictionary];
    self.countlb.adjustsFontSizeToFitWidth = YES;
    self.progressView.layer.masksToBounds = YES;
    self.progressView.layer.cornerRadius =17.5;
    [self getDataInfo];
}
-(void)buildSegment
{
    UIView *view =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    [self.navigationItem setTitleView:view];
    
    UISegmentedControl * seg = [[UISegmentedControl alloc]initWithItems:@[@"商品",@"详情"]];
    seg.frame = CGRectMake(0, 0, 100, 40);
//    seg.tintColor = [UIColor whiteColor];
    [seg addTarget:self action:@selector(changepage:) forControlEvents:UIControlEventValueChanged];
    seg.selectedSegmentIndex =0;
    [view addSubview:seg];
    [seg setTintColor:[UIColor clearColor]];
    [seg setBackgroundImage:[UIImage imageNamed:@"selectImg"]
                   forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    
    
    NSDictionary *segDic1 = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont  systemFontOfSize:20],NSFontAttributeName,[UIColor blackColor],NSForegroundColorAttributeName,nil];
    
    NSDictionary *segDic2 = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont  systemFontOfSize:17],NSFontAttributeName,[UIColor blackColor],NSForegroundColorAttributeName,nil];
    [seg setTitleTextAttributes:segDic2 forState:UIControlStateNormal];
    [seg setTitleTextAttributes:segDic1 forState:UIControlStateSelected];

}
-(void)changepage:(UISegmentedControl*)seg
{
    if (seg.selectedSegmentIndex ==0) {
        self.webView.hidden = YES;
//        self.tableview.hidden =NO;
    }else{
        self.webView.hidden =NO;
//        self.tableview.hidden = YES;
        
    }
}
-(void)buildBannerWithArr:(NSArray *)arr
{
    goodscarouselView = [ADCarouselView carouselViewWithFrame:CGRectMake(0, 0, JFA_SCREEN_WIDTH, JFA_SCREEN_WIDTH/4*3)];
    goodscarouselView.loop = YES;
    goodscarouselView.automaticallyScrollDuration = 5;
    goodscarouselView.placeholderImage = [UIImage imageNamed:@"logo_"];
    [goodscarouselView setImgs:arr];
    [self.imageBgView addSubview:goodscarouselView];

}

- (IBAction)showMembers:(id)sender {
    WaBaoMembersListViewController * member =[[WaBaoMembersListViewController alloc]init];
    member.periodGoodID = self.periodGoodID;
    [self.navigationController pushViewController:member animated:YES];
}
- (IBAction)didBuy:(id)sender {
    
    
    UpdataWBOrderViewController * wb =[[UpdataWBOrderViewController alloc]init];
    wb.infoDict = [NSMutableDictionary dictionaryWithDictionary:infoDict];
    wb.goodsCount = [self.numberLabel.text intValue];
    [self.navigationController pushViewController:wb animated:YES];
    
}
-(void)getDataInfo
{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params safeSetObject:self.periodGoodID forKey:@"periodGoodID"];
    
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/periodGood/queryEffectivePeriodGoodDetail.do" HiddenProgress:NO paramters:params success:^(NSDictionary *dic) {
        infoDict = [dic safeObjectForKey:@"data"];
        [self setInfoWithDict:infoDict];
    } failure:^(NSError *error) {
        
    }];
}
-(void)setInfoWithDict:(NSDictionary *)dict
{
    [self.webView loadHTMLString:[dict safeObjectForKey:@"pictureDetail"] baseURL:nil];
    self.qlb.text = [NSString stringWithFormat:@"第%@期",[dict safeObjectForKey:@"dateNo"]];
    self.titlelb.text = [dict safeObjectForKey:@"viceTitle"];
    self.pricelb .text = [NSString stringWithFormat:@"[每注]￥%@",[dict safeObjectForKey:@"goodunit"]];
    
    int sumCount = [[dict safeObjectForKey:@"sumCount"]intValue];
    int alreadyCount =[[dict safeObjectForKey:@"alreadyBuyCount"]intValue];
    double width = self.progressView.frame.size.width/sumCount*alreadyCount;
    
    self.progressView.frame = CGRectMake(0, 0, width, 30);
    self.countlb.text = [NSString stringWithFormat:@"已被挖走%@件/剩余%d件",[dict safeObjectForKey:@"alreadyBuyCount"],[[dict safeObjectForKey:@"sumCount"]intValue]-[[dict safeObjectForKey:@"alreadyBuyCount"]intValue]];
    self.numberLabel.text = [dict safeObjectForKey:@"minCount"];
    NSString * isActivity = [dict safeObjectForKey:@"isActivity"];
    if ([isActivity isEqualToString:@"1"]) {
        self.stateImg.image = getImage(@"wb_state_ing_");
    }else{
        self.stateImg.image = getImage(@"wb_state_ing_");
    }
    NSMutableArray * imageArray =[NSMutableArray array];
    for (int i =0; i<[dict allKeys].count; i++) {
        NSString * keyStr = [dict allKeys][i];
        if ([keyStr containsString:@"defPicture"]||([keyStr containsString:@"picture"]&&![keyStr containsString:@"pictureDetail"])) {
            [imageArray addObject:keyStr];
        }
    }
    NSMutableArray*bannerArr =[NSMutableArray array];
    for (int i =0; i<imageArray.count; i++) {
        if (i==0) {
            [bannerArr addObject:[dict safeObjectForKey:@"defPicture"]];
        }else{
        [bannerArr addObject:[dict safeObjectForKey:[NSString stringWithFormat:@"picture%d",i+1]]];
        }
    }
    [self buildBannerWithArr:bannerArr];

//    [goodscarouselView setImgs:bannerArr];
//    [goodscarouselView.carouselView reloadData];
    
}

- (IBAction)didAdd:(id)sender {
    int sumCount  = [[infoDict safeObjectForKey:@"sumCount"]intValue];

    int count = [self.numberLabel.text intValue];
    if (count>=sumCount) {
        return;
    }
    else{
        count++;
    }
    self.numberLabel.text = [NSString stringWithFormat:@"%d",count];
}

- (IBAction)didRed:(id)sender {
    int minCount  = [[infoDict safeObjectForKey:@"minCount"]intValue];

    int count = [self.numberLabel.text intValue];
    if (count<=minCount) {
        return;
    }
    else{
        count--;
    }
    self.numberLabel.text = [NSString stringWithFormat:@"%d",count];

}

- (IBAction)showCount:(id)sender {
    
    
    int sumCount  = [[infoDict safeObjectForKey:@"sumCount"]intValue];
    int minCount  = [[infoDict safeObjectForKey:@"minCount"]intValue];

    
    UIAlertController * al = [UIAlertController alertControllerWithTitle:@"修改数量" message:[NSString stringWithFormat:@"最大购买数量：%d,最小购买数量：%d",sumCount,minCount] preferredStyle:UIAlertControllerStyleAlert];
    [al addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.delegate = self;
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.text = self.numberLabel.text;
    }];
    
    [al addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        DLog(@"%@",al.textFields.firstObject.text);
        BOOL isNum = [self deptNumInputShouldNumber:al.textFields.firstObject.text];
        if (isNum !=YES||al.textFields.firstObject.text.length<1||[al.textFields.firstObject.text intValue]<minCount||[al.textFields.firstObject.text intValue]>sumCount) {
            [[UserModel shareInstance]showInfoWithStatus:@"请输入正确的数量"];
            return ;
        }
        
        else{
            self.numberLabel.text =al.textFields.firstObject.text;
            return;
        }
        
        
    }]];
    [al addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:al animated:YES completion:nil];

}





- (BOOL) deptNumInputShouldNumber:(NSString *)str
{
    NSString *regex = @"[0-9]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if ([pred evaluateWithObject:str]) {
        return YES;
    }
    return NO;
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
