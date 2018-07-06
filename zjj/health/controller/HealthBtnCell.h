//
//  HealthBtnCell.h
//  zjj
//
//  Created by iOSdeveloper on 2018/4/19.
//  Copyright © 2018年 ZhiJiangjun-iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HealthBtnCellDelegate;

@interface HealthBtnCell : UITableViewCell
@property (nonatomic,assign)id<HealthBtnCellDelegate>delegate;
@property (weak, nonatomic) IBOutlet UILabel *targetWeightlb;

@end
@protocol HealthBtnCellDelegate <NSObject>

-(void)didTapOne;
-(void)didTapTwo;
-(void)didTapThree;
-(void)didTapFour;
-(void)didTapFive;
-(void)didTapSix;
@end
