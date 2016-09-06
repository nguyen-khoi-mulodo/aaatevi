//
//  ProfileView.h
//  NPlus
//
//  Created by Khoi Nguyen Nguyen on 12/24/15.
//  Copyright © 2015 TEVI Team. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *imgBgView;
@property (weak, nonatomic) IBOutlet UIImageView *imgProfile;
@property (weak, nonatomic) IBOutlet UILabel *lblName;


- (void)loadViewContentWithName:(NSString*)name bgImgLink:(NSString*)bgImgLink prfImgLink:(NSString*)prfImgLink ;
@end
