//
//  WelcomeBuilder.m
//  NPlus
//
//  Created by Anh Le Duc on 12/11/14.
//  Copyright (c) 2014 anhld. All rights reserved.
//

#import "WelcomeBuilder.h"
#import "ESConveyorBelt.h"
#define CENTER_X SCREEN_WIDTH/2.0f
#define CENTER_Y SCREEN_HEIGHT/2.0f
@interface ESCloseButton : UIButton
@end
@implementation ESCloseButton
- (id)init
{
    self = [super init];
    if (self) {
        [self setImage:[UIImage imageNamed:@"3_button"] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"3_button"] forState:UIControlStateHighlighted];
    }
    return self;
}

@end
@implementation WelcomeBuilder
+ (NSArray *)buildTutorialWithTarget:(id)target
{
    [UIPageControl appearance].pageIndicatorTintColor = [UIColor colorWithRed:0.4237 green:0.2847 blue:0.1927 alpha:1.0000];
    [UIPageControl appearance].currentPageIndicatorTintColor = [UIColor colorWithRed:0.1328 green:0.6916 blue:0.8866 alpha:1.0000];
    
    if(IS_IPHONE_6 || IS_IPHONE_6P){
        ESConveyorElement *bg1 = [ESConveyorElement elementForImageNamed:[[self class] nameForHardware:@"1_bg"]];
        bg1.inEffects = @[@(ESConveyorEffectFade)];
        bg1.outEffects = @[@(ESConveyorEffectFade)];
        bg1.inPage = 0;
        bg1.outPage = 1;
        ESConveyorElement *bg2 = [ESConveyorElement elementForImageNamed:[[self class] nameForHardware:@"2_bg"]];
        bg2.inEffects = @[@(ESConveyorEffectFade)];
        bg2.outEffects = @[@(ESConveyorEffectFade)];
        bg2.inPage = 1;
        bg2.outPage = 2;
        ESConveyorElement *bg3 = [ESConveyorElement elementForImageNamed:[[self class] nameForHardware:@"3_bg"]];
        bg3.inEffects = @[@(ESConveyorEffectFade)];
        bg3.outEffects = @[@(ESConveyorEffectFade)];
        bg3.inPage = 2;
        bg3.outPage = 3;
        
        ESConveyorElement *img10 = [ESConveyorElement elementForImageNamed:@"logo_iphone" center:CGPointMake(CENTER_X, 30)];
        img10.inEffects = @[@(ESConveyorEffectEdgeTop), @(ESConveyorEffectFade)];
        img10.outEffects = @[@(ESConveyorEffectEdgeTop), @(ESConveyorEffectFade)];
        img10.page = 0;
        
        ESConveyorElement *img11 = [ESConveyorElement elementForImageNamed:@"1_title1" center:CGPointMake(CENTER_X, 70)];
        img11.inEffects = @[@(ESConveyorEffectEdgeTop), @(ESConveyorEffectFade)];
        img11.outEffects = @[@(ESConveyorEffectEdgeTop), @(ESConveyorEffectFade)];
        img11.page = 0;
        
        ESConveyorElement *img12 = [ESConveyorElement elementForImageNamed:@"1_title2" center:CGPointMake(CENTER_X, img11.center.y + 35)];
        img12.inEffects = @[@(ESConveyorEffectFade), @(ESConveyorEffectFade)];
        img12.outEffects = @[@(ESConveyorEffectFade), @(ESConveyorEffectFade)];
        img12.page = 0;
        
        ESConveyorElement *img13 = [ESConveyorElement elementForImageNamed:@"1_icon1" center:CGPointMake(CENTER_X + 140.0f, CENTER_Y - 140.0f)];
        img13.inEffects = @[@(ESConveyorEffectEdgeRight), @(ESConveyorEffectFade)];
        img13.outEffects = @[@(ESConveyorEffectEdgeRight), @(ESConveyorEffectFade)];
        img13.page = 0;
        
        ESConveyorElement *img14 = [ESConveyorElement elementForImageNamed:@"1_icon2" center:CGPointMake(CENTER_X - 130.0f, CENTER_Y - 100.0f)];
        img14.inEffects = @[@(ESConveyorEffectEdgeLeft), @(ESConveyorEffectFade)];
        img14.outEffects = @[@(ESConveyorEffectEdgeLeft), @(ESConveyorEffectFade)];
        img14.page = 0;
        
        ESConveyorElement *imgMain1 = [ESConveyorElement elementForImageNamed:@"1_icon3" center:CGPointMake(CENTER_X, CENTER_Y + 20)];
        imgMain1.inEffects = @[@(ESConveyorEffectEdgeBottom)];
        imgMain1.outEffects = @[@(ESConveyorEffectEdgeBottom)];
        imgMain1.page = 0;
        
        ESConveyorElement *img16 = [ESConveyorElement elementForImageNamed:@"1_icon5" center:CGPointMake(CENTER_X + 85.0f, CENTER_Y + 180.0f)];
        img16.inEffects = @[@(ESConveyorEffectEdgeRight),  @(ESConveyorEffectEdgeBottom)];
        img16.outEffects = @[@(ESConveyorEffectEdgeRight),  @(ESConveyorEffectEdgeBottom)];
        img16.page = 0;
        
        ESConveyorElement *img17 = [ESConveyorElement elementForImageNamed:@"1_icon6" center:CGPointMake(CENTER_X + 30.0f, CENTER_Y + 200.0f)];
        img17.inEffects = @[@(ESConveyorEffectEdgeRight)];
        img17.outEffects = @[@(ESConveyorEffectEdgeRight)];
        img17.page = 0;
        
        ESConveyorElement *img18 = [ESConveyorElement elementForImageNamed:@"1_line1" center:CGPointMake(CENTER_X + 5, CENTER_Y - 150.0f)];
        img18.inEffects = @[@(ESConveyorEffectScalex1)];
        img18.outEffects = @[@(ESConveyorEffectScalex1)];
        img18.page = 0;
        
        ESConveyorElement *img19 = [ESConveyorElement elementForImageNamed:@"1_line2" center:CGPointMake(CENTER_X - 110.0f, CENTER_Y + 230.0f)];
        img19.inEffects = @[@(ESConveyorEffectEdgeLeft)];
        img19.outEffects = @[@(ESConveyorEffectEdgeLeft)];
        img19.page = 0;
        
        ESConveyorElement *img110 = [ESConveyorElement elementForImageNamed:@"1_icon7" center:CGPointMake(CENTER_X - 110.0f, CENTER_Y - 10)];
        img110.inEffects = @[@(ESConveyorEffectScalex1)];
        img110.outEffects = @[@(ESConveyorEffectScalex1)];
        img110.page = 0;
        
        ESConveyorElement *img111 = [ESConveyorElement elementForImageNamed:@"1_icon8" center:CGPointMake(CENTER_X - 105.0f, CENTER_Y + 100)];
        img111.inEffects = @[@(ESConveyorEffectScalex1)];
        img111.outEffects = @[@(ESConveyorEffectScalex1)];
        img111.page = 0;
        
        ESConveyorElement *img112 = [ESConveyorElement elementForImageNamed:@"1_icon9" center:CGPointMake(CENTER_X + 110.0f, CENTER_Y - 5.0f)];
        img112.inEffects = @[@(ESConveyorEffectScalex1)];
        img112.outEffects = @[@(ESConveyorEffectScalex1)];
        img112.page = 0;
        ESConveyorElement *img113 = [ESConveyorElement elementForImageNamed:@"1_icon10" center:CGPointMake(CENTER_X + 100.0f, CENTER_Y + 80)];
        img113.inEffects = @[@(ESConveyorEffectScalex1)];
        img113.outEffects = @[@(ESConveyorEffectScalex1)];
        img113.page = 0;
        
        //page 2
        ESConveyorElement *imgMain2 = [ESConveyorElement elementForImageNamed:@"2_icon5" center:CGPointMake(CENTER_X, CENTER_Y - 20)];
        imgMain2.inEffects = @[@(ESConveyorEffectEdgeTop)];
        imgMain2.outEffects = @[@(ESConveyorEffectEdgeBottom)];
        imgMain2.page = 1;
        
        ESConveyorElement *imglogo2 = [ESConveyorElement elementForImageNamed:@"logo_iphone" center:CGPointMake(CENTER_X, 30)];
        imglogo2.inEffects = @[@(ESConveyorEffectEdgeTop), @(ESConveyorEffectFade)];
        imglogo2.outEffects = @[@(ESConveyorEffectEdgeTop), @(ESConveyorEffectFade)];
        imglogo2.page = 1;
        
        ESConveyorElement *img210 = [ESConveyorElement elementForImageNamed:@"2_icon7" center:CGPointMake(CENTER_X - 90.0f, CENTER_Y - 50.0f)];
        img210.inEffects = @[@(ESConveyorEffectEdgeLeft)];
        img210.outEffects = @[@(ESConveyorEffectEdgeLeft)];
        img210.page = 1;
        
        ESConveyorElement *img211 = [ESConveyorElement elementForImageNamed:@"2_icon8" center:CGPointMake(CENTER_X - 100.0f, CENTER_Y + 15)];
        img211.inEffects = @[@(ESConveyorEffectEdgeLeft)];
        img211.outEffects = @[@(ESConveyorEffectEdgeLeft)];
        img211.page = 1;
        
        ESConveyorElement *img212 = [ESConveyorElement elementForImageNamed:@"2_icon9" center:CGPointMake(CENTER_X - 90.0f, CENTER_Y + 70.0f)];
        img212.inEffects = @[@(ESConveyorEffectEdgeLeft)];
        img212.outEffects = @[@(ESConveyorEffectEdgeLeft)];
        img212.page = 1;
        
        ESConveyorElement *img213 = [ESConveyorElement elementForImageNamed:@"2_icon6" center:CGPointMake(CENTER_X + 130.0f, CENTER_Y - 50.0f)];
        img213.inEffects = @[@(ESConveyorEffectScalex1)];
        img213.outEffects = @[@(ESConveyorEffectScalex1)];
        img213.page = 1;
        
        ESConveyorElement *img214 = [ESConveyorElement elementForImageNamed:@"2_icon10" center:CGPointMake(CENTER_X + 90.0f, CENTER_Y)];
        img214.animationEffects = ESAnimationRotation;
        img214.inEffects = @[@(ESConveyorEffectEdgeRight)];
        img214.outEffects = @[@(ESConveyorEffectEdgeRight)];
        img214.page = 1;
        
        ESConveyorElement *img215 = [ESConveyorElement elementForImageNamed:@"2_icon11" center:CGPointMake(CENTER_X + 100.0f, CENTER_Y + 70.0f)];
        img215.inEffects = @[@(ESConveyorEffectEdgeRight)];
        img215.outEffects = @[@(ESConveyorEffectEdgeRight)];
        img215.page = 1;
        
        ESConveyorElement *img216 = [ESConveyorElement elementForImageNamed:@"2_icon12" center:CGPointMake(CENTER_X + 110.0f, CENTER_Y - 240.0f)];
        img216.inEffects = @[@(ESConveyorEffectScalex1)];
        img216.outEffects = @[@(ESConveyorEffectScalex1)];
        img216.page = 1;
        
        ESConveyorElement *img217 = [ESConveyorElement elementForImageNamed:@"2_icon13" center:CGPointMake(CENTER_X + 80.0f, CENTER_Y - 190.0f)];
        img217.inEffects = @[@(ESConveyorEffectScalex1)];
        img217.outEffects = @[@(ESConveyorEffectScalex1)];
        img217.page = 1;
        
        ESConveyorElement *img218 = [ESConveyorElement elementForImageNamed:@"2_icon1" center:CGPointMake(CENTER_X - 140.0f, CENTER_Y - 280.0f)];
        img218.inEffects = @[@(ESConveyorEffectEdgeTop)];
        img218.outEffects = @[@(ESConveyorEffectEdgeTop)];
        img218.page = 1;
        
        ESConveyorElement *img219 = [ESConveyorElement elementForImageNamed:@"2_icon2" center:CGPointMake(CENTER_X - 40.0f, CENTER_Y - 230.0f)];
        img219.inEffects = @[@(ESConveyorEffectEdgeRight)];
        img219.outEffects = @[@(ESConveyorEffectEdgeRight)];
        img219.page = 1;
        
        ESConveyorElement *img220 = [ESConveyorElement elementForImageNamed:@"2_icon3" center:CGPointMake(CENTER_X - 160.0f, CENTER_Y - 210.0f)];
        img220.inEffects = @[@(ESConveyorEffectEdgeLeft)];
        img220.outEffects = @[@(ESConveyorEffectEdgeLeft)];
        img220.page = 1;
        
        ESConveyorElement *img221 = [ESConveyorElement elementForImageNamed:@"2_icon4" center:CGPointMake(CENTER_X - 90.0f, CENTER_Y - 190.0f)];
        img221.inEffects = @[@(ESConveyorEffectEdgeBottom)];
        img221.outEffects = @[@(ESConveyorEffectEdgeBottom)];
        img221.page = 1;
        
        ESConveyorElement *img222 = [ESConveyorElement elementForImageNamed:@"2_bg1" center:CGPointMake(CENTER_X, SCREEN_HEIGHT - 65)];
        img222.inEffects = @[@(ESConveyorEffectFade)];
        img222.outEffects = @[@(ESConveyorEffectFade)];
        img222.page = 1;
        
        ESConveyorElement *img223 = [ESConveyorElement elementForImageNamed:@"2_title1" center:CGPointMake(CENTER_X, img222.center.y - 20)];
        img223.inEffects = @[@(ESConveyorEffectEdgeLeft)];
        img223.outEffects = @[@(ESConveyorEffectEdgeRight)];
        img223.page = 1;
        
        
        ESConveyorElement *img224 = [ESConveyorElement elementForImageNamed:@"2_title2" center:CGPointMake(CENTER_X, img222.center.y + 20)];
        img224.inEffects = @[@(ESConveyorEffectEdgeRight)];
        img224.outEffects = @[@(ESConveyorEffectEdgeLeft)];
        img224.page = 1;
        
        //page 3
        ESConveyorElement *img310 = [ESConveyorElement elementForImageNamed:[[self class] nameForHardware:@"3_bg1"] center:CGPointMake(CENTER_X, CENTER_Y + 240)];
        img310.inEffects = @[@(ESConveyorEffectEdgeBottom)];
        img310.outEffects = @[@(ESConveyorEffectEdgeBottom)];
        img310.page = 2;
        
        ESConveyorElement *imglogo3 = [ESConveyorElement elementForImageNamed:@"logo_iphone" center:CGPointMake(CENTER_X, 30)];
        imglogo3.inEffects = @[@(ESConveyorEffectEdgeTop), @(ESConveyorEffectFade)];
        imglogo3.outEffects = @[@(ESConveyorEffectEdgeTop), @(ESConveyorEffectFade)];
        imglogo3.page = 2;
        
        ESConveyorElement *img311 = [ESConveyorElement elementForImageNamed:@"3_cloud4" center:CGPointMake(CENTER_X, CENTER_Y + 60)];
        img311.inEffects = @[@(ESConveyorEffectScalex1)];
        img311.outEffects = @[@(ESConveyorEffectScalex1)];
        img311.page = 2;
        
        ESConveyorElement *imgMain3 = [ESConveyorElement elementForImageNamed:@"3_icon_main" center:CGPointMake(CENTER_X, CENTER_Y)];
        imgMain3.inEffects = @[@(ESConveyorEffectEdgeTop)];
        imgMain3.outEffects = @[@(ESConveyorEffectEdgeBottom)];
        imgMain3.page = 2;
        
        ESConveyorElement *img312 = [ESConveyorElement elementForImageNamed:@"3_icon1" center:CGPointMake(CENTER_X - 90, CENTER_Y - 70)];
        img312.inEffects = @[@(ESConveyorEffectEdgeLeft), @(ESConveyorEffectEdgeTop)];
        img312.outEffects = @[@(ESConveyorEffectEdgeLeft), @(ESConveyorEffectEdgeTop)];
        img312.page = 2;
        
        ESConveyorElement *img313 = [ESConveyorElement elementForImageNamed:@"3_icon2" center:CGPointMake(CENTER_X + 100, CENTER_Y - 80)];
        img313.inEffects = @[@(ESConveyorEffectEdgeRight), @(ESConveyorEffectEdgeTop) ];
        img313.outEffects = @[@(ESConveyorEffectEdgeRight), @(ESConveyorEffectEdgeTop) ];
        img313.page = 2;
        
        ESConveyorElement *img314 = [ESConveyorElement elementForImageNamed:@"3_icon3" center:CGPointMake(CENTER_X - 80, CENTER_Y + 60)];
        img314.inEffects = @[@(ESConveyorEffectEdgeLeft)];
        img314.outEffects = @[@(ESConveyorEffectEdgeLeft)];
        img314.page = 2;
        
        ESConveyorElement *img315 = [ESConveyorElement elementForImageNamed:@"3_icon4" center:CGPointMake(CENTER_X + 80, CENTER_Y + 70)];
        img315.inEffects = @[@(ESConveyorEffectEdgeRight), @(ESConveyorEffectEdgeBottom)];
        img315.outEffects = @[@(ESConveyorEffectEdgeRight), @(ESConveyorEffectEdgeBottom)];
        img315.page = 2;
        
        ESConveyorElement *img316 = [ESConveyorElement elementForImageNamed:@"3_icon5" center:CGPointMake(CENTER_X + 100, CENTER_Y - 10)];
        img316.animationEffects = ESAnimationRotation;
        img316.inEffects = @[@(ESConveyorEffectEdgeRight)];
        img316.outEffects = @[@(ESConveyorEffectEdgeRight)];
        img316.page = 2;
        
        //cloud
        ESConveyorElement *img317 = [ESConveyorElement elementForImageNamed:@"3_cloud1" center:CGPointMake(CENTER_X - 60, CENTER_Y - 230)];
        img317.inEffects = @[@(ESConveyorEffectEdgeLeft)];
        img317.outEffects = @[@(ESConveyorEffectEdgeLeft)];
        img317.page = 2;
        
        ESConveyorElement *img318 = [ESConveyorElement elementForImageNamed:@"3_cloud2" center:CGPointMake(CENTER_X + 60, CENTER_Y - 230)];
        img318.inEffects = @[@(ESConveyorEffectEdgeRight)];
        img318.outEffects = @[@(ESConveyorEffectEdgeRight)];
        img318.page = 2;
        
        ESConveyorElement *img319 = [ESConveyorElement elementForImageNamed:@"3_cloud3" center:CGPointMake(CENTER_X, CENTER_Y - 220)];
        img319.inEffects = @[@(ESConveyorEffectEdgeTop)];
        img319.outEffects = @[@(ESConveyorEffectEdgeTop)];
        img319.page = 2;
        
        ESConveyorElement *img320 = [ESConveyorElement elementForImageNamed:@"3_down" center:CGPointMake(CENTER_X, CENTER_Y - 170)];
        img320.inEffects = @[@(ESConveyorEffectScalex1)];
        img320.outEffects = @[@(ESConveyorEffectScalex1)];
        img320.page = 2;
        
        ESConveyorElement *img321 = [ESConveyorElement elementForImageNamed:@"3_title1" center:CGPointMake(CENTER_X, SCREEN_HEIGHT - 150)];
        img321.inEffects = @[@(ESConveyorEffectEdgeLeft)];
        img321.outEffects = @[@(ESConveyorEffectEdgeRight)];
        img321.page = 2;
        
        ESConveyorElement *img322 = [ESConveyorElement elementForImageNamed:@"3_title2" center:CGPointMake(CENTER_X, img321.center.y + 35)];
        img322.inEffects = @[@(ESConveyorEffectEdgeRight)];
        img322.outEffects = @[@(ESConveyorEffectEdgeLeft)];
        img322.page = 2;
        
        ESConveyorElement *img323 = [ESConveyorElement elementForImageNamed:@"3_title3" center:CGPointMake(CENTER_X, img321.center.y + 60)];
        img323.inEffects = @[@(ESConveyorEffectEdgeLeft)];
        img323.outEffects = @[@(ESConveyorEffectEdgeRight)];
        img323.page = 2;
        
        ESConveyorElement *btExit = [ESConveyorElement elementForButtonOfClass:[ESCloseButton class] title:@"" target:target action:@selector(finishedWelcomeScreen) center:CGPointMake(CENTER_X, img321.center.y + 110)];
        [btExit setInEffects:@[@(ESConveyorEffectEdgeBottom)] outEffects:@[@(ESConveyorEffectEdgeBottom)]];
        btExit.inPage = 2;
        btExit.outPage = 2;
        
        ESConveyorPageControlElement *pagination = [[ESConveyorPageControlElement alloc] initWithClass:[UIPageControl class] center:CGPointMake(SCREEN_WIDTH/2.0f, SCREEN_HEIGHT - 10.0f)];
        pagination.inPage = 0;
        pagination.outPage = 1;
        [pagination setInEffects:@[@(ESConveyorEffectFade)] outEffects:@[@(ESConveyorEffectFade)]];
        
        NSArray *elements = @[bg1, bg2, bg3, img10, img11, img19, img13, img14, img18, img12, img110, img111, img112, img113, imgMain1, img16, img17, imglogo2, img210, img211, img212, img213, img214, img215, img218, img219, img220, img221, img222, img223, img224, imgMain2, img216, img217, imglogo3, img310, img311, img312, img313, img314, img316, img315, img320, img317, img318, img319, img321, img322, img323, imgMain3, btExit, pagination];
        return elements;
    }else{
        ESConveyorElement *bg1 = [ESConveyorElement elementForImageNamed:[[self class] nameForHardware:@"1_bg"]];
        bg1.inEffects = @[@(ESConveyorEffectFade)];
        bg1.outEffects = @[@(ESConveyorEffectFade)];
        bg1.inPage = 0;
        bg1.outPage = 1;
        ESConveyorElement *bg2 = [ESConveyorElement elementForImageNamed:[[self class] nameForHardware:@"2_bg"]];
        bg2.inEffects = @[@(ESConveyorEffectFade)];
        bg2.outEffects = @[@(ESConveyorEffectFade)];
        bg2.inPage = 1;
        bg2.outPage = 2;
        ESConveyorElement *bg3 = [ESConveyorElement elementForImageNamed:[[self class] nameForHardware:@"3_bg"]];
        bg3.inEffects = @[@(ESConveyorEffectFade)];
        bg3.outEffects = @[@(ESConveyorEffectFade)];
        bg3.inPage = 2;
        bg3.outPage = 3;
        ESConveyorElement *img11 = [ESConveyorElement elementForImageNamed:@"1_title1" center:CGPointMake(CENTER_X, CENTER_Y - 190)];
        img11.inEffects = @[@(ESConveyorEffectEdgeTop), @(ESConveyorEffectFade)];
        img11.outEffects = @[@(ESConveyorEffectEdgeTop), @(ESConveyorEffectFade)];
        img11.page = 0;
        
        ESConveyorElement *img10 = [ESConveyorElement elementForImageNamed:@"logo_iphone" center:CGPointMake(CENTER_X,CENTER_Y - 220)];
        img10.inEffects = @[@(ESConveyorEffectEdgeTop), @(ESConveyorEffectFade)];
        img10.outEffects = @[@(ESConveyorEffectEdgeTop), @(ESConveyorEffectFade)];
        img10.page = 0;
        
        ESConveyorElement *img12 = [ESConveyorElement elementForImageNamed:@"1_title2" center:CGPointMake(CENTER_X, CENTER_Y - 170)];
        img12.inEffects = @[@(ESConveyorEffectFade), @(ESConveyorEffectFade)];
        img12.outEffects = @[@(ESConveyorEffectFade), @(ESConveyorEffectFade)];
        img12.page = 0;
        
        ESConveyorElement *img13 = [ESConveyorElement elementForImageNamed:@"1_icon1" center:CGPointMake(CENTER_X + 100.0f, CENTER_Y - 125.0f)];
        img13.inEffects = @[@(ESConveyorEffectEdgeRight), @(ESConveyorEffectFade)];
        img13.outEffects = @[@(ESConveyorEffectEdgeRight), @(ESConveyorEffectFade)];
        img13.page = 0;
        
        ESConveyorElement *img14 = [ESConveyorElement elementForImageNamed:@"1_icon2" center:CGPointMake(CENTER_X - 100.0f, CENTER_Y - 100.0f)];
        img14.inEffects = @[@(ESConveyorEffectEdgeLeft), @(ESConveyorEffectFade)];
        img14.outEffects = @[@(ESConveyorEffectEdgeLeft), @(ESConveyorEffectFade)];
        img14.page = 0;
        
        ESConveyorElement *imgMain1 = [ESConveyorElement elementForImageNamed:@"1_icon3" center:CGPointMake(CENTER_X, CENTER_Y)];
        imgMain1.inEffects = @[@(ESConveyorEffectEdgeBottom)];
        imgMain1.outEffects = @[@(ESConveyorEffectEdgeBottom)];
        imgMain1.page = 0;
        
        ESConveyorElement *img16 = [ESConveyorElement elementForImageNamed:@"1_icon5" center:CGPointMake(CENTER_X + 55.0f, CENTER_Y + 125.0f)];
        img16.inEffects = @[@(ESConveyorEffectEdgeRight),  @(ESConveyorEffectEdgeBottom)];
        img16.outEffects = @[@(ESConveyorEffectEdgeRight),  @(ESConveyorEffectEdgeBottom)];
        img16.page = 0;
        
        ESConveyorElement *img17 = [ESConveyorElement elementForImageNamed:@"1_icon6" center:CGPointMake(CENTER_X + 15.0f, CENTER_Y + 140.0f)];
        img17.inEffects = @[@(ESConveyorEffectEdgeRight)];
        img17.outEffects = @[@(ESConveyorEffectEdgeRight)];
        img17.page = 0;
        
        ESConveyorElement *img18 = [ESConveyorElement elementForImageNamed:@"1_line1" center:CGPointMake(CENTER_X + 5, CENTER_Y - 115.0f)];
        img18.inEffects = @[@(ESConveyorEffectScalex1)];
        img18.outEffects = @[@(ESConveyorEffectScalex1)];
        img18.page = 0;
        
        ESConveyorElement *img19 = [ESConveyorElement elementForImageNamed:@"1_line2" center:CGPointMake(CENTER_X - 80.0f, CENTER_Y + 140.0f)];
        img19.inEffects = @[@(ESConveyorEffectEdgeLeft)];
        img19.outEffects = @[@(ESConveyorEffectEdgeLeft)];
        img19.page = 0;
        
        ESConveyorElement *img110 = [ESConveyorElement elementForImageNamed:@"1_icon7" center:CGPointMake(CENTER_X - 70.0f, CENTER_Y - 10)];
        img110.inEffects = @[@(ESConveyorEffectScalex1)];
        img110.outEffects = @[@(ESConveyorEffectScalex1)];
        img110.page = 0;
        
        ESConveyorElement *img111 = [ESConveyorElement elementForImageNamed:@"1_icon8" center:CGPointMake(CENTER_X - 70.0f, CENTER_Y + 60)];
        img111.inEffects = @[@(ESConveyorEffectScalex1)];
        img111.outEffects = @[@(ESConveyorEffectScalex1)];
        img111.page = 0;
        
        ESConveyorElement *img112 = [ESConveyorElement elementForImageNamed:@"1_icon9" center:CGPointMake(CENTER_X + 70.0f, CENTER_Y - 5.0f)];
        img112.inEffects = @[@(ESConveyorEffectScalex1)];
        img112.outEffects = @[@(ESConveyorEffectScalex1)];
        img112.page = 0;
        ESConveyorElement *img113 = [ESConveyorElement elementForImageNamed:@"1_icon10" center:CGPointMake(CENTER_X + 70.0f, CENTER_Y + 50)];
        img113.inEffects = @[@(ESConveyorEffectScalex1)];
        img113.outEffects = @[@(ESConveyorEffectScalex1)];
        img113.page = 0;
        
        //page 2
        ESConveyorElement *imgMain2 = [ESConveyorElement elementForImageNamed:@"2_icon5" center:CGPointMake(CENTER_X, CENTER_Y)];
        imgMain2.inEffects = @[@(ESConveyorEffectEdgeTop)];
        imgMain2.outEffects = @[@(ESConveyorEffectEdgeBottom)];
        imgMain2.page = 1;
        
        ESConveyorElement *logo2 = [ESConveyorElement elementForImageNamed:@"logo_iphone" center:CGPointMake(CENTER_X, CENTER_Y - 220)];
        logo2.inEffects = @[@(ESConveyorEffectEdgeTop), @(ESConveyorEffectFade)];
        logo2.outEffects = @[@(ESConveyorEffectEdgeTop), @(ESConveyorEffectFade)];
        logo2.page = 1;
        
        ESConveyorElement *img210 = [ESConveyorElement elementForImageNamed:@"2_icon7" center:CGPointMake(CENTER_X - 60.0f, CENTER_Y - 20.0f)];
        img210.inEffects = @[@(ESConveyorEffectEdgeLeft)];
        img210.outEffects = @[@(ESConveyorEffectEdgeLeft)];
        img210.page = 1;
        
        ESConveyorElement *img211 = [ESConveyorElement elementForImageNamed:@"2_icon8" center:CGPointMake(CENTER_X - 70.0f, CENTER_Y + 20)];
        img211.inEffects = @[@(ESConveyorEffectEdgeLeft)];
        img211.outEffects = @[@(ESConveyorEffectEdgeLeft)];
        img211.page = 1;
        
        ESConveyorElement *img212 = [ESConveyorElement elementForImageNamed:@"2_icon9" center:CGPointMake(CENTER_X - 65.0f, CENTER_Y + 60.0f)];
        img212.inEffects = @[@(ESConveyorEffectEdgeLeft)];
        img212.outEffects = @[@(ESConveyorEffectEdgeLeft)];
        img212.page = 1;
        
        ESConveyorElement *img213 = [ESConveyorElement elementForImageNamed:@"2_icon6" center:CGPointMake(CENTER_X + 80.0f, CENTER_Y - 25.0f)];
        img213.inEffects = @[@(ESConveyorEffectScalex1)];
        img213.outEffects = @[@(ESConveyorEffectScalex1)];
        img213.page = 1;
        
        ESConveyorElement *img214 = [ESConveyorElement elementForImageNamed:@"2_icon10" center:CGPointMake(CENTER_X + 65.0f, CENTER_Y + 10.0f)];
        img214.animationEffects = ESAnimationRotation;
        img214.inEffects = @[@(ESConveyorEffectEdgeRight)];
        img214.outEffects = @[@(ESConveyorEffectEdgeRight)];
        img214.page = 1;
        
        ESConveyorElement *img215 = [ESConveyorElement elementForImageNamed:@"2_icon11" center:CGPointMake(CENTER_X + 65.0f, CENTER_Y + 60.0f)];
        img215.inEffects = @[@(ESConveyorEffectEdgeRight)];
        img215.outEffects = @[@(ESConveyorEffectEdgeRight)];
        img215.page = 1;
        
        ESConveyorElement *img216 = [ESConveyorElement elementForImageNamed:@"2_icon12" center:CGPointMake(CENTER_X + 70.0f, CENTER_Y - 160.0f)];
        img216.inEffects = @[@(ESConveyorEffectScalex1)];
        img216.outEffects = @[@(ESConveyorEffectScalex1)];
        img216.page = 1;
        
        ESConveyorElement *img217 = [ESConveyorElement elementForImageNamed:@"2_icon13" center:CGPointMake(CENTER_X + 50.0f, CENTER_Y - 120.0f)];
        img217.inEffects = @[@(ESConveyorEffectScalex1)];
        img217.outEffects = @[@(ESConveyorEffectScalex1)];
        img217.page = 1;
        
        ESConveyorElement *img218 = [ESConveyorElement elementForImageNamed:@"2_icon1" center:CGPointMake(CENTER_X - 90.0f, CENTER_Y - 180.0f)];
        img218.inEffects = @[@(ESConveyorEffectEdgeTop)];
        img218.outEffects = @[@(ESConveyorEffectEdgeTop)];
        img218.page = 1;
        
        ESConveyorElement *img219 = [ESConveyorElement elementForImageNamed:@"2_icon2" center:CGPointMake(CENTER_X - 30.0f, CENTER_Y - 140.0f)];
        img219.inEffects = @[@(ESConveyorEffectEdgeRight)];
        img219.outEffects = @[@(ESConveyorEffectEdgeRight)];
        img219.page = 1;
        
        ESConveyorElement *img220 = [ESConveyorElement elementForImageNamed:@"2_icon3" center:CGPointMake(CENTER_X - 110.0f, CENTER_Y - 135.0f)];
        img220.inEffects = @[@(ESConveyorEffectEdgeLeft)];
        img220.outEffects = @[@(ESConveyorEffectEdgeLeft)];
        img220.page = 1;
        
        ESConveyorElement *img221 = [ESConveyorElement elementForImageNamed:@"2_icon4" center:CGPointMake(CENTER_X - 70.0f, CENTER_Y - 110.0f)];
        img221.inEffects = @[@(ESConveyorEffectEdgeBottom)];
        img221.outEffects = @[@(ESConveyorEffectEdgeBottom)];
        img221.page = 1;
        
        ESConveyorElement *img222 = [ESConveyorElement elementForImageNamed:@"2_bg1" center:CGPointMake(CENTER_X, CENTER_Y + 160.0f)];
        img222.inEffects = @[@(ESConveyorEffectFade)];
        img222.outEffects = @[@(ESConveyorEffectFade)];
        img222.page = 1;
        
        ESConveyorElement *img223 = [ESConveyorElement elementForImageNamed:@"2_title1" center:CGPointMake(CENTER_X, img222.center.y - 15)];
        img223.inEffects = @[@(ESConveyorEffectEdgeLeft)];
        img223.outEffects = @[@(ESConveyorEffectEdgeRight)];
        img223.page = 1;
        
        
        ESConveyorElement *img224 = [ESConveyorElement elementForImageNamed:@"2_title2" center:CGPointMake(CENTER_X, img222.center.y + 15)];
        img224.inEffects = @[@(ESConveyorEffectEdgeRight)];
        img224.outEffects = @[@(ESConveyorEffectEdgeLeft)];
        img224.page = 1;
        
        //page 3
        ESConveyorElement *img310 = [ESConveyorElement elementForImageNamed:@"3_bg1" center:CGPointMake(CENTER_X, CENTER_Y + 190)];
        img310.inEffects = @[@(ESConveyorEffectEdgeBottom)];
        img310.outEffects = @[@(ESConveyorEffectEdgeBottom)];
        img310.page = 2;
        
        ESConveyorElement *logo3 = [ESConveyorElement elementForImageNamed:@"logo_iphone" center:CGPointMake(CENTER_X, CENTER_Y - 220)];
        logo3.inEffects = @[@(ESConveyorEffectEdgeTop), @(ESConveyorEffectFade)];
        logo3.outEffects = @[@(ESConveyorEffectEdgeTop), @(ESConveyorEffectFade)];
        logo3.page = 2;
        
        ESConveyorElement *img311 = [ESConveyorElement elementForImageNamed:@"3_cloud4" center:CGPointMake(CENTER_X, CENTER_Y + 40)];
        img311.inEffects = @[@(ESConveyorEffectScalex1)];
        img311.outEffects = @[@(ESConveyorEffectScalex1)];
        img311.page = 2;
        
        ESConveyorElement *imgMain3 = [ESConveyorElement elementForImageNamed:@"3_icon_main" center:CGPointMake(CENTER_X, CENTER_Y)];
        imgMain3.inEffects = @[@(ESConveyorEffectEdgeTop)];
        imgMain3.outEffects = @[@(ESConveyorEffectEdgeBottom)];
        imgMain3.page = 2;
        
        ESConveyorElement *img312 = [ESConveyorElement elementForImageNamed:@"3_icon1" center:CGPointMake(CENTER_X - 60, CENTER_Y - 45)];
        img312.inEffects = @[@(ESConveyorEffectEdgeLeft), @(ESConveyorEffectEdgeTop)];
        img312.outEffects = @[@(ESConveyorEffectEdgeLeft), @(ESConveyorEffectEdgeTop)];
        img312.page = 2;
        
        ESConveyorElement *img313 = [ESConveyorElement elementForImageNamed:@"3_icon2" center:CGPointMake(CENTER_X + 65, CENTER_Y - 60)];
        img313.inEffects = @[@(ESConveyorEffectEdgeRight), @(ESConveyorEffectEdgeTop) ];
        img313.outEffects = @[@(ESConveyorEffectEdgeRight), @(ESConveyorEffectEdgeTop) ];
        img313.page = 2;
        
        ESConveyorElement *img314 = [ESConveyorElement elementForImageNamed:@"3_icon3" center:CGPointMake(CENTER_X - 55, CENTER_Y + 35)];
        img314.inEffects = @[@(ESConveyorEffectEdgeLeft)];
        img314.outEffects = @[@(ESConveyorEffectEdgeLeft)];
        img314.page = 2;
        
        ESConveyorElement *img315 = [ESConveyorElement elementForImageNamed:@"3_icon4" center:CGPointMake(CENTER_X + 50, CENTER_Y + 45)];
        img315.inEffects = @[@(ESConveyorEffectEdgeRight), @(ESConveyorEffectEdgeBottom)];
        img315.outEffects = @[@(ESConveyorEffectEdgeRight), @(ESConveyorEffectEdgeBottom)];
        img315.page = 2;
        
        ESConveyorElement *img316 = [ESConveyorElement elementForImageNamed:@"3_icon5" center:CGPointMake(CENTER_X + 65, CENTER_Y - 5)];
        img316.animationEffects = ESAnimationRotation;
        img316.inEffects = @[@(ESConveyorEffectEdgeRight)];
        img316.outEffects = @[@(ESConveyorEffectEdgeRight)];
        img316.page = 2;
        
        //cloud
        ESConveyorElement *img317 = [ESConveyorElement elementForImageNamed:@"3_cloud1" center:CGPointMake(CENTER_X - 40, CENTER_Y - 180)];
        img317.inEffects = @[@(ESConveyorEffectEdgeLeft)];
        img317.outEffects = @[@(ESConveyorEffectEdgeLeft)];
        img317.page = 2;
        
        ESConveyorElement *img318 = [ESConveyorElement elementForImageNamed:@"3_cloud2" center:CGPointMake(CENTER_X + 40, CENTER_Y - 180)];
        img318.inEffects = @[@(ESConveyorEffectEdgeRight)];
        img318.outEffects = @[@(ESConveyorEffectEdgeRight)];
        img318.page = 2;
        
        ESConveyorElement *img319 = [ESConveyorElement elementForImageNamed:@"3_cloud3" center:CGPointMake(CENTER_X, CENTER_Y - 170)];
        img319.inEffects = @[@(ESConveyorEffectEdgeTop)];
        img319.outEffects = @[@(ESConveyorEffectEdgeTop)];
        img319.page = 2;
        
        ESConveyorElement *img320 = [ESConveyorElement elementForImageNamed:@"3_down" center:CGPointMake(CENTER_X, CENTER_Y - 130)];
        img320.inEffects = @[@(ESConveyorEffectScalex1)];
        img320.outEffects = @[@(ESConveyorEffectScalex1)];
        img320.page = 2;
        
        ESConveyorElement *img321 = [ESConveyorElement elementForImageNamed:@"3_title1" center:CGPointMake(CENTER_X, CENTER_Y + 120)];
        img321.inEffects = @[@(ESConveyorEffectEdgeBottom)];
        img321.outEffects = @[@(ESConveyorEffectEdgeBottom)];
        img321.page = 2;
        
        ESConveyorElement *img322 = [ESConveyorElement elementForImageNamed:@"3_title2" center:CGPointMake(CENTER_X, img321.center.y + 25)];
        img322.inEffects = @[@(ESConveyorEffectEdgeBottom)];
        img322.outEffects = @[@(ESConveyorEffectEdgeBottom)];
        img322.page = 2;
        
        ESConveyorElement *img323 = [ESConveyorElement elementForImageNamed:@"3_title3" center:CGPointMake(CENTER_X, img321.center.y + 50)];
        img323.inEffects = @[@(ESConveyorEffectEdgeBottom)];
        img323.outEffects = @[@(ESConveyorEffectEdgeBottom)];
        img323.page = 2;
        
        ESConveyorElement *btExit = [ESConveyorElement elementForButtonOfClass:[ESCloseButton class] title:@"" target:target action:@selector(finishedWelcomeScreen) center:CGPointMake(CENTER_X, img321.center.y + 90)];
        [btExit setInEffects:@[@(ESConveyorEffectEdgeBottom)] outEffects:@[@(ESConveyorEffectEdgeBottom)]];
        btExit.inPage = 2;
        btExit.outPage = 2;
        
        ESConveyorPageControlElement *pagination = [[ESConveyorPageControlElement alloc] initWithClass:[UIPageControl class] center:CGPointMake(SCREEN_WIDTH/2.0f, SCREEN_HEIGHT - 20.0f)];
        pagination.inPage = 0;
        pagination.outPage = 2;
        [pagination setInEffects:@[@(ESConveyorEffectFade)] outEffects:@[@(ESConveyorEffectFade)]];
        
        NSArray *elements = @[bg1, bg2, bg3, img10, img11, img12, img13, img14, img18, img19, img110, img111, img112, img113, imgMain1, img16, img17, logo2, img210, img211, img212, img213, img214, img215, img218, img219, img220, img221, img222, img223, img224, imgMain2, img216, img217, logo3, img310, img311, img312, img313, img314, img316, img315, img320, img317, img318, img319, img321, img322, img323, imgMain3, pagination, btExit];
        return elements;
    }
}

- (void)finishedWelcomeScreen{}

+ (NSString*)nameForHardware:(NSString*)fileName{
    if(IS_IPHONE_5){
        return [fileName stringByAppendingString:@"_ip5"];
    }else if(IS_IPHONE_6){
        return [fileName stringByAppendingString:@"_ip6"];
    }else if(IS_IPHONE_6P){
        return [fileName stringByAppendingString:@"_ip6p"];
    }
    return fileName;
}
@end
