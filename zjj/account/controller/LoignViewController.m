//
//  LoignViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2017/6/11.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "LoignViewController.h"
#import "TabbarViewController.h"
#import "ResignAgumentViewController.h"
#import "ADDChengUserViewController.h"
#import "JPUSHService.h"
@interface LoignViewController ()

@end

@implementation LoignViewController
{
    BOOL isupView;
    NSTimer * _timer;
    NSInteger timeNumber;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self bgViewDown];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showkeyboard) name:UIKeyboardWillShowNotification object:nil];
    
    isupView = YES;
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenKeyBoard)]];
    
    
    self.mobileTf.delegate = self;
    self.mobileTf.returnKeyType = UIReturnKeyGo;
    self.mobileTf.clearButtonMode=UITextFieldViewModeAlways;

    self.mobileTf.keyboardType = UIKeyboardTypeNumberPad;
    [self.mobileTf addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

    self.verTF.delegate = self;
    self.verTF.keyboardType = UIKeyboardTypeNumberPad;
    self.verTF.returnKeyType = UIReturnKeyGo;
    [self.verTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    self.verbtn.layer.borderColor = HEXCOLOR(0x999999).CGColor;
    self.verbtn.layer.borderWidth = 1;
    [self.verbtn setTitleColor:HEXCOLOR(0x999999) forState:UIControlStateNormal];


    
}
-(void)changVerBtnColorWithType:(int)type
{
    if (type==1&&self.mobileTf.text.length==11) {
        self.verbtn.layer.borderColor = HEXCOLOR(0x44d700).CGColor;
        [self.verbtn setTitleColor:HEXCOLOR(0x44d700) forState:UIControlStateNormal];

    }else{
        self.verbtn.layer.borderColor = HEXCOLOR(0xbfbfbf).CGColor;
        [self.verbtn setTitleColor:HEXCOLOR(0xbfbfbf) forState:UIControlStateNormal];

    }
}



-(void)hiddenKeyBoard
{
//    [self changVerBtnColorWithType:1];
    [self.mobileTf resignFirstResponder];
    [self.verTF resignFirstResponder];
//    [self bgViewDown];
}


-(void)loignWithVer
{
    [self bgViewDown];
    
    if ([self.mobileTf.text isEqualToString:@""]||[self.mobileTf.text isEqualToString:@" "]||!self.mobileTf.text) {
        [[UserModel shareInstance] showInfoWithStatus:@"请输入手机号"];
        return;
    }
    if ([self.verTF.text isEqualToString:@""]||[self.verTF.text isEqualToString:@" "]||!self.verTF.text) {
        [[UserModel shareInstance] showInfoWithStatus:@"请输入验证码"];
        
        return;
    }
    [SVProgressHUD showWithStatus:@"登录中。。。"];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];

    NSMutableDictionary *param =[ NSMutableDictionary dictionary];
    [param setObject:[NSString encryptString:self.mobileTf.text] forKey:@"mobilePhone"];
    [param setObject:self.verTF.text forKey:@"vcode"];
    DLog(@"param--%@",param);
    self.currentTasks = [[BaseSservice sharedManager]post1:kLoignWithVerUrl HiddenProgress:NO paramters:param success:^(NSDictionary *dic) {
        [SVProgressHUD dismiss];
        [[UserModel shareInstance] showSuccessWithStatus:@"登录成功"];
        
        
        [_timer invalidate];
        [self.verbtn setTitle:@"验证码" forState:UIControlStateNormal];
        self.verbtn.enabled = YES;
        
        
        
        [[UserModel shareInstance]setInfoWithDic:[dic objectForKey:@"data"]];
        [[NSUserDefaults standardUserDefaults]setObject:[[dic objectForKey:@"data"]objectForKey:@"userId"] forKey:kMyloignInfo];
        
        
        
        if ([UserModel shareInstance].nickName.length>0) {
            
            TabbarViewController *tab = [[TabbarViewController alloc]init];
            [UserModel shareInstance].tabbarStyle = @"health";
            self.view.window.rootViewController = tab;
            
        }else{
            ADDChengUserViewController *cg =[[ADDChengUserViewController alloc]init];
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:cg];
            cg.isResignUser =YES;
            [self presentViewController:nav animated:YES completion:nil];
        }
        
        
        
    } failure:^(NSError *error) {
        
//        [[UserModel shareInstance] showErrorWithStatus:@"登录失败"];
        [_timer invalidate];
        [self.verbtn setTitle:@"验证码" forState:UIControlStateNormal];
        self.verbtn.enabled = YES;
        
    }];

}

- (IBAction)didLoign:(id)sender {
    
    DLog(@"点击登录");
    [self loignWithVer];
}
-(void)clearTextField
{
    self.mobileTf.text = @"";
    self.verTF.text =@"";
}



