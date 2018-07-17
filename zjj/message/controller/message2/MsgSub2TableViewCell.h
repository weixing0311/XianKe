//
//  MsgSub2TableViewCell.h
//  zjj
//
//  Created by iOSdeveloper on 2018/7/5.
//  Copyright © 2018年 ZhiJiangjun-iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MsgSub2TableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *goodsImg;
@property (weak, nonatomic) IBOutlet UILabel *timelb;
@property (weak, nonatomic) IBOutlet UILabel *statuslb;
@property (weak, nonatomic) IBOutlet UILabel *titlelb;
-(void)setInfoWithDict:(NSDictionary * )dict;
@property (weak, nonatomic) IBOutlet UILabel *wlNumlb;

@end
