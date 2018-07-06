//
//  JFABaseTableViewController.m
//  zhijiangjun
//
//  Created by iOSdeveloper on 2017/6/11.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "JFABaseTableViewController.h"
#import "BaseSservice.h"
#import "JFASubNetWorkErrorView.h"
#import "LoignViewController.h"
#import "MJRefresh.h"
@interface JFABaseTableViewController ()
{
    NSTimer * hiddenErrorTimer;
    UILabel * errorLabel;
    CGRect oldframe;
    UIView * bigImageBgView;
}
@end

@implementation JFABaseTableViewController

@synthesize requestArray=_requestArray;
@synthesize loadingView=_loadingView;
@synthesize errorView=_errorView;
@synthesize networkErrorView=_networkErrorView;


-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.currentTasks cancel];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIBarButtonItem appearance]backButtonTitlePositionAdjustmentForBarMetrics: UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(doloign) name:kdidReLoign object:nil];
    // Do any additional setup after loading the view.
//    if(([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
//    {
//        self.edgesForExtendedLayout= UIRectEdgeNone;
//        [self.navigationController.navigationBar setBarTintColor:[UIColor colorForHex:@"ffffff"]];
//    }else{
//
//        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation_background"] forBarMetrics:UIBarMetricsDefault];
//    }
    [self emptyView];
    if (!self.requestArray) {
        self.requestArray=[[NSMutableArray alloc] initWithCapacity:0];
    }

}
-(EmptyView *)emptyView
{
    if (!_emptyView) {
        _emptyView = [self getXibCellWithTitle:@"EmptyView"];
        _emptyView.hidden = YES;
        _emptyView.frame = self.view.bounds;
        _emptyView.backgroundColor =HEXCOLOR(0xeeeeee);
        [_emptyView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapEmptyView)]];
        [self.view addSubview:_emptyView];
    }
    return _emptyView;
}

-(void)showEmptyViewWithTitle:(NSString *)title
{
    _emptyView.hidden =NO;
    _emptyView.titleLabel.text = title;
    [self.view bringSubviewToFront:_emptyView];
}
-(void)hiddenEmptyView
{
    _emptyView.hidden =YES;
}

-(WXProgressView *)wxprsView
{
    if (!_wxprsView) {
        _wxprsView = [self getXibCellWithTitle:@"WXProgressView"];
        _wxprsView.hidden = YES;
        _wxprsView.frame = self.view.bounds;
        [self.view addSubview:_wxprsView];
    }
    return _wxprsView;
    
}

-(void)showWXProgressViewWithTitle:(NSString *)title integral:(int)integral
{
    if (!_wxprsView) {
        [self wxprsView];
    }
    _wxprsView.hidden = NO;
    _wxprsView.titlelb.text = title;
    _wxprsView.integrallb.text = [NSString stringWithFormat:@"+%d",integral];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        _wxprsView.hidden = YES;
    });
}

-(void)didCompleteTheTaskWithId:(NSString *)taskId
{
    
    NSString * successMsg = @"";
    
    if ([taskId isEqualToString:@"1"]) {
        successMsg = @"签到成功";
    }
    else if([taskId isEqualToString:@"2"])
    {
        successMsg = @"点赞成功";

    }
    else if([taskId isEqualToString:@"3"])
    {
        successMsg = @"称重成功";

    }
    else if([taskId isEqualToString:@"4"])
    {
        successMsg = @"评论成功";

    }
    else if([taskId isEqualToString:@"5"])
    {
        successMsg = @"分享文章成功";

    }
    else if([taskId isEqualToString:@"6"])
    {
        successMsg = @"发表文章成功";

    }
    else if([taskId isEqualToString:@"7"])
    {
        successMsg = @"分享个人主页成功";

    }
    else if([taskId isEqualToString:@"8"])
    {
        successMsg = @"分享健康报告成功";

    }
    else if([taskId isEqualToString:@"9"])
    {
        successMsg = @"分享减脂前照片成功";

    }
    else if([taskId isEqualToString:@"10"])
    {
        successMsg = @"分享减脂后照片成功";

    }
    else if([taskId isEqualToString:@"11"])
    {
        successMsg = @"文章置顶成功";
    }
    if (!taskId) {
        return;
    }

    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params setObject:taskId forKey:@"taskId"];
    [params safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
    
    [[BaseSservice sharedManager]post1:@"app/integral/growthsystem/gainPoints.do" HiddenProgress:YES paramters:params success:^(NSDictionary *dic) {
        
        NSDictionary * dataDict =[dic safeObjectForKey:@"data"];
            [self showWXProgressViewWithTitle:successMsg integral:[[dataDict safeObjectForKey:@"integral"]intValue]];
        
    } failure:^(NSError *error) {
        
    }];
}


