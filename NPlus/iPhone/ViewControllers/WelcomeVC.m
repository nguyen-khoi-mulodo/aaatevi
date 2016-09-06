//
//  WelcomeVC.m
//  NPlus
//
//  Created by Anh Le Duc on 12/10/14.
//  Copyright (c) 2014 anhld. All rights reserved.
//

#import "WelcomeVC.h"
#import "ESConveyorBelt.h"
#import "WelcomeBuilder.h"
@interface WelcomeVC ()

@end

@implementation WelcomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    // Do any additional setup after loading the view from its nib.
    
    NSArray *elements = [WelcomeBuilder buildTutorialWithTarget:self];
    UIViewController *controller = [[ESConveyorController alloc] initWithPages:3 elements:elements];
    CGSize size = [[UIScreen mainScreen] bounds].size;
    controller.view.frame = CGRectMake(0, 0, size.width, size.height);
    controller.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:controller animated:NO completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
}

@end
