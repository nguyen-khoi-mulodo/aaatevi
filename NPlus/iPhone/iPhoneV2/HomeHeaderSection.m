//
//  HomeHeaderSection.m
//  NPlus
//
//  Created by Khoi Nguyen Nguyen on 4/25/16.
//  Copyright © 2016 TEVI Team. All rights reserved.
//

#import "HomeHeaderSection.h"

@implementation HomeHeaderSection

- (IBAction)btnHeaderTapped:(id)sender {
    if ([_delegate respondsToSelector:@selector(headerTappedWithTitle:isHide:)]) {
        [_delegate headerTappedWithTitle:_lblHeader.text isHide:_isHideButton];
    }
}


@end
