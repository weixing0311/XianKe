//
//  ADDCheng3ViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2018/4/12.
//  Copyright © 2018年 ZhiJiangjun-iOS. All rights reserved.
//

#import "ADDCheng3ViewController.h"
#import "SXSRulerControl.h"
#import "TabbarViewController.h"
@interface ADDCheng3ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *currWeightlb;
@property (weak, nonatomic) IBOutlet UIView *currRuleBgView;
@property (weak, nonatomic) IBOutlet UILabel *targetWeightlb;
@property (weak, nonatomic) IBOutlet UIView *targetRuleBgView;
@property (nonatomic,strong)SXSRulerControl * ruler1;
@property (nonatomic,strong)SXSRulerControl * ruler2;

@end

@implementation ADDCheng3ViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setTBWhiteColor];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self buildRule];
    self.title = @"完善资料3/3";
    self.currWeightlb.text = @"100斤";
    self.targetWeightlb.text = @"100斤";
}


-(void)buildRule
{
    
    _ruler1 = [[SXSRulerControl alloc]initWithFrame:self.currRuleBgView.bounds];
    
    _ruler1.midCount=1;//几个大格标记一个刻度
    _ruler1.smallCount=5;//一个大格几个小格
    _ruler1.minValue = 30;// 最小值
    _ruler1.maxValue = 400;// 最大值
    _ruler1.valueStep = 5;// 两个标记刻度之间相差大小
    _ruler1.minorScaleSpacing = 10;
    _ruler1.selectedValue = 100;// 设置默认值
    
    [_ruler1 addTarget:self action:@selector(selectedValueChanged1:) forControlEvents:UIControlEventValueChanged]; // 添加监听方法
    
    [self.currRuleBgView addSubview:_ruler1];

    
    _ruler2 = [[SXSRulerControl alloc]initWithFrame:self.targetRuleBgView.bounds];
    
    _ruler2.midCount=1;//几个大格标记一个刻度
    _ruler2.smallCount=5;//一个大格几个小格
    _ruler2.minValue = 30;// 最小值
    _ruler2.maxValue = 400;// 最大值
    _ruler2.valueStep = 5;// 两个标记刻度之间相差大小
    _ruler2.minorScaleSpacing = 10;
    _ruler2.selectedValue = 100;// 设置默认值
    
    [_ruler2 addTarget:self action:@selector(selectedValueChanged2:) forControlEvents:UIControlEventValueChanged]; // 添加监听方法
    
    [self.targetRuleBgView addSubview:_ruler2];

}
- (void)selectedValueChanged1:(SXSRulerControl *)ruler {
    
    self.currWeightlb.text = [NSString stringWithFormat:@"%.0f",ruler.selectedValue];
}
- (void)selectedValueChanged2:(SXSRulerControl *)ruler {
    
    self.targetWeightlb.text = [NSString stringWithFormat:@"%.0f",ruler.selectedValue];
}

- (IBAction)upLoadInfo:(id)sender {
    if (self.isResignUser ==YES)
    {
        [self addMainUserInfo];
    }
    else
    {
        [self addSubUserInfo];
    }
}
-(void)addSubUserInfo
{
    
    if (self.currWeightlb.text.length<1) {
        [[UserModel shareInstance] showInfoWithStatus:@"请填写当前体重"];
        return;
        
    }
    if (self.targetWeightlb.text.length<1) {
        [[UserModel shareInstance] showInfoWithStatus:@"请填写目标体重"];
        return;
        
    }

    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params = [[UserModel shareInstance]getChangeUserInfoDict];
    
    [params safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
    [params safeSetObject:self.nickname forKey:@"nickName"];
    [params safeSetObject:[NSString stringWithFormat:@"%@",self.sex] forKey:@"sex"];
    [params safeSetObject:self.height forKey:@"heigth"];
    [params safeSetObject:self.birthday forKey:@"birthday"];
    [params safeSetObject:self.currWeightlb.text forKey:@"currTargetWeight"];
    [params safeSetObject:self.targetWeightlb.text forKey:@"targetWeight"];

    
    
    self.currentTasks = [[BaseSservice sharedManager]postImage:@"app/evaluatUser/addChild.do" paramters:params imageData:self.imageData imageName:@"headimgurl" success:^(NSDictionary *dic) {
        
        NSDictionary * dataDic =[dic safeObjectForKey:@"data"];
        
        [[UserModel shareInstance]setChildArrWithDict:dataDic];
        
        DLog(@"%@",dic);
        [[UserModel shareInstance] showSuccessWithStatus:@"添加成功"];
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    } failure:^(NSError *error) {
        
    }];
    
}
-(void)addMainUserInfo
{
    
    if (self.currWeightlb.text.length<1) {
        [[UserModel shareInstance] showInfoWithStatus:@"请填写当前体重"];
        return;
        
    }
    if (self.targetWeightlb.text.length<1) {
        [[UserModel shareInstance] showInfoWithStatus:@"请填写目标体重"];
        return;
        
    }

    
    //    NSData *fileData = UIImageJPEGRepresentation(self.headImageView.image,0.01);
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    
    [params safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
    [params safeSetObject:self.nickname forKey:@"nickName"];
    [params safeSetObject:[NSString stringWithFormat:@"%@",self.sex] forKey:@"sex"];
    [params safeSetObject:self.height forKey:@"heigth"];
    [params safeSetObject:self.birthday forKey:@"birthday"];
    [params safeSetObject:self.currWeightlb.text forKey:@"currTargetWeight"];
    [params safeSetObject:self.targetWeightlb.text forKey:@"targetWeight"];

    
    self.currentTasks = [[BaseSservice sharedManager]postImage:@"app/evaluatUser/perfectMainUser.do" paramters:params imageData:self.imageData?self.imageData:nil imageName:@"headimgurl" success:^(NSDictionary *dic) {
        
        NSDictionary * dataDic =[dic safeObjectForKey:@"data"];
        NSString * subId =[NSString stringWithFormat:@"%@",[dataDic safeObjectForKey:@"id"]];
        
        [[UserModel shareInstance]setMainUserInfoWithDic:dataDic];
        
        [[SubUserItem shareInstance]setInfoWithHealthId:subId];
        
        TabbarViewController *tb =[[TabbarViewController alloc]init];
        [UserModel shareInstance].tabbarStyle = @"health";
        self.view.window.rootViewController =tb;
        
        
    } failure:^(NSError *error) {
        
        
        DLog(@"error--%@",error);
    }];
    
    
    
    
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
