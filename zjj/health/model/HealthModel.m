//
//  HealthModel.m
//  zjj
//
//  Created by iOSdeveloper on 2017/6/16.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "HealthModel.h"
#import "SubProjectItem.h"

#define warningColor   HEXCOLOR(0xfec200)
#define normalColor    [UIColor colorWithRed:57/255.0 green:208/255.0 blue:160/255.0 alpha:1]
#define seriousColor   [UIColor colorWithRed:236/255.0 green:85/255.0 blue:78/255.0 alpha:1]
@implementation HealthModel

+(HealthModel *)shareInstance
{
    static HealthModel * manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[HealthModel alloc]init];
    });
    return manager;
}




/**
 * 根据level获取 正常/偏瘦/危险、
 */
-(NSString *)getStatus:(isMyType)ismytype
{
    /*
     IS_BMI,
     IS_VISCERALFAT,//内脂
     IS_FAT,//脂肪
     IS_FATPERCENT,//体脂  fatPercentage
     IS_SAME,//肌肉\骨量\水分\蛋白质\骨重判定标准
     IS_BODYWEIGHT,//体重判定
     IS_SIZE,//体型
     */
    switch (ismytype) {
        case IS_MODEL_BMI:
            
            
            switch ([HealthDetailsItem instance].bmiLevel) {
        //("您的体型偏瘦，请适当增肌。", "您的体型正常，请保持。", "您已超重，请注意减重。")

                case 1:
                    return @"您的体型偏瘦，请适当增肌。";
                    break;
                case 2:
                    return @"您的体型正常，请保持。";
                    break;
                case 3:
                    return @"您已超重，请注意减重。";
                    break;
                default:
                    break;
            }
            break;
        case IS_MODEL_FATPERCENT:
//            ("您体内的脂肪偏低，需要注意。", "您的体脂肪含量正常，请保持。", "您的脂肪含量超标，需要减脂。")
            switch ([HealthDetailsItem instance].fatPercentageLevel) {
                case 1:
                    return @"您的体脂肪含量正常，请保持。";
                    break;
                case 2:
                    return @"您体内的脂肪偏低，需要注意。";
                    break;
                case 3:
                    return @"您的脂肪含量超标，需要减脂。";
                    break;
                    
                default:
                    break;
            }
            
            break;
        case IS_MODEL_FAT:
//            ("您体内的脂肪偏低，需要注意。", "您的体脂肪含量正常，请保持。", "您的脂肪含量超标，需要减脂。")
            switch ([HealthDetailsItem instance].fatWeightLevel) {
                case 1:
                    return @"您的体脂肪含量正常，请保持。";
                    break;
                case 2:
                    return @"您体内的脂肪偏低，需要注意。";
                    break;
                case 3:
                    return @"您的脂肪含量超标，需要减脂。";
                    break;
                    
                default:
                    break;
            }
            
            break;
        case IS_MODEL_WATER:
            //            ("您体内水分偏低，注意多饮水。减低体脂肪含量有助于提高体内水分比例。", "您体内水分含量正常，请保持。", "您体内水分含量过高，请检查水肿系数。")
            
            if ([HealthDetailsItem instance].waterWeight<[HealthDetailsItem instance].waterWeightMin) {
                return @"您体内水分偏低，注意多饮水。减低体脂肪含量有助于提高体内水分比例。";

            }else if ([HealthDetailsItem instance].waterWeight>=[HealthDetailsItem instance].waterWeightMin&&[HealthDetailsItem instance].waterWeight<[HealthDetailsItem instance].waterWeightMax)
            {
                return @"您体内水分含量正常，请保持。";

            }else
            {
                return @"您体内水分含量过高，请检查水肿系数。";

            }
            
            break;
        case IS_MODEL_PROTEIN:
            //            ("您缺乏蛋白质，请增加高蛋白质食物摄入。提升肌肉量也有助于增加体内蛋白含量。", "您体内蛋白质含量正常，请保持。", "您的蛋白质含量较高，有可能是肌肉发达，对健康并无不良影响。")
            if ([HealthDetailsItem instance].proteinWeight<[HealthDetailsItem instance].proteinWeightMin) {
                return @"您缺乏蛋白质，请增加高蛋白质食物摄入。提升肌肉量也有助于增加体内蛋白含量。";

            }else if (([HealthDetailsItem instance].proteinWeight>=[HealthDetailsItem instance].proteinWeightMin&&[HealthDetailsItem instance].proteinWeight<[HealthDetailsItem instance].proteinWeightMax))
            {
                return @"您体内蛋白质含量正常，请保持";

            }else{
                return @"您的蛋白质含量较高，有可能是肌肉发达，对健康并无不良影响。";

            }
            
            
            break;
        case IS_MODEL_MUSCLE:
//            ("您的肌肉含量偏低，建议适当增肌。", "您的肌肉含量正常，请保持。", "您的肌肉发达，请保持。")
            
            if ([HealthDetailsItem instance].muscleWeight<[HealthDetailsItem instance].muscleWeightMin) {
                return @"您的肌肉含量偏低，建议适当增肌。";

            }else if (([HealthDetailsItem instance].muscleWeight>=[HealthDetailsItem instance].muscleWeightMin&&[HealthDetailsItem instance].muscleWeight<[HealthDetailsItem instance].muscleWeightMax))
            {
                return @"您的肌肉含量正常，请保持。";

            }
            else
            {
                return @"您的肌肉发达，请保持。";

            }
            
            
            break;
        case IS_MODEL_BONEMUSCLE:
            //            ("您的骨量偏低，建议适当增肌。", "您的骨量正常，请保持。", "您的骨量发达，请保持。")
            
            if ([HealthDetailsItem instance].boneMuscleWeight<[HealthDetailsItem instance].boneMuscleWeightMin) {
                return @"您的骨骼肌含量偏低，建议适当增肌";
            }else if ([HealthDetailsItem instance].boneMuscleWeight>=[HealthDetailsItem instance].boneMuscleWeightMin&&[HealthDetailsItem instance].boneMuscleWeight<[HealthDetailsItem instance].boneMuscleWeightMax)
            {
                return @"您的骨骼肌含量正常，请保持。";
            }else
            {
                return @"您的骨骼肌含量发达，请保持。";
            }
            
            
            
    
            break;
        case IS_MODEL_BONE:
            //            ("您的骨量偏低，建议适当增肌。", "您的骨量正常，请保持。", "您的骨量发达，请保持。")
            
            
            if ([HealthDetailsItem instance].boneWeight<[HealthDetailsItem instance].boneWeightMin) {
                return @"您的骨量偏低";
            }else if ([HealthDetailsItem instance].boneMuscleWeight>=[HealthDetailsItem instance].boneWeightMin&&[HealthDetailsItem instance].boneWeight<[HealthDetailsItem instance].boneWeightMax)
            {
                return @"您的骨量正常，请保持。";
            }else
            {
                return @"您的骨量发达，请保持。";
            }
            
            
            
            
            break;
       

        case IS_MODEL_VISCERALFAT:
            //            ("您的内脏脂肪超标，容易患慢性疾病，请注意减脂。", "您的内脏脂肪正常，请保持。", "您的内脏脂肪较高，有较高的心脑血管疾病风险，请注意减脂。")
            switch ([HealthDetailsItem instance].visceralFatPercentageLevel) {
                case 1:
                    return @"您的内脏脂肪正常，请保持。";
                    break;
                case 2:
                    return @"您的内脏脂肪超标，容易患慢性疾病，请注意减脂。";
                    break;
                case 3:
                    return @"您的内脏脂肪较高，有较高的心脑血管疾病风险，请注意减脂。";
                    break;

                default:
                    break;
            }
            break;
            
        default:
            break;
    }
    return nil;
}


