//
//  ConfirmAlertView.m
//  NPlus
//
//  Created by Admin on 5/16/16.
//  Copyright © 2016 TEVI Team. All rights reserved.
//

#import "ConfirmAlertView.h"

@interface ConfirmAlertView ()

@end

@implementation ConfirmAlertView

- (void)viewDidLoad {
    [super viewDidLoad];
    [infoView.layer setCornerRadius:7.0f];
    [infoView.layer setMasksToBounds:YES];
    
    [btnRemove.layer setBorderColor:[[UIColor redColor] CGColor]];
    [btnRemove.layer setBorderWidth:1.0f];
    [btnRemove.layer setCornerRadius:5.0];
    [btnRemove.layer setMasksToBounds:YES];
    [btnRemove setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
//    [btnCancel.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [btnCancel.layer setBorderColor:[UIColorFromRGB(0xa4a4a4) CGColor]];
    [btnCancel.layer setBorderWidth:1.0f];
    [btnCancel.layer setCornerRadius:5.0f];
    [btnCancel.layer setMasksToBounds:YES];
    [btnCancel setTitleColor:UIColorFromRGB(0xa4a4a4) forState:UIControlStateNormal];
    // Do any additional setup after loading the view from its nib.
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];
    tapGesture.delegate = self;
    [self.view addGestureRecognizer:tapGesture];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) doCancel:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancel)]) {
        [self.delegate cancel];
    }
}

- (IBAction) doRemove:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(remove)]) {
        [self.delegate remove];
    }
}

- (void) handleTapFrom:(UITapGestureRecognizer *)recognizer{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancel)]) {
        [self.delegate cancel];
    }
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    // Determine if the touch is inside the custom subview
    if ([touch view] == infoView){
        // If it is, prevent all of the delegate's gesture recognizers
        // from receiving the touch
        return NO;
    }
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
