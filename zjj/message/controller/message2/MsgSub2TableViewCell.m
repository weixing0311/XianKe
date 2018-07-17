//
//  MsgSub2TableViewCell.m
//  zjj
//
//  Created by iOSdeveloper on 2018/7/5.
//  Copyright © 2018年 ZhiJiangjun-iOS. All rights reserved.
//

#import "MsgSub2TableViewCell.h"

@implementation MsgSub2TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setInfoWithDict:(NSDictionary * )dict
{
    self.statuslb.text = [dict safeObjectForKey:@"status"];
    self.timelb.text = [dict safeObjectForKey:@"sendTime"];
    
    [self.goodsImg sd_setImageWithURL:[NSURL URLWithString:[dict safeObjectForKey:@"imgUrl"]] placeholderImage:getImage(@"default")];
    
    self.titlelb.text = [dict safeObjectForKey:@"sendcontent"];
    self.wlNumlb.text = [NSString stringWithFormat:@"物流单号：%@",[dict safeObjectForKey:@"logisticsNo"]];

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
