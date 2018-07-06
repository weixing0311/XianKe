//
//  RefundTheDepositViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2018/5/18.
//  Copyright © 2018年 ZhiJiangjun-iOS. All rights reserved.
//

#import "RefundTheDepositViewController.h"

@interface RefundTheDepositViewController ()<UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *titlelb;
@property (weak, nonatomic) IBOutlet UITextField *numlb;
@property (strong, nonatomic) UIPickerView * pickerView;
@property (nonatomic,strong)NSMutableArray * dataArray;
@end

@implementation RefundTheDepositViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"退押金";
    self.numlb.delegate = self;
    [self setTBWhiteColor];
    [self buildPickerView];
    [self getLogist];
    // Do any additional setup after loading the view from its nib.
}


-(void)getLogist
{
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/ordertrail/logisticsCompanyList.do" HiddenProgress:NO paramters:nil success:^(NSDictionary *dic) {
        
        
        self.dataArray = [[dic safeObjectForKey:@"data"]safeObjectForKey:@"array"];
        [self.pickerView reloadAllComponents];
        
    } failure:^(NSError *error) {
        
    }];

}
- (IBAction)didUpdata:(id)sender {
    
    if (self.titlelb.text.length<3) {
        [[UserModel shareInstance]showInfoWithStatus:@"请输入快递公司名称"];
        return;
    }
    if (self.numlb.text.length<3) {
        [[UserModel shareInstance]showInfoWithStatus:@"请输入快递单号"];
        return;
    }
    NSInteger row=[self.pickerView selectedRowInComponent:0];

    NSString * idStr = self.dataArray[row][@"id"];
    
    NSMutableDictionary * params =[NSMutableDictionary dictionary];
    [params safeSetObject:idStr forKey:@"logisticsId"];
    [params safeSetObject:self.numlb.text forKey:@"logisticsNo"];
    [params safeSetObject:self.orderNo forKey:@"orderNo"];
    
    
    
    self.currentTasks = [[BaseSservice sharedManager]post1:@"app/ordertrail/refundDepositApply.do" HiddenProgress:NO paramters:params success:^(NSDictionary *dic) {
        [[UserModel shareInstance]showSuccessWithStatus:@"已成功发起退款"];
        
        
        dispatch_after(1, dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
        
    } failure:^(NSError *error) {
        
    }];
    
}
-(void)buildPickerView
{
    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0,0, 375, 49)];
    
    UIBarButtonItem * barFit =[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *bar2 = [[UIBarButtonItem alloc]
                             initWithTitle:@"完成"style:UIBarButtonItemStylePlain target:self action:@selector(didChooseCity)];
    UIBarButtonItem *bar1 = [[UIBarButtonItem alloc]
                             initWithTitle:@"取消"style:UIBarButtonItemStylePlain target:self action:@selector(cancelChooseCity)];
    
    //    4.加一个固定的长度作为弹簧效果
    //    5.将设置的按钮加到toolBar上
    toolBar.items =@[bar1,barFit,bar2];
    //    6.将toolBar加到text的输入框也就是UiDatePicker上
    
    
    self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 200)];
    
    // 代理
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    
    
    self.titlelb.inputView = self.pickerView;
    self.titlelb.inputAccessoryView = toolBar;
    self.titlelb.delegate = self;

}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
//    return self.dataArray.count;
    return 5;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    return self.dataArray[row][@"logisticsName"];
    
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:15]];
    }
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}
- (void)didChooseCity {
    NSInteger row=[self.pickerView selectedRowInComponent:0];
    
    self.titlelb.text = self.dataArray[row][@"logisticsName"];
    [self.titlelb resignFirstResponder];
}
-(void)cancelChooseCity
{
    [self.titlelb resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isKindOfClass:[self.numlb class]]) {
        [self didUpdata:nil];
        [self.numlb resignFirstResponder];
//        [self.navigationController popViewControllerAnimated:YES];
    }
    return YES;
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
