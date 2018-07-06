//
//  WaBaoJlCell.h
//  zjj
//
//  Created by iOSdeveloper on 2018/5/16.
//  Copyright © 2018年 ZhiJiangjun-iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol wabaojldelegate;
@interface WaBaoJlCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;
@property (weak, nonatomic) IBOutlet UIView *memberView;
@property (weak, nonatomic) IBOutlet UILabel *periodCountlb;
@property (weak, nonatomic) IBOutlet UILabel *titlelb;
@property (weak, nonatomic) IBOutlet UILabel *pricelb;
@property (weak, nonatomic) IBOutlet UILabel *wennerNumlb;
@property (weak, nonatomic) IBOutlet UILabel *nicknamelb;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *startTime;
@property (weak, nonatomic) IBOutlet UILabel *endTimelb;
@property (weak, nonatomic) IBOutlet UILabel *countlb;
@property(nonatomic,assign)id<wabaojldelegate>delegate;
@end
@protocol wabaojldelegate<NSObject>
-(void)showMemberWithCell:(WaBaoJlCell*)cell;
@end