-(void)setNbColor
{
    self.navigationController.navigationBar.barTintColor = HEXCOLOR(0xfb0628);
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];

}
-(void)setTBRedColor
{
    self.navigationController.navigationBar.barTintColor = HEXCOLOR(0xfb0628);
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [[UIBarButtonItem appearance]setBackButtonBackgroundVerticalPositionAdjustment:17 forBarMetrics:UIBarMetricsDefault];

}
-(void)setTBWhiteColor
{
    self.navigationController.navigationBar.barTintColor = HEXCOLOR(0XFFFFFF);
    self.navigationController.navigationBar.tintColor=[UIColor blackColor];

    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    [[UIBarButtonItem appearance]setBackButtonBackgroundVerticalPositionAdjustment:17 forBarMetrics:UIBarMetricsDefault];
//    [[UIBarButtonItem appearance]setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];

}
-(void)doloign
{
    
    UIAlertController *al = [UIAlertController alertControllerWithTitle:@"提示" message:@"登录失效，请重新登录" preferredStyle:UIAlertControllerStyleAlert];
    [al addAction:[UIAlertAction actionWithTitle:@"重新登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        LoignViewController *lo = [[LoignViewController alloc]init];
        self.view.window.rootViewController =lo;
 
    }]];
    [self presentViewController:al animated:YES completion:nil];
}
-(void)refreshForNetworkError
{
    [self startService];
}




#pragma mark-NetService

-(void)loadNewData
{
    [self startService];
}

-(JFANetWorkServiceItem*)getServiceItem
{
    return nil;
}

-(void)startService
{
    [self startServiceWithItem:[self getServiceItem] isShowLoading:NO];
}



-(void)serviceSucceededWithResult:(id)result operation:(NSURLSessionTask*)operation
{
    
}

-(void)serviceFailedWithError:(NSError*)error operation:(NSURLSessionTask*)operation
{
    [self showNetworkError];
}

-(BOOL)isEqualUrl:(NSString*)url forOperation:(NSURLSessionTask*)operation
{
    NSString* operationUrl = [operation.originalRequest.URL absoluteString];
    NSString* eUrl=[NSString stringWithFormat:@"%@%@",[BaseSservice sharedManager].JFADomin,url];
    DLog(@"eUrl==%@  operationUrl==%@",eUrl,operationUrl);
    //    return [eUrl isEqualToString:operationUrl];
    
    if ([operationUrl rangeOfString:eUrl].location != NSNotFound) {
        return YES;
    }
    return NO;
}

-(void)showNetworkError
{
    self.errorView.hidden=YES;
    self.networkErrorView.hidden=NO;
}

-(void)showError
{
    if (_errorView) {
        self.errorView.hidden=NO;
        self.networkErrorView.hidden=YES;
    }
}

-(void)didRefreshInfo
{
    [self BrokenNetworkReconnection];
}
-(void)BrokenNetworkReconnection
{
    DLog(@"看你走不走----断网刷新");
    self.networkErrorView.hidden = YES;
}



-(id)getXibCellWithTitle:(NSString *)title
{
    NSArray *arr = [[NSBundle mainBundle]loadNibNamed:title owner:nil options:nil];
    if (arr) {
        return [arr lastObject];

    }else{
        return nil;
    }
}

-(void)setExtraCellLineHiddenWithTb:(UITableView *)tb
{
    UIView *view =[[UIView alloc]init];
    view.backgroundColor = HEXCOLOR(0xeeeeee);
    [tb setTableFooterView:view];
}

-(void)dealloc
{
    [self.currentTasks cancel];
}

