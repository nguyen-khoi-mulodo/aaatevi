//
//  WelcomeVC.h
//  NPlus
//
//  Created by Khoi Nguyen Nguyen on 7/21/16.
//  Copyright © 2016 TEVI Team. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WelcomeVC : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imvWel;
@property (weak, nonatomic) IBOutlet UIButton *btnDone;
@property (assign, nonatomic) NSInteger index;

@end
