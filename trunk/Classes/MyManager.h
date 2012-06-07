//
//  MyManager.h
//  Richard Cards
//
//  Created by Alan Dickinson on 6/6/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MyManager : NSObject {

	NSString *theMessageIntro;
	NSString *theMessage;
    
    NSString *recip_name;
    NSString *recip_address1;
    NSString *recip_address2;
    NSString *recip_city;
    NSString *recip_state;
    NSString *recip_zip;
    
	NSString *theEmail;
    NSString *oidReply;
    NSMutableDictionary *oidReplyValid;
    NSDictionary *payJson;
    NSString *payKey;



}

@property (nonatomic, retain) NSString *theMessageIntro;
@property (nonatomic, retain) NSString *theMessage;

@property (nonatomic, retain) NSString *recip_name;
@property (nonatomic, retain) NSString *recip_address1;
@property (nonatomic, retain) NSString *recip_address2;
@property (nonatomic, retain) NSString *recip_city;
@property (nonatomic, retain) NSString *recip_state;
@property (nonatomic, retain) NSString *recip_zip;


@property (nonatomic, retain) NSString *theEmail;
@property (nonatomic, retain) NSString *oidReply;
@property (nonatomic, retain) NSString *payKey;
@property (nonatomic, retain) NSMutableDictionary *oidReplyValid;
@property (nonatomic, retain) NSDictionary *payJson;


+ (id)sharedManager;

@end