-(void)setRefrshWithTableView:(UITableView *)tb
{
    
    tb.mj_header =  [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    
    tb.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
    [tb.mj_header beginRefreshing];

}
-(void)headerRereshing
{
    
}
-(void)footerRereshing
{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)showError:(NSString *)text;
{
    errorLabel  = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 40)];
    errorLabel.backgroundColor = RGBACOLOR(0/225.0f, 0/225.0f, 0/225.0f, .5);
    errorLabel.adjustsFontSizeToFitWidth = YES;
    errorLabel.center = self.view.window.center;
    errorLabel.textColor = [UIColor whiteColor];
    errorLabel.layer.masksToBounds = YES;
    errorLabel.layer.cornerRadius =4;
    errorLabel.text = text;
    errorLabel.textAlignment = NSTextAlignmentCenter;
    [self.view.window addSubview:errorLabel];
    hiddenErrorTimer =   [NSTimer timerWithTimeInterval:2 target:self selector:@selector(hiddenErrirLabel) userInfo:nil repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:hiddenErrorTimer forMode:NSRunLoopCommonModes];

}


-(void)hiddenErrirLabel
{
    errorLabel.hidden = YES;
    [errorLabel removeFromSuperview];
    [hiddenErrorTimer invalidate];
}


-(void)ChangeMySegmentStyle:(UISegmentedControl*)segment
{
    segment.backgroundColor = [UIColor whiteColor];
    [segment setTintColor:[UIColor whiteColor]];
    [segment setBackgroundImage:[UIImage imageNamed:@"selectImg"]
                            forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor redColor],NSForegroundColorAttributeName,nil];
    
    NSDictionary *dics = [NSDictionary dictionaryWithObjectsAndKeys:HEXCOLOR(0x666666),NSForegroundColorAttributeName,nil];
    [segment setTitleTextAttributes:dics forState:UIControlStateNormal];
    [segment setTitleTextAttributes:dic forState:UIControlStateSelected];
    

}



-(NSString*)DataTOjsonString:(id)object
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:0
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

-(void)refreshEmptyView
{
    
}
-(void)didTapEmptyView
{
    [self refreshEmptyView];
}


-(void)showBigImageWithArray:(NSArray *)imgArray imageView:(UIImageView*)currentImageview index:(NSInteger)index
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    //  背景
    
    oldframe = [currentImageview convertRect:currentImageview.bounds toView:window];

    
    bigImageBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    //  当前imageview的原始尺寸->将像素currentImageview.bounds由currentImageview.bounds所在视图转换到目标视图window中，返回在目标视图window中的像素值
    
    UIScrollView *scr = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, JFA_SCREEN_WIDTH, JFA_SCREEN_HEIGHT)];
    scr.backgroundColor = [UIColor redColor];
    scr.contentSize = CGSizeMake(JFA_SCREEN_WIDTH*imgArray.count, 0);
    scr.contentOffset = CGPointMake(JFA_SCREEN_WIDTH*index, 0);
    scr.pagingEnabled = YES;
    [bigImageBgView addSubview:scr];
    for (int i =0; i<imgArray.count; i++) {
        
        id currImage = imgArray[i];
        if (![currImage isKindOfClass:[NSString class]]) {
            currImage = [currImage objectForKey:@"imgUrl"];
        }

        UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(i*JFA_SCREEN_WIDTH, 0, JFA_SCREEN_WIDTH, JFA_SCREEN_HEIGHT)];
//        scrollView.backgroundColor = [UIColor clearColor];
        [scr addSubview:scrollView];
        
        CGRect rect;
        
        if (i ==index) {
            rect = oldframe;
        }else{
            rect = CGRectZero;
        }
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:rect];
        [scrollView addSubview:imageView];
        imageView.contentMode =UIViewContentModeScaleAspectFit;
        [imageView setAlpha:1];
        NSString *encodedString = (NSString *)
        
        CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                  
                                                                  (CFStringRef)currImage,
                                                                  
                                                                  (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                                                  
                                                                  NULL,
                                                                  
                                                                  kCFStringEncodingUTF8));
        
        [self loadImageWithScr:scr ImageView:imageView Url:encodedString];

    }
    
    
    
    
    
    
    
    
    [bigImageBgView setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.5]];
    
    //  此时视图不会显示
