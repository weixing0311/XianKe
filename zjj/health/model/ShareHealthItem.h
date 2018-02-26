//
//  ShareHealthItem.h
//  zjj
//
//  Created by iOSdeveloper on 2017/7/4.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum
{
    IS_BMI,
    IS_VISCERALFAT,///内脂
    IS_FAT,///脂肪
    IS_FATPERCENT,///体脂  fatPercentage
    IS_SAME,///肌肉\骨骼肌\蛋白质\骨重判定标准///骨骼肌
    IS_WATER,
    IS_BODYWEIGHT,///体重判定
    IS_SIZE,///体型
    IS_BMR,
}mytype;
@interface ShareHealthItem : NSObject
+(ShareHealthItem *)shareInstance;

@property (nonatomic,assign)mytype              type;

@property (nonatomic,assign) int                DataId ;//评测数据id
@property (nonatomic,assign) int                userId ;//
@property (nonatomic,assign) int                subUserId ;//
@property (nonatomic,assign) double              score ; //健康得分
@property (nonatomic,assign) double              weight ;// 体重
@property (nonatomic,assign) double              bmr ;// 基础代谢率
@property (nonatomic,assign) int              bmrLevel ;// 基础代谢率

@property (nonatomic,assign) int                bodyAge ;// 身体年龄
@property (nonatomic,assign) double              bmi ;// 体质指数
@property (nonatomic,assign) int                warn ;//
@property (nonatomic,assign) int                normal ;//
@property (nonatomic,assign) int                serious ;//

@property (nonatomic,assign) int                bmiLevel ;//bmi程度

@property (nonatomic,assign) int                visceralFatPercentageLevel ;//内脂判定标准
@property (nonatomic,assign) double              mVisceralFat ;// 内脏脂肪
@property (nonatomic,assign) double              visceralFatPercentage ;//内脏脂肪指数


@property (nonatomic,assign) int                fatWeightLevel ;//脂肪重判定标准
@property (nonatomic,assign) double              fatWeight ;//脂肪重
@property (nonatomic,assign) double              fatWeightMax ;// 脂肪重正常范围上限
@property (nonatomic,assign) double              fatWeightMin ;// 脂肪重正常范围下限


@property (nonatomic,assign) double              mFat ;// 体脂
@property (nonatomic,assign) double              fatPercentage ;// 体脂百分比
@property (nonatomic,assign) double              fatPercentageMax ;// 体脂指数正常范围上限
@property (nonatomic,assign) double              fatPercentageMin ;// 体脂指数正常范围下限
@property (nonatomic,assign) int                fatPercentageLevel ;//体脂百分比判定标准



@property (nonatomic,assign) int                weightLevel ;//体重判定标准
@property (nonatomic,assign) int                bodyLevel ;//体型判定标准



@property (nonatomic,assign) double          mMuscle ;// 肌肉
@property (nonatomic,assign) double              muscleWeight ;// 肌肉重量
@property (nonatomic,assign) int                muscleLevel ;//肌肉判定标准
@property (nonatomic,assign) double              muscleWeightMax ;// 肌肉最大重量
@property (nonatomic,assign) double              muscleWeightMin ;// 肌肉最小重量
@property (nonatomic,copy  ) NSString    *      muscleLevelStr;


@property (nonatomic,assign) double          mBone ;// 骨骼肌
@property (nonatomic,assign) double              boneMuscleWeight ;// 骨骼肌
@property (nonatomic,assign) int                boneMuscleLevel ;//骨骼肌判定标准
@property (nonatomic,assign) double              boneMuscleWeightMax ;// 骨骼肌正常范围上限
@property (nonatomic,assign) double              boneMuscleWeightMin ;// 骨骼肌正常范围下限
@property (nonatomic,copy  ) NSString    *      boneMuscleLevelStr;

@property (nonatomic,assign) double              waterWeight ;// 细胞总水
@property (nonatomic,assign) double              waterWeightMax ;// 细胞总水正常范围上限
@property (nonatomic,assign) double              waterWeightMin ;// 细胞总水正常范围下限
@property (nonatomic,assign) double              mWater ;// 水分
@property (nonatomic,assign) double              waterPercentage ;// 水分率
@property (nonatomic,assign) int                waterLevel ;//水分判定标准

@property (nonatomic,assign) double              proteinWeight ;// 蛋白质重量
@property (nonatomic,assign) double              proteinWeightMax ;// 蛋白质最大重量
@property (nonatomic,assign) double              proteinWeightMin ;// 蛋白质最小重量
@property (nonatomic,assign) int                proteinLevel ;//蛋白质判定标准




@property (nonatomic,assign) double              boneWeight ;// 骨质重
@property (nonatomic,assign) int                boneLevel ;//骨重判定标准
@property (nonatomic,assign) double              boneWeightMax ;// 骨质重正常范围上限
@property (nonatomic,assign) double              boneWeightMin ;// 骨质重正常范围下限



@property (nonatomic,copy  ) NSDate     *     createTime ;//检测时间
@property (nonatomic,assign) double          mCalorie ;// 脂肪量


///蛋白质指数
@property (nonatomic,assign) double              proteinPercentage;
///肌肉指数
@property (nonatomic,assign) double              musclePercentage ;
///骨骼肌指数
@property (nonatomic,assign) double              boneMusclePercentage ;
///水分指数
//@property (nonatomic,assign) double              waterPercentage;





-(void)setobjectWithDic:(NSDictionary *)dict ;
-(NSString *)getHeightWithLevel:(int)level status:(mytype)isMytype;
@end
