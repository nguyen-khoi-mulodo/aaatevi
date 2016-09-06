//
//  SubListVideoVC.h
//  NPlus
//
//  Created by Vo Chuong Thien on 11/6/14.
//  Copyright (c) 2014 TEVI Team. All rights reserved.
//


#import "GridViewBaseVC.h"
#import "Constant.h"


@interface SearchListItemsVC : GridViewBaseVC
{
    IBOutlet UIGridView* gridView;
    NSString* mKeyWord;
}

- (void) loadDataWithKeyWord:(NSString*) keyWord andListType:(ListType) type;

@end