-(UIColor *)getHealthColorWithStatus:(isMyType)myType Level:(int)level
{
    /*
     weightLevel  1偏瘦2标准3偏胖4偏胖5超重  1低 2正常  3456 高
     fatPercentage level  1正常2低3高
     
     bmi  1低  2正常3高4高
     fatweightlevel  1低2正常3偏高 4高 5极高
     
     waterlevel 1低  2 正常 3高
     
     蛋白质  1正常 else低
     
     muscle 肌肉 1正常 else 低
     
     boneMuscle  1正常 else低
     
     内脂  1正常2超标3高
     */

//    SubProjectItem * subItem = [[SubProjectItem alloc]init];
    switch (myType) {
        case IS_MODEL_BMI:
            switch (level) {
                case 1:
                    return HEXCOLOR(0x00aef7);
                    break;
                case 2:
                    return normalColor;
                    break;
                case 3:
                    return HEXCOLOR(0xffa126);
                    break;
                case 4:
                    return seriousColor;
                    break;
                    
                default:
                    break;
            }
        case IS_MODEL_FATPERCENT:
            switch (level) {
                case 1:
                    return HEXCOLOR(0x00aef7);
                    break;
                case 2:
                    return normalColor;
                    break;
                case 3:
                    return warningColor;
                    break;
                case 4:
                    return HEXCOLOR(0xffa126);
                    break;
                case 5:
                    return seriousColor;
                    break;

                default:
                    break;
            }
            break;
        case IS_MODEL_FAT:
            switch (level) {
                case 1:
                    return HEXCOLOR(0x00aef7);
                    break;
                case 2:
                    return normalColor;
                    break;
                case 3:
                    return warningColor;
                    break;
                case 4:
                    return HEXCOLOR(0xffa126);
                    break;
                case 5:
                    return seriousColor;
                    break;

                default:
                    break;
            }
             break;
        case IS_MODEL_WATER:
            switch (level) {
            case 1:
                return HEXCOLOR(0x00aef7);
                break;
            case 2:
                return normalColor;
                break;
            case 3:
                return warningColor;
                break;

            default:
                break;
        }
             break;
        case IS_MODEL_PROTEIN:
            switch (level) {
                case 1:
                    return normalColor;
                    break;
                case 2:
                    return warningColor;
                    break;
                 default:
                    break;
            }

            
            break;
        case IS_MODEL_MUSCLE:
            switch (level) {
                case 1:
                    return normalColor;
                    break;
                case 2:
                    return warningColor;
                    break;
 
                    
                default:
                    break;
            }
            
            
            break;
        case IS_MODEL_BONEMUSCLE:
            switch (level) {
                case 1:
                    return normalColor;
                    break;
                case 2:
                    return warningColor;
                    break;
                    
                default:
                    break;
            }
            break;
            
            
        case IS_MODEL_VISCERALFAT:
            switch (level) {
                case 1:
                    return normalColor;
                    break;
                case 2:
                    return warningColor;
                    break;
                case 3:
                    return HEXCOLOR(0xffa126);
                    break;
                case 4:
                    return seriousColor;
                    break;

                default:
                    break;
            }
             break;
        case IS_MODEL_BONE:
            switch (level) {
                case 1:
                    return normalColor;
                    break;
                case 2:
                    return warningColor;
                    break;
                default:
                    break;
            }
            break;
        case IS_MODEL_WEIGHT:
            switch (level) {
                case 1:
                    return HEXCOLOR(0x00aef7);
                    break;
                case 2:
                    return normalColor;
                    break;
                case 3:
                    return warningColor;
                    break;
                case 4:
                    return HEXCOLOR(0xffa126);
                    break;
                case 5:
                    return seriousColor;
                    break;

                default:
                    break;
            }
            break;
        default:
            break;
    }
    
    return nil;
}

