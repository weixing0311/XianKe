//
//  MsgSub3TableViewCell.h
//  zjj
//
//  Created by iOSdeveloper on 2018/7/5.
//  Copyright © 2018年 ZhiJiangjun-iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MsgSub3TableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *BigImageView;
@property (weak, nonatomic) IBOutlet UIView *bgView;


@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *imgBgView;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timelb;






-(void)setInfoWithDict:(NSDictionary * )dict;

@end
