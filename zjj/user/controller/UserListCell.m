//
//  UserListCell.m
//  zjj
//
//  Created by iOSdeveloper on 2017/9/22.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "UserListCell.h"

@implementation UserListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)didClickGz:(id)sender {
    if (self.delegate &&[self.delegate respondsToSelector:@selector(didClickGzBtnWithCell:)]) {
        [self.delegate didClickGzBtnWithCell:self];
    }
}
@end