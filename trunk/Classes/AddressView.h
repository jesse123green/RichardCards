//
//  AddressView.h
//  Richard Cards
//
//  Created by Alan Dickinson on 6/4/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AddressBookUI/AddressBookUI.h>


@interface AddressView : UIViewController <UITextFieldDelegate, ABPeoplePickerNavigationControllerDelegate> {
	

	IBOutlet UITextField *recip_txtName;
	IBOutlet UITextField *recip_txtAddressOne;
	IBOutlet UITextField *recip_txtAddressTwo;
	IBOutlet UITextField *recip_txtCity;
	IBOutlet UITextField *recip_txtState;
	IBOutlet UITextField *recip_txtZip;
    
	IBOutlet UITextField *sender_txtName;
	IBOutlet UITextField *sender_txtAddressOne;
	IBOutlet UITextField *sender_txtAddressTwo;
	IBOutlet UITextField *sender_txtCity;
	IBOutlet UITextField *sender_txtState;
	IBOutlet UITextField *sender_txtZip;
    BOOL sendReceive;
	
	UITextField *activeField;
/*	BOOL *viewMoved;
	BOOL *keyboardShown;
*/	
	
}

- (IBAction)convert:(id)sender;
-(IBAction)getContact;
-(IBAction)getContact2;


@property (nonatomic,retain) IBOutlet UITextField *recip_txtName;
@property (nonatomic,retain) IBOutlet UITextField *recip_txtAddressOne;
@property (nonatomic,retain) IBOutlet UITextField *recip_txtAddressTwo;
@property (nonatomic,retain) IBOutlet UITextField *recip_txtCity;
@property (nonatomic,retain) IBOutlet UITextField *recip_txtState;
@property (nonatomic,retain) IBOutlet UITextField *recip_txtZip;

@property (nonatomic,retain) IBOutlet UITextField *sender_txtName;
@property (nonatomic,retain) IBOutlet UITextField *sender_txtAddressOne;
@property (nonatomic,retain) IBOutlet UITextField *sender_txtAddressTwo;
@property (nonatomic,retain) IBOutlet UITextField *sender_txtCity;
@property (nonatomic,retain) IBOutlet UITextField *sender_txtState;
@property (nonatomic,retain) IBOutlet UITextField *sender_txtZip;

@property (nonatomic,retain) IBOutlet UIScrollView *scrollView;



@end
