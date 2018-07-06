//
//  NewHealthDetailSevenCell.h
//  zjj
//
//  Created by iOSdeveloper on 2018/4/20.
//  Copyright © 2018年 ZhiJiangjun-iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewHealthDetailSevenCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *midBgView;
@property (weak, nonatomic) IBOutlet UILabel *weightlb;
@property (weak, nonatomic) IBOutlet UILabel *bmilb;
@property (weak, nonatomic) IBOutlet UILabel *healthIndexlb;
@property (weak, nonatomic) IBOutlet UILabel *lesslb;
@property (weak, nonatomic) IBOutlet UIImageView *stateImageView;
-(void)setInfoWithItem:(HealthDetailsItem *)item;
@end