//    [backgroundView setAlpha:0];
    //  将所展示的imageView重新绘制在Window中
    [window addSubview:bigImageBgView];
    
    
    //  添加点击事件同样是类方法 -> 作用是再次点击回到初始大小
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideImageView:)];
    [bigImageBgView addGestureRecognizer:tapGestureRecognizer];
    
    
}
/**
 *  恢复imageView原始尺寸
 *
 *  @param tap 点击事件
 */
-(void)hideImageView:(UITapGestureRecognizer *)tap{
    
    //  恢复
    [UIView animateWithDuration:0.4 animations:^{
        [bigImageBgView setAlpha:0];
    } completion:^(BOOL finished) {
        //完成后操作->将背景视图删掉
        [bigImageBgView removeFromSuperview];
    }];
}

-(void)loadImageWithScr:(UIScrollView*)scr ImageView:(UIImageView *)imageView Url:(NSString *)imageUrl
{
    UIImage *cachedImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:imageUrl];
    
    if ( !cachedImage ) {
        imageView.image = getImage(@"default");
        [self downloadImageWithScr:scr ImageView:imageView Url:imageUrl];
    } else {
        imageView.image = cachedImage;
        //  动画放大所展示的ImageView
        [UIView animateWithDuration:0.4 animations:^{
            CGFloat y,width,height;
            y = (JFA_SCREEN_HEIGHT - cachedImage.size.height * JFA_SCREEN_WIDTH / cachedImage.size.width) * 0.5;
            //宽度为屏幕宽度
            width = [UIScreen mainScreen].bounds.size.width;
            //高度 根据图片宽高比设置
            height = cachedImage.size.height * JFA_SCREEN_WIDTH / cachedImage.size.width;
            [imageView setFrame:CGRectMake(0, y, width, height)];
            //重要！ 将视图显示出来
            
        } completion:^(BOOL finished) {
            
        }];

        
        
        
//        float imageHeight = JFA_SCREEN_WIDTH * cachedImage.size.height/cachedImage.size.width ;
//        imageView.image = cachedImage;
//        imageView.frame =CGRectMake(0, 0, JFA_SCREEN_WIDTH-10, imageHeight);
//        scr.contentSize = CGSizeMake(JFA_SCREEN_WIDTH, imageHeight);
//        imageView.center = CGPointMake(JFA_SCREEN_WIDTH/2, scr.center.y);
        
    }
}

- (void)downloadImageWithScr:(UIScrollView*)scr ImageView:(UIImageView *)imageView Url:(NSString *)imageUrl {
    // 利用 SDWebImage 框架提供的功能下载图片
    [[SDWebImageDownloader sharedDownloader]downloadImageWithURL:[NSURL URLWithString:imageUrl] options:SDWebImageDownloaderUseNSURLCache progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
        if (error) {
            imageView.image = getImage(@"default");
            return ;
        }
        [[SDImageCache sharedImageCache]storeImage:image forKey:imageUrl completion:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            imageView.image = image;
            
            [UIView animateWithDuration:0.4 animations:^{
                CGFloat y,width,height;
                y = (JFA_SCREEN_HEIGHT - image.size.height * JFA_SCREEN_WIDTH / image.size.width) * 0.5;
                //宽度为屏幕宽度
                width = [UIScreen mainScreen].bounds.size.width;
                //高度 根据图片宽高比设置
                height = image.size.height * JFA_SCREEN_WIDTH / image.size.width;
                [imageView setFrame:CGRectMake(0, y, width, height)];
                //重要！ 将视图显示出来
                [imageView setAlpha:1];
            } completion:^(BOOL finished) {
                
            }];

            
            
            
//            float imageHeight = JFA_SCREEN_WIDTH * image.size.height/image.size.width ;
//            imageView.frame =CGRectMake(0, 0, JFA_SCREEN_WIDTH-10, imageHeight);
//            scr.contentSize = CGSizeMake(JFA_SCREEN_WIDTH, imageHeight);
//
//            if (imageHeight>JFA_SCREEN_HEIGHT) {
//                imageView.center = CGPointMake(JFA_SCREEN_WIDTH/2, scr.contentSize.height/2);
//            }else{
//                imageView.center = CGPointMake(JFA_SCREEN_WIDTH/2, JFA_SCREEN_HEIGHT/2);
//
//            }
            
            
        });
    }];
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