-(UIColor *)getSomeColorWithLevel:(int)Level
{
    
    switch (Level) {
        case 1:
            return HEXCOLOR(0x00aef7);
            break;
        case 2:
            return [UIColor colorWithRed:57/255.0 green:208/255.0 blue:160/255.0 alpha:1];
            break;
        case 3:
            return HEXCOLOR(0xffa126);//[UIColor colorWithRed:246/255.0 green:172/255.0 blue:2/255.0 alpha:1];
            break;
        case 4:
            return HEXCOLOR(0xefd81a);
            break;
        case 5:
            return [UIColor redColor];
            break;
            
        default:
            break;
    }
    return nil;
}

-(void)setLogInUpLoadString:(NSString *)logStr
{
    self.UpLoadlogString =[self.UpLoadlogString stringByAppendingString:[NSString stringWithFormat:@",%@",logStr]];
}

-(void)UpdateBlueToothInfo
{
    if (![[NSUserDefaults standardUserDefaults]objectForKey:@"UserOpenUpdateDebugKey"]) {
        return;
    }
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param safeSetObject:[UserModel shareInstance].userId forKey:@"userId"];
    [param safeSetObject:self.UpLoadlogString forKey:@"message"];
    [[BaseSservice sharedManager]postDebugWithUrl:@"app/userDebugMsg/savemsg.do"  paramters:param ];
}

/*
 IS_BMI,
 IS_VISCERALFAT,//内脂
 IS_FAT,//脂肪
 IS_FATPERCENT,//体脂  fatPercentage
 IS_SAME,//肌肉\骨量\水分\蛋白质\骨重判定标准
 IS_BODYWEIGHT,//体重判定
 IS_SIZE,//体型
 
 weightLevel  1偏瘦2正常3警告4警告5超重6超重  1低 2正常  3456 高
 fatPercentage level  1正常2低3高
 
 bmi  1低  2正常3高4高
 fatweightlevel  1正常2低3高
 
 waterlevel 1正常 else 低
 
 蛋白质  1正常 else低
 
 muscle 肌肉 1正常 else 低
 
 boneMuscle  1正常 else低
 
 内脂  1正常2超标3高
 
 */






























@end
