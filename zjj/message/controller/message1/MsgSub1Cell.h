//
//  MsgSub1Cell.h
//  zjj
//
//  Created by iOSdeveloper on 2018/7/5.
//  Copyright © 2018年 ZhiJiangjun-iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MsgSub1Cell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bigImageView;
@property (weak, nonatomic) IBOutlet UILabel *titlelb;
@property (weak, nonatomic) IBOutlet UILabel *contentlb;
@property (weak, nonatomic) IBOutlet UILabel *timelb;
-(void)setInfoWithDict:(NSDictionary * )dict;

@end
