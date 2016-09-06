//
//  SearchTypeVC.h
//  NPlus
//
//  Created by Anh Le Duc on 10/2/14.
//  Copyright (c) 2014 anhld. All rights reserved.
//

#import "BaseVC.h"

@interface SearchTypeVC : BaseVC
@property (weak, nonatomic) IBOutlet UICollectionView *cvMain;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *genre_id;
@property (nonatomic, copy) NSString *keyword;
@end
