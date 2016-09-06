//
//  MenuGenreViewController.h
//  NPlus
//
//  Created by Khoi Nguyen Nguyen on 12/29/15.
//  Copyright © 2015 TEVI Team. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuGenreViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>{
    
}

@property (nonatomic, strong) NSMutableArray *arrayMainGenres;
@property (nonatomic, strong) NSMutableArray *arraySubGenres;
@property (nonatomic, strong) NSString *type;

- (void)loadDataWithParentGenre:(NSString*)genreId;

@end
