//
//  CategoryListVC.h
//  NPlus
//
//  Created by Vo Chuong Thien on 1/11/16.
//  Copyright © 2016 TEVI Team. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "GenreSubListVC.h"

@protocol FilterListDelegate <NSObject>
- (void) showNewOrHot:(BOOL) isShow withFilter:(NSString*) filter;
@end

@interface FilterListVC : BaseVC{
    NSArray* listItems;
}
@property (nonatomic, strong) id <FilterListDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITableView *tbMain;
@property (nonatomic, strong) NSString* filterSelecting;
@end
