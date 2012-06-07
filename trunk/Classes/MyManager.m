//
//  MyManager.m
//  Richard Cards
//
//  Created by Alan Dickinson on 6/6/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "MyManager.h"

static MyManager *sharedMyManager = nil;

@implementation MyManager

@synthesize theMessageIntro;
@synthesize theMessage;

@synthesize recip_name;
@synthesize recip_address1;
@synthesize recip_address2;
@synthesize recip_city;
@synthesize recip_state;
@synthesize recip_zip;

@synthesize theEmail;
@synthesize oidReply;
@synthesize oidReplyValid;
@synthesize payJson,payKey;


#pragma mark Singleton Methods
+ (id)sharedManager {
	@synchronized(self) {
		if(sharedMyManager == nil)
			[[self alloc] init];
	}
	return sharedMyManager;
}
+ (id)allocWithZone:(NSZone *)zone {
	@synchronized(self) {
		if(sharedMyManager == nil)  {
			sharedMyManager = [super allocWithZone:zone];
			return sharedMyManager;
		}
	}
	return nil;
}
- (id)copyWithZone:(NSZone *)zone {
	return self;
}
- (id)retain {
	return self;
}
- (unsigned)retainCount {
	return UINT_MAX; //denotes an object that cannot be released
}
- (void)release {
	// never release
}
- (id)autorelease {
	return self;
}
- (id)init {
	if (self == [super init]) {
		
		theMessageIntro = [[NSString alloc] initWithString:@""];
		//theMessage = [[NSString alloc] initWithString:@"          abcdefg"];
        
        recip_name = [[NSString alloc] initWithString:@""];
        recip_address1 = [[NSString alloc] initWithString:@""];
        recip_address2 = [[NSString alloc] initWithString:@""];
        recip_city = [[NSString alloc] initWithString:@""];
        recip_state = [[NSString alloc] initWithString:@""];
        recip_zip = [[NSString alloc] initWithString:@""];
        oidReply = [[NSString alloc] initWithString:@""];
        
        
        
        
	}
}

- (void)dealloc {
	// Should never be called, but just here for clarity really.
	[theMessage release];
	[super dealloc];
}

@end