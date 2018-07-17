//
//  InvitationFriendsViewController.m
//  zjj
//
//  Created by iOSdeveloper on 2018/2/26.
//  Copyright © 2018年 ZhiJiangjun-iOS. All rights reserved.
//

#import "InvitationFriendsViewController.h"

@interface InvitationFriendsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIView *shareView;

@property (weak, nonatomic) IBOutlet UIImageView *recodeImageView;
@end

@implementation InvitationFriendsViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];

    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.recodeImageView.layer.borderWidth = 1;
    self.recodeImageView.layer.borderColor = HEXCOLOR(0x2bf276).CGColor;
    [self.recodeImageView sd_setImageWithURL:[NSURL URLWithString:[UserModel shareInstance].qrcodeImageUrl] placeholderImage:getImage(@"shareQRCode")];
    self.recodeImageView.frame = CGRectMake(JFA_SCREEN_WIDTH-150, self.bgImageView.frame.size.height/2-30, 80, 80);
    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:[UserModel shareInstance].backgroundUrl ] placeholderImage:getImage(@"invitationFriendBg_")];

    // Do any additional setup after loading the view from its nib.
}
- (IBAction)didBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)didShare:(id)sender {
    [self didShareUrl];
//    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
//    pasteboard.string = [NSString stringWithFormat:@"%@", [UserModel shareInstance].linkerUrl];
//
//    [[UserModel shareInstance]showSuccessWithStatus:@"链接已复制到剪切板"];


}
- (IBAction)didShareCode:(id)sender {
    
    [self didShareWithimage:[self getImageWithView:self.shareView]];
}
#pragma mark -----分享
-(void)didShareWithimage:(UIImage * )image
{
    
    UIAlertController * al = [UIAlertController alertControllerWithTitle:@"分享" message:@"选择要分享到的平台" preferredStyle:UIAlertControllerStyleActionSheet];
    [al addAction:[UIAlertAction actionWithTitle:@"微信好友" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self shareWithType:SSDKPlatformSubTypeWechatSession image:image];
    }]];
    [al addAction:[UIAlertAction actionWithTitle:@"微信朋友圈" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self shareWithType:SSDKPlatformSubTypeWechatTimeline image:image];
        
    }]];
    [al addAction:[UIAlertAction actionWithTitle:@"QQ" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self shareWithType:SSDKPlatformTypeQQ image:image];
        
    }]];
    [al addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:al animated:YES completion:nil];
    
}

//分享链接
-(void)didShareUrl
{
    
    UIAlertController * al =[UIAlertController alertControllerWithTitle:@"分享" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    [al addAction:[UIAlertAction actionWithTitle:@"微信朋友圈" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self shareWithType:SSDKPlatformSubTypeWechatTimeline ];
        
    }]];
    [al addAction:[UIAlertAction actionWithTitle:@"微信好友" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self shareWithType:SSDKPlatformSubTypeWechatSession ];
        
    }]];
    [al addAction:[UIAlertAction actionWithTitle:@"QQ好友" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self shareWithType:SSDKPlatformTypeQQ ];
        
    }]];
    [al addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    
    [self presentViewController:al animated:YES completion:nil];

}






#pragma mark ----share
-(void) shareWithType:(SSDKPlatformType)type image:(UIImage * )image
{
    
    if (!image) {
        return;
    }
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSArray* imageArray = @[image];
    
    [shareParams SSDKSetupShareParamsByText:nil
                                     images:imageArray
                                        url:nil
                                      title:nil
                                       type:SSDKContentTypeImage];
    
    [shareParams SSDKEnableUseClientShare];
    [SVProgressHUD showWithStatus:@"开始分享"];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    
    
    //进行分享
    [ShareSDK share:type
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
         
         
         switch (state) {
             case SSDKResponseStateSuccess:
             {
                 [SVProgressHUD dismiss];

                 [[UserModel shareInstance]dismiss];
                 //                 [[UserModel shareInstance] showSuccessWithStatus:@"分享成功"];
                 break;
             }
             case SSDKResponseStateFail:
             {
                 [SVProgressHUD dismiss];

                 [[UserModel shareInstance]dismiss];
                 //                 [[UserModel shareInstance] showErrorWithStatus:@"分享失败"];
                 break;
             }
             case SSDKResponseStateCancel:
             {
                 [SVProgressHUD dismiss];

                 [[UserModel shareInstance]dismiss];
                 //                 [[UserModel shareInstance] showInfoWithStatus:@"取消分享"];
                 break;
             }
             default:
                 break;
         }
     }];
}


#pragma mark ----share
-(void) shareWithType:(SSDKPlatformType)type
{
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    
    if (type ==SSDKPlatformSubTypeWechatTimeline||type==SSDKPlatformSubTypeWechatSession) {
        [shareParams SSDKSetupWeChatParamsByText:@"纤客，遇见更好的自己" title:@"好友邀请" url:[NSURL URLWithString:[UserModel shareInstance].linkerUrl] thumbImage:getImage(@"logo") image:nil musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeWebPage forPlatformSubType:type];
        
    }else if (type==SSDKPlatformTypeQQ)
    {
        [shareParams SSDKSetupShareParamsByText:@"纤客，遇见更好的自己"
                                         images:getImage(@"logo")
                                            url:[NSURL URLWithString:[UserModel shareInstance].linkerUrl]
                                          title:@"好友邀请"
                                           type:SSDKContentTypeWebPage];
        
        //        [shareParams SSDKSetupQQParamsByText:self.contentStr title:self.titleStr url:[NSURL URLWithString:self.urlStr] thumbImage:_imageUrl image:nil type:SSDKContentTypeWebPage forPlatformSubType:type];
    }
    
    
    
    [shareParams SSDKEnableUseClientShare];
    [SVProgressHUD showWithStatus:@"开始分享"];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    
    
    //进行分享
    [ShareSDK share:type
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
         
         
         switch (state) {
             case SSDKResponseStateSuccess:
             {
                 [SVProgressHUD dismiss];
                 [[UserModel shareInstance]dismiss];
                 //                 [[UserModel shareInstance] showSuccessWithStatus:@"分享成功"];
                 break;
             }
             case SSDKResponseStateFail:
             {
                 [SVProgressHUD dismiss];

                 [[UserModel shareInstance]dismiss];
                 //                 [[UserModel shareInstance] showErrorWithStatus:@"分享失败"];
                 DLog(@"error-%@",error);
                 break;
             }
             case SSDKResponseStateCancel:
             {
                 [SVProgressHUD dismiss];

                 [[UserModel shareInstance]dismiss];
                 //                 [[UserModel shareInstance] showInfoWithStatus:@"取消分享"];
                 break;
             }
             default:
                 break;
         }
     }];
    
}

-(UIImage *)getImageWithView:(UIView*)view
{
    UIGraphicsBeginImageContext(view.bounds.size);     //currentView 当前的view  创建一个基于位图的图形上下文并指定大小为
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];//renderInContext呈现接受者及其子范围到指定的上下文
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();//返回一个基于当前图形上下文的图片
    UIGraphicsEndImageContext();//移除栈顶的基于当前位图的图形上下文
    //    UIImageWriteToSavedPhotosAlbum(viewImage, nil, nil, nil);//然后将该图片保存到图片图
//    [view removeFromSuperview];
    return viewImage;
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
