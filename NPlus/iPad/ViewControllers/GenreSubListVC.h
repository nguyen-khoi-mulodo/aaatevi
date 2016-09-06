//
//  CategoryListVC.h
//  NPlus
//
//  Created by Vo Chuong Thien on 1/11/16.
//  Copyright © 2016 TEVI Team. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GenreSubListDelegate <NSObject>
- (void) selectGenreFromSubListGenre:(NSString*) subGenreId withGenreTitle:(NSString*) title;
@end

@interface GenreSubListVC : BaseVC{

}
@property (nonatomic, strong) id <GenreSubListDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITableView *tbMain;
@property (nonatomic, strong) NSString* genreId;

- (void)loadData:(NSArray*) list andTitle:(NSString*) title;
@end
