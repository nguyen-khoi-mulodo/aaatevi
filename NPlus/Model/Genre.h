//
//  Genre.h
//  NPlus
//
//  Created by TEVI Team on 9/10/14.
//  Copyright (c) 2014 TEVI Team. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Genre : NSObject
@property (nonatomic, strong) NSString *genreId;
@property (nonatomic, strong) NSString *genreName;
@property (nonatomic, strong) NSArray *childGenres;
@property (nonatomic, strong) NSString *parentKey;
@property (nonatomic, assign) BOOL isParent;


@end