- (IBAction)getVer:(UIButton *)sender {
    if (self.mobileTf.text.length!=11) {
        [[UserModel shareInstance]showInfoWithStatus:@"请输入手机号"];
        return;
    }
    [self changVerBtnColorWithType:2];
    timeNumber = 119;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refreshTime) userInfo:nil repeats:YES];
    self.verbtn.enabled = NO;
    
    NSMutableDictionary *param =[ NSMutableDictionary dictionary];
    [param setObject:self.mobileTf.text forKey:@"mobilePhone"];
    [param setObject:@"2" forKey:@"msgType"];
    
    self.currentTasks = [[BaseSservice sharedManager]post1:kSendMobileVerUrl HiddenProgress:NO paramters:param success:^(NSDictionary *dic) {
        
        NSDictionary *dict = dic;
        NSString * status = [dict objectForKey:@"status"];
        NSString * msg ;
        if (![status isEqualToString:@"success"]) {
            msg =[dic objectForKey:@"message"];
            [_timer invalidate];
            [self.verbtn setTitle:@"验证码" forState:UIControlStateNormal];
            self.verbtn.enabled = YES;
            [self changVerBtnColorWithType:1];

        }else{
            msg = @"已发送";
            [self changVerBtnColorWithType:2];

        }
        DLog(@"%@",msg);
        [[UserModel shareInstance] showSuccessWithStatus:msg];
        
        
    } failure:^(NSError * error) {
        NSLog(@"faile--%@",error);
        [_timer invalidate];
        [self.verbtn setTitle:@"验证码" forState:UIControlStateNormal];
        [self changVerBtnColorWithType:1];

        self.verbtn.enabled = YES;

        NSDictionary *dic = error.userInfo;
        if ([[dic allKeys]containsObject:@"message"]) {
            UIAlertController *al = [UIAlertController alertControllerWithTitle:@"提示" message:[dic objectForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
            
            [al addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            [self presentViewController:al animated:YES completion:nil];
            
        }else{
            [[UserModel shareInstance] showErrorWithStatus:@"发送失败"];
        }

    }];

    DLog(@"获取验证码");
}

-(void)refreshTime
{
    if (timeNumber ==0) {
        [_timer invalidate];
        [self.verbtn setTitle:@"验证码" forState:UIControlStateNormal];
        self.verbtn.enabled = YES;
        return;
    }
    NSLog(@"%ld",(long)timeNumber);
    [self.verbtn setTitle:[NSString stringWithFormat: @"%ld",(long)timeNumber] forState:UIControlStateNormal];
    timeNumber --;
}
- (IBAction)showResignAugement:(id)sender {
    
    DLog(@"点击查看注册协议");
    [self bgViewDown];

    ResignAgumentViewController * res = [[ResignAgumentViewController alloc]init];
    [self.navigationController pushViewController:res animated:YES];
}


-(void)showkeyboard
{
    
//    if (isupView) {
//        isupView = NO;
//        [UIView animateWithDuration:0.25 animations:^{
//            self.bgview.contentOffset = CGPointMake(0, 240);
//        }];
//    }

}

-(void)bgViewDown
{
    return;
    isupView = YES;
    [self.mobileTf resignFirstResponder];
    [self.verTF resignFirstResponder];

}
-(void)textFieldDidChange:(UITextField *)textField
{
    if (textField == self.verTF) {
        if (textField.text.length >= 4) {
            textField.text = [textField.text substringToIndex:4];
            [self.verTF resignFirstResponder];
        }
    }
    if (textField ==self.mobileTf) {
        if (self.mobileTf.text.length>=11) {
            textField.text = [textField.text substringToIndex:11];

            [self.mobileTf resignFirstResponder];
            [self changVerBtnColorWithType:1];

            
        }
    }
}
//- (BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//    if (textField ==self.mobileTf) {
////        [self.mobileTf resignFirstResponder];
////        [self.verTF becomeFirstResponder];
//    }else if(textField==self.passWordTf){
//        [self.passWordTf resignFirstResponder];
//    }else if (textField ==self.loignMobileTf)
//    {
//        [self.loignMobileTf resignFirstResponder];
//    }
//    return YES;
//}
- (BOOL)isNumText:(NSString *)str{
    NSString * regex        = @"^[0-9]*$";
    NSPredicate * pred      = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch            = [pred evaluateWithObject:str];
    if (isMatch) {
        return YES;
    }else{
        return NO;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if (textField ==self.mobileTf||textField ==self.verTF) {
//        if (textField.text.length==11) {
//            return NO;
//        }
        if ([self isNumText:string]==YES) {
            return YES;
        }else{
            [[UserModel shareInstance]showInfoWithStatus:@"请输入数字"];
            return NO;
 
        }

    }
    return YES;
    DLog(@"rang-%@",NSStringFromRange(range));
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
