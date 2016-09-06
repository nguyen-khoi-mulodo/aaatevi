//
//  DevieInfo.h
//
//  Created by Vo Chuong Thien 25/02/2016.
//  Copyright 2016 NCTCORP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceInfo : NSObject {

	NSString* deviceId;
	NSString* deviceOsName;
	NSString* deviceOsVersion;
	NSString* deviceAppName;
	NSString* deviceAppVersion;
	NSString* userName;
	NSString* deviceName;
    NSString* provider;
    NSString* language;
}

@property(nonatomic,retain) NSString* deviceId;
@property(nonatomic,retain) NSString* deviceOsName;
@property(nonatomic,retain) NSString* deviceOsVersion;
@property(nonatomic,retain) NSString* deviceAppName;
@property(nonatomic,retain) NSString* deviceAppVersion;
@property(nonatomic,retain) NSString* userName;
@property(nonatomic,retain) NSString* deviceName;
@property(nonatomic,retain) NSString* provider;
@property(nonatomic,retain) NSString* language;
+(DeviceInfo*) sharedInstance;
-(NSString*) deviceInfo;


@end
