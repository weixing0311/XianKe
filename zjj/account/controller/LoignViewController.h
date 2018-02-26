//
//  LoignViewController.h
//  zjj
//
//  Created by iOSdeveloper on 2017/6/11.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "JFABaseTableViewController.h"

@interface LoignViewController : JFABaseTableViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *mobileTf;

@property (weak, nonatomic) IBOutlet UITextField *verTF;
@property (weak, nonatomic) IBOutlet UIButton *verbtn;
@property (weak, nonatomic) IBOutlet UIButton *loignBtn;

@property (weak, nonatomic) IBOutlet UIView *verView;



- (IBAction)didLoign:(id)sender;


- (IBAction)getVer:(id)sender;







@end
