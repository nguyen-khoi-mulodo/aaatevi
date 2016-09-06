//
//  DevieInfo.m
//  NCTV2
//
//  Created by Huy Tran on 7/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DeviceInfo.h"
#import "UIDevice+IdentifierAddition.h"

#define		DEVICEFORMAT	@"{\"deviceID\":\"%@\",\"osName\":\"%@\",\"osVersion\":\"%@\",\"appName\":\"%@\",\"appVersion\":\"%@\",\"userName\":\"%@\",\"deviceName\":\"%@\",\"provider\":\"%@\", \"language\":\"%@\"}"

@implementation DeviceInfo
@synthesize deviceId,deviceOsName,deviceOsVersion,deviceAppName,deviceAppVersion,
userName, deviceName, provider, language;

#pragma mark Instance
static DeviceInfo* _sharedInstance = nil;

+(DeviceInfo*) sharedInstance{
	
	@synchronized([DeviceInfo class])
	{
		if (_sharedInstance == nil)
			_sharedInstance = [[self alloc] init];
	}
	
	return _sharedInstance;
}

+(id) alloc
{
	@synchronized([DeviceInfo class])
	{
		NSAssert(_sharedInstance == nil, 
				 @"Attempted to allocate a second instance of a singleton.");
		_sharedInstance = [super alloc];
		
		return _sharedInstance;
	}
	
	return nil;
}

-(id)init {
	self = [super init];
	if (self != nil) {
		self.deviceId = [[UIDevice currentDevice] uniqueGlobalDeviceIdentifier];
		self.deviceOsName = kOSName;
		self.deviceOsVersion = [[UIDevice currentDevice] systemVersion];
		self.deviceAppName = kAppName;
		self.deviceAppVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
		self.userName = @"";
		self.deviceName = [[UIDevice currentDevice] hardwareDescription];
        self.provider = kProvider;
        self.language = kLanguage;
	}
	return self;
}

-(id)copyWithZone:(NSZone *)zone
{
	return (self);
}

-(NSString*) deviceInfo
{
    if(APPDELEGATE.user)
	{
        self.userName = APPDELEGATE.user.userName;
	}
    else
    {
		self.userName = @"";
	}
	NSString* info = [NSString stringWithFormat:DEVICEFORMAT,self.deviceId,
					  self.deviceOsName,self.deviceOsVersion,
					  self.deviceAppName,self.deviceAppVersion,
					  self.userName,self.deviceName, self.provider, self.language];
	return info ;
}

//-(NSString *)deviceInfoNoEncoding{
//    NSString* info = [NSString stringWithFormat:DEVICEFORMAT2,self.deviceId,
//                      self.deviceOsName,self.deviceOsVersion,
//                      self.deviceAppName,self.deviceAppVersion,
//                      @"",self.userLocation, @"0"];
//    return info;
//}
@end
