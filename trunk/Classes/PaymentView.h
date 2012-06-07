//
//  PaymentView.h
//  Richard Cards
//
//  Created by Jesse Green on 3/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h> 
#import "PayPal.h" 

@class Reachability;

typedef enum PaymentStatuses {
	PAYMENTSTATUS_SUCCESS,
	PAYMENTSTATUS_FAILED,
	PAYMENTSTATUS_CANCELED,
} PaymentStatus;

@interface PaymentView : UIViewController <PayPalPaymentDelegate> { 

		PaymentStatus status;
    
    UITextField *editingField;
    
    	IBOutlet UITextField *ccNumber;

    IBOutlet UISegmentedControl *ccType;

    IBOutlet UITextField *ccMonth;

    IBOutlet UITextField *ccCSV;
    IBOutlet UITextField *ccFirst;
    IBOutlet UITextField *ccLast;
    
    IBOutlet UITextField *ccStreet1;

    
    IBOutlet UITextField *ccStreet2;

    IBOutlet UITextField *ccCity;

    IBOutlet UITextField *ccState;

        NSURLConnection *connection1;
        NSURLConnection *connection2;
    NSMutableData *responseData;

		IBOutlet UILabel *label;
    UIButton *sendButton;
    UIButton *button;
    
    Reachability* internetReachable;
    Reachability* hostReachable;
    BOOL internetActive;
    BOOL hostActive;
    BOOL ccCheckChange;
    NSString *ccNumberActual;

    
} 
//- (IBAction)backgroundTouched:(UITextField *)textField;

- (void) checkNetworkStatus:(NSNotification *)notice;
-(void)payWithPayPal; 
-(void)sendButtonPressed;
@property (nonatomic, retain) IBOutlet UITextField *ccMonth;
@property (nonatomic, retain) IBOutlet UITextField *ccCSV;
@property (nonatomic, retain) IBOutlet UITextField *ccFirst;
@property (nonatomic, retain) IBOutlet UITextField *ccLast;

@property (nonatomic,retain) IBOutlet UIScrollView *scrollView2;
@property (nonatomic,retain) IBOutlet UITextField *ccNumber;
@property (nonatomic, retain) IBOutlet UISegmentedControl *ccType;
@property (nonatomic, retain) IBOutlet UITextField *ccStreet1;
@property (nonatomic, retain) IBOutlet UITextField *ccStreet2;
@property (nonatomic, retain) IBOutlet UITextField *ccCity;
@property (nonatomic, retain) IBOutlet UITextField *ccState;
@property (nonatomic, retain) IBOutlet UITextField *ccZip;
@property (nonatomic, retain) NSString *ccNumberActual;




@end
