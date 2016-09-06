//
//  TokenManager.m
//  NPlus
//
//  Created by TEVI Team on 10/23/14.
//  Copyright (c) 2014 TEVI Team. All rights reserved.
//

#import "TokenManager.h"
#import "APIController.h"
#import "Util.h"

#define ACCESS_TOKEN_KEY        @"ACCESS_TOKEN_KEY"
#define ACCESS_TIME_EXPIRE      @"ACCESS_TIME_EXPIRE"

typedef void (^loadCompleted)(NSString*);
typedef void (^loadFailed)(NSError*);
@interface TokenManager(){
    loadCompleted _loaded;
    loadFailed _failed;
    NSMutableArray *lstLoaded;
    NSMutableArray *lstFailed;
}
@end
@implementation TokenManager
static  TokenManager *sharedInstance = nil;
+(TokenManager *) sharedInstance{
    @synchronized(self){
        if (sharedInstance == nil) {
            sharedInstance = [[self alloc] init];
        }
    }
    return  sharedInstance;
}
+(id) allocWithZone:(NSZone *)zone{
    @synchronized(self){
        if (sharedInstance == nil) {
            sharedInstance = [super allocWithZone:zone];
            return  sharedInstance;
        }
    }
    return nil;
}

- (id)init
{
    self = [super init];
    if (self != nil) {
        lstLoaded = [[NSMutableArray alloc] init];
        lstFailed = [[NSMutableArray alloc] init];
        [self loadData];
    }
    return self;
}

- (BOOL)isExpired{
    if (_tokenInfo == nil) {
        return YES;
    }else{
        NSDate *dateExprite = [NSDate dateWithTimeIntervalSince1970:_tokenInfo.timeExpire/1000];
        NSDate *today = [NSDate date];
        NSComparisonResult result;
        result = [today compare:dateExprite];
        if(result == NSOrderedDescending)
            return YES;
    }
    
    return NO;
}

- (void)loadDataWithAccessToken:(void (^)(NSString *))_completed failed:(void (^)(NSError *))_fail{
        [lstLoaded addObject:_completed];
        [lstFailed addObject:_fail];
//        _loaded = _completed;
//        _failed = _fail;
        [self getAccessToken];
}

- (void)getAccessToken{
    [[APIController sharedInstance] getAccessTokenCompleted:^(id results) {
        if ([results isKindOfClass:[TokenInfo class]]) {
            self.tokenInfo = results;
            [self save];
            for (loadCompleted _com in lstLoaded) {
                _com(_tokenInfo.token);
            }
//            _loaded(_tokenInfo.token);
            [lstLoaded removeAllObjects];
            return;
        }
    } failed:^(NSError *error) {
        for (loadFailed _fal in lstFailed) {
            _fal(error);
        }
        [lstFailed removeAllObjects];
//        _failed(error);
    }];
}

-(void)setToken:(TokenInfo *)info{
    if (info) {
        self.tokenInfo = info;
        [self save];
    }
}

- (void)save{
//    if (_tokenInfo) {
//        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//        [defaults setObject:_tokenInfo.token forKey:ACCESS_TOKEN_KEY];
//        [defaults setObject:[NSNumber numberWithLongLong:_tokenInfo.timeExpire] forKey:ACCESS_TIME_EXPIRE];
//        [defaults synchronize];
//    }else{
//        NSLog(@"Cannot save token info is nil");
//    }
    if (_tokenInfo) {
        [[Util sharedInstance] saveToken:_tokenInfo];
        [UserDefaultManager setAccessToken:self.tokenInfo.token];
    }else{
        NSLog(@"Cannot save token info is nil");
    }
}

- (void)loadData{
    TokenInfo* info = [[Util sharedInstance] getToken];
    if (info) {
        _tokenInfo = [[TokenInfo alloc] init];
        _tokenInfo.token = info.token;
        _tokenInfo.timeExpire = info.timeExpire;
        NSDate *dateExprite = [NSDate dateWithTimeIntervalSince1970:info.timeExpire/1000];
        NSString *dateString = [NSDateFormatter localizedStringFromDate:dateExprite
                                                              dateStyle:NSDateFormatterShortStyle
                                                              timeStyle:NSDateFormatterFullStyle];
        _tokenInfo.strExpire = dateString;
        
    }
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    if ([defaults objectForKey:ACCESS_TOKEN_KEY] && [defaults objectForKey:ACCESS_TIME_EXPIRE]) {
//        _tokenInfo = [[TokenInfo alloc] init];
//        _tokenInfo.token = [defaults objectForKey:ACCESS_TOKEN_KEY];
//        long long time = [[defaults objectForKey:ACCESS_TIME_EXPIRE] longLongValue];
//        _tokenInfo.timeExpire = time;
//        NSDate *dateExprite = [NSDate dateWithTimeIntervalSince1970:time/1000];
//        NSString *dateString = [NSDateFormatter localizedStringFromDate:dateExprite
//                                                              dateStyle:NSDateFormatterShortStyle
//                                                              timeStyle:NSDateFormatterFullStyle];
//        _tokenInfo.strExpire = dateString;
//    }
}

@end
