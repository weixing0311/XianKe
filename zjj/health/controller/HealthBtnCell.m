//
//  HealthBtnCell.m
//  zjj
//
//  Created by iOSdeveloper on 2018/4/19.
//  Copyright © 2018年 ZhiJiangjun-iOS. All rights reserved.
//

#import "HealthBtnCell.h"

@implementation HealthBtnCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)didClickOne:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTapOne)]) {
        [self.delegate didTapOne];
    }
}
- (IBAction)didClickTwo:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTapTwo)]) {
        [self.delegate didTapTwo];
    }

}
- (IBAction)didClickThree:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTapThree)]) {
        [self.delegate didTapThree];
    }

}
- (IBAction)didClickfour:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTapFour)]) {
        [self.delegate didTapFour];
    }

}
- (IBAction)didClickFive:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTapFive)]) {
        [self.delegate didTapFive];
    }

}
- (IBAction)didClickSix:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTapSix)]) {
        [self.delegate didTapSix];
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
