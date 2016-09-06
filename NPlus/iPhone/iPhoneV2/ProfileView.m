//
//  ProfileView.m
//  NPlus
//
//  Created by Khoi Nguyen Nguyen on 12/24/15.
//  Copyright © 2015 TEVI Team. All rights reserved.
//

#import "ProfileView.h"
#import "UIImage+ImageEffects.h"

@implementation ProfileView


- (void)layoutSubviews {
    
}

- (void)loadViewContentWithName:(NSString*)name bgImgLink:(NSString*)bgImgLink prfImgLink:(NSString*)prfImgLink {
    
    
    [_imgBgView.image applyLightEffect];
    [_imgProfile setImage:[Utilities getRoundedRectImageFromImage:_imgProfile.image onReferenceView:_imgProfile withCornerRadius:0.5]];
    _lblName.text = @"Duke Nguyen";
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
