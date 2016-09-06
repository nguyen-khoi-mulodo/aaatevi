//
//  WelcomeVC.m
//  NPlus
//
//  Created by Khoi Nguyen Nguyen on 7/21/16.
//  Copyright © 2016 TEVI Team. All rights reserved.
//

#import "WelcomeVC.h"

@interface WelcomeVC ()

@end

@implementation WelcomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_imvWel setImage:[UIImage imageNamed:[self imageNameWith:self.index]]];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (_index == 4) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"showButtonWelcome" object:nil];
    }
}

- (NSString*)imageNameWith:(NSInteger)index {
    NSString *imageName = @"";
    if (IS_IPHONE_4_OR_LESS) {
        imageName = [NSString stringWithFormat:@"wel%d_ip4.png",(int)index+1];
    } else if (IS_IPHONE_5) {
        imageName = [NSString stringWithFormat:@"wel%d_ip5.png",(int)index+1];
    } else if (IS_IPHONE_6) {
        imageName = [NSString stringWithFormat:@"wel%d_ip6.png",(int)index+1];
    } else if (IS_IPHONE_6P) {
        imageName = [NSString stringWithFormat:@"wel%d_ip6p.png",(int)index+1];
    } else {
        imageName = [NSString stringWithFormat:@"wel%d_ip6.png",(int)index+1];
    }
    return imageName;
}

- (IBAction)btnDoneAction:(id)sender {
    if (self.index == 4) {
        [APPDELEGATE start];
    }
}
@end
