//
//  GlobalViewController.m
//  NPlus
//
//  Created by Vo Chuong Thien on 11/14/14.
//  Copyright (c) 2014 TEVI Team. All rights reserved.
//

#import "GlobalViewController.h"

@interface GlobalViewController ()

@end


@implementation GlobalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(historyViewClose) name:@"ShowOffHistoryView" object:nil];
    // Do any additional setup after loading the view.
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Action

- (void) showVideo:(id) item{
    if (self.delegate && [self.delegate respondsToSelector:@selector(showVideo:)]) {
        [self.delegate showVideo:item];
    }
}

- (void) showChannel:(id) item{
    if (self.delegate && [self.delegate respondsToSelector:@selector(showChannel:)]) {
        [self.delegate showChannel:item];
    }
}

- (void) showArtist:(id) item{
    if (self.delegate && [self.delegate respondsToSelector:@selector(showArtist:)]) {
        [self.delegate showArtist:item];
    }
}


- (void) showMenuAnimation:(BOOL) isShow{
    if (self.delegate && [self.delegate respondsToSelector:@selector(showMenuAnimation:)]) {
        [self.delegate showMenuAnimation:isShow];
    }
}

- (void) closeSearchView{
    if (self.delegate && [self.delegate respondsToSelector:@selector(closeSearchView)]) {
        [self.delegate closeSearchView];
    }
}

- (void) showRatingView:(id) vc{
    if (self.delegate && [self.delegate respondsToSelector:@selector(showRatingView:)]) {
        [self.delegate showRatingView:vc];
    }
}

- (void) showLoginWithTask:(NSString*) task withVC:(id) vc{
    if (self.delegate && [self.delegate respondsToSelector:@selector(showLoginWithTask:withVC:)]) {
        [self.delegate showLoginWithTask:task withVC:vc];
    }
}

- (void) hideLoginView{
    if (self.delegate && [self.delegate respondsToSelector:@selector(hideLoginView)]) {
        [self.delegate hideLoginView];
    }
}

//- (void) shareFacebookWithItem:(id) item{
//
//}



//- (void) showSerialViewWithData:(id) item{
//    if (self.delegate && [self.delegate respondsToSelector:@selector(showSerialViewWithData:)]) {
//        [self.delegate showSerialViewWithData:item];
//    }
//}
//
//- (IBAction) doShowHistoryView:(id)sender{
//    UIButton* btn = sender;
//    [btn setSelected:!btn.selected];
//    if (self.delegate && [self.delegate respondsToSelector:@selector(showHistoryView:)]) {
//        [self.delegate showHistoryView:btn.selected];
//    }
//}
//
//- (void) historyViewClose{
//    if (btnHistory.selected) {
//        [btnHistory setSelected:NO];
//    }
//}

- (IBAction) doBackHome:(id) sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(backToHome)]) {
        [self.delegate backToHome];
    }
}

//- (void) showRegisterView{
//    if (self.delegate && [self.delegate respondsToSelector:@selector(showRegisterView)]) {
//        [self.delegate showRegisterView];
//    }
//}
//
//- (void) showForgetPassword{
//    if (self.delegate && [self.delegate respondsToSelector:@selector(showForgetPassword)]) {
//        [self.delegate showForgetPassword];
//    }
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
