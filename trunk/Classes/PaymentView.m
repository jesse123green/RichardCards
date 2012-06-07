//
//  PaymentView.m
//  Richard Cards
//
//  Created by Jesse Green on 3/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PaymentView.h"
#import "PayPalPayment.h"
#import "PayPalAdvancedPayment.h"
#import "PayPalAmounts.h"
#import "PayPalReceiverAmounts.h"
#import "PayPalAddress.h"
#import "PayPalInvoiceItem.h"
#import "SuccessViewController.h"
#import "SendingView.h"
#import "SBJson.h"
#import "MyManager.h"
#import "SendPaymentView.h"
#import <QuartzCore/QuartzCore.h>
#import "Reachability.h"
#import <Security/Security.h>


@implementation PaymentView

SendingView *sendingView;
SendPaymentView *sendPaymentView;

@synthesize ccMonth;
@synthesize ccCSV;
@synthesize ccFirst;
@synthesize ccLast;
@synthesize ccStreet1;
@synthesize ccStreet2;
@synthesize ccCity;
@synthesize ccState;
@synthesize ccZip;

@synthesize ccType;



@synthesize scrollView2, ccNumber,ccNumberActual;
// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/
static NSString *serviceName = @"com.sendrichard.RichardCards";

- (NSMutableDictionary *)newSearchDictionary:(NSString *)identifier {
    NSMutableDictionary *searchDictionary = [[NSMutableDictionary alloc] init];  
	
    [searchDictionary setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
	
    NSData *encodedIdentifier = [identifier dataUsingEncoding:NSUTF8StringEncoding];
    [searchDictionary setObject:encodedIdentifier forKey:(id)kSecAttrGeneric];
    [searchDictionary setObject:encodedIdentifier forKey:(id)kSecAttrAccount];
    [searchDictionary setObject:serviceName forKey:(id)kSecAttrService];
	
    return searchDictionary; 
}

- (NSData *)searchKeychainCopyMatching:(NSString *)identifier {
    NSMutableDictionary *searchDictionary = [self newSearchDictionary:identifier];
	
    // Add search attributes
    [searchDictionary setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
	
    // Add search return types
    [searchDictionary setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
	
    NSData *result = nil;
    OSStatus status = SecItemCopyMatching((CFDictionaryRef)searchDictionary,
                                          (CFTypeRef *)&result);
	
    [searchDictionary release];
    return result;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    //Header Label
	self.title = @"Payment";
	[PayPal initializeWithAppID:@"APP-80W284485P519543T" forEnvironment:ENV_SANDBOX];
	//[PayPal initializeWithAppID:@"anything" forEnvironment:ENV_NONE];
	//Get the PayPal Library button. 
	//We will be handling the callback, 
	//so we declare 'self' as the target. 
	//We want a large button, so we use BUTTON_278x43. 
	//Our checkout method is 'payWithPayPal', 
	//and we pass through our payment type.
	//We can move the button afterward if desired. 

    

    ccCheckChange = NO;


    button = [[PayPal getInstance] getPayButtonWithTarget:self andAction:@selector(payWithPayPal) andButtonType:BUTTON_278x43];
	CGRect frame = button.frame;
	frame.origin.x = round((self.view.frame.size.width - button.frame.size.width) / 2.);
	frame.origin.y = round(25);
	button.frame = frame;
	[scrollView2 addSubview:button];
    
    sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[sendButton setTitle:@"" forState:UIControlStateNormal];
	//startButton.frame = CGRectMake(0, 337, 320, 153);
	sendButton.frame = CGRectMake(0, 487, 320, 113);
	[sendButton setBackgroundImage:[UIImage imageNamed:@"btn_sendit_normal.png"] forState:UIControlStateNormal];
	[sendButton setBackgroundImage:[UIImage imageNamed:@"btn_sendit_selected.png"] forState:UIControlStateHighlighted];	
	[sendButton addTarget:self action:@selector(sendButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	[scrollView2 addSubview:sendButton];
    
    [ccNumber addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    // CHECK FOR INTERNET CONNECTION
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus:) name:kReachabilityChangedNotification object:nil];
    
    internetReachable = [[Reachability reachabilityForInternetConnection] retain];
    [internetReachable startNotifier];
    
    // check if a pathway to a random host exists
    hostReachable = [[Reachability reachabilityWithHostName: @"www.sendrichard.com"] retain];
    [hostReachable startNotifier];
    
    // now patiently wait for the notification
    
    NSData *passwordData = [self searchKeychainCopyMatching:@"Password"];

        NSString *password = [[NSString alloc] initWithData:passwordData
                                                   encoding:NSUTF8StringEncoding];
        [passwordData release];
        NSLog(@"%@", password);
        
    
    
    NSUserDefaults *ccInfo = [NSUserDefaults standardUserDefaults];
    
    ccNumberActual = password;
    if ([ccNumberActual length] > 5) {
            ccNumber.text = [NSString stringWithFormat:@"%@%@",@"XXXXXXXXXXXX",[ccNumberActual substringFromIndex:([ccNumberActual length] - 4)]];
    }

    ccMonth.text = [ccInfo stringForKey:@"ccMonth"];
    ccCSV.text = [ccInfo stringForKey:@"ccCSV"];
	ccFirst.text = [ccInfo stringForKey:@"ccFirst"];
	ccLast.text = [ccInfo stringForKey:@"ccLast"];
    ccStreet1.text = [ccInfo stringForKey:@"ccStreet1"];
    ccStreet2.text = [ccInfo stringForKey:@"ccStreet2"];
    ccCity.text = [ccInfo stringForKey:@"ccCity"];
	ccState.text = [ccInfo stringForKey:@"ccState"];
	ccZip.text = [ccInfo stringForKey:@"ccZip"];
    



						
}

- (void) viewWillAppear: (BOOL)animated{
    [super viewWillAppear:animated];
    [scrollView2 setContentSize:CGSizeMake(320.0, 600.0)];
    
NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
[nc addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
//[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardDidHideNotification object:nil];
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}



- (BOOL)createKeychainValue:(NSString *)password forIdentifier:(NSString *)identifier {
    NSMutableDictionary *dictionary = [self newSearchDictionary:identifier];
    
    NSData *passwordData = [password dataUsingEncoding:NSUTF8StringEncoding];
    [dictionary setObject:passwordData forKey:(id)kSecValueData];
	
    OSStatus status = SecItemAdd((CFDictionaryRef)dictionary, NULL);
    [dictionary release];
	
    if (status == errSecSuccess) {
        return YES;
    }
    return NO;
}

- (BOOL)updateKeychainValue:(NSString *)password forIdentifier:(NSString *)identifier {
    
    NSMutableDictionary *searchDictionary = [self newSearchDictionary:identifier];
    NSMutableDictionary *updateDictionary = [[NSMutableDictionary alloc] init];
    NSData *passwordData = [password dataUsingEncoding:NSUTF8StringEncoding];
    [updateDictionary setObject:passwordData forKey:(id)kSecValueData];
	
    OSStatus status = SecItemUpdate((CFDictionaryRef)searchDictionary,
                                    (CFDictionaryRef)updateDictionary);
    
    [searchDictionary release];
    [updateDictionary release];
	
    if (status == errSecSuccess) {
        return YES;
    }
    return NO;
}

- (void) checkNetworkStatus:(NSNotification *)notice
{
    // called after network status changes
    
    NetworkStatus internetStatus = [internetReachable currentReachabilityStatus];
    switch (internetStatus)
    
    {
        case NotReachable:
        {
            NSLog(@"The internet is down.");
            internetActive = NO;
            
            break;
            
        }
        case ReachableViaWiFi:
        {
            NSLog(@"The internet is working via WIFI.");
            internetActive = YES;
            
            break;
            
        }
        case ReachableViaWWAN:
        {
            NSLog(@"The internet is working via WWAN.");
            internetActive = YES;
            
            break;
            
        }
    }
    
    NetworkStatus hostStatus = [hostReachable currentReachabilityStatus];
    switch (hostStatus)
    
    {
        case NotReachable:
        {
            NSLog(@"A gateway to the host server is down.");
            hostActive = NO;
            
            break;
            
        }
        case ReachableViaWiFi:
        {
            NSLog(@"A gateway to the host server is working via WIFI.");
            hostActive = YES;
            
            break;
            
        }
        case ReachableViaWWAN:
        {
            NSLog(@"A gateway to the host server is working via WWAN.");
            hostActive = YES;
            
            break;
            
        }
    }
}


- (void)keyboardWillShow:(NSNotification *)aNotification {    
    NSLog(@"keys shown");
    NSTimeInterval animationDuration = 0.300000011920929;
	CGRect frame = scrollView2.frame;
	frame.origin.y -= 0;
	frame.size.height -= 215;
	[UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:animationDuration];
	scrollView2.frame = frame;
	[UIView commitAnimations];

	

}

- (void)keyboardWillHide:(NSNotification *)aNotification { 
    NSLog(@"keys removed");
    
    NSTimeInterval animationDuration = 0.300000011920929;
	CGRect frame = scrollView2.frame;
	frame.origin.y += 0;
	frame.size.height += 215;
	[UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:animationDuration];
	scrollView2.frame = frame;
	[UIView commitAnimations];



     

}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    editingField = textField;
    
    CGFloat animatedDistance;
    
    CGRect textFieldRect =
    [scrollView2.window convertRect:textField.bounds fromView:textField];
    CGRect viewRect =
    [scrollView2.window convertRect:scrollView2.bounds fromView:scrollView2];
    
    //NSLog(@"textFieldRect: %@", NSStringFromCGRect(textFieldRect));
    //NSLog(@"viewRect: %@", NSStringFromCGRect(viewRect));
    


    
    CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;

     if (fabs(scrollView2.contentOffset.y - (scrollView2.contentOffset.y + midline - 145.0)) > 1){
         
    [scrollView2 setContentOffset:CGPointMake(0, (scrollView2.contentOffset.y + midline - 145.0)) animated:YES];  
         NSLog(@"not equal");
         
     }



        
        
  //  [self scrollViewToCenterOfScreen:textField];


}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	
	NSInteger nextTag = textField.tag + 1;
	UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
	NSLog(@"nexttag:%i",nextTag);
	
	if (nextResponder) {
		[nextResponder becomeFirstResponder];
	}
	else{
		[editingField resignFirstResponder];
        
        return YES;
    }
}

- (void) dataStart {
    sendingView = [[SendingView alloc] initWithNibName:@"SendingView" bundle:nil];
    [self.view addSubview:sendingView.view];
}

- (void) authStart {
    
    sendButton.enabled = NO;
    button.enabled = NO;
	
    sendPaymentView = [[SendPaymentView alloc] initWithNibName:@"SendPaymentView" bundle:nil];
    [self.view addSubview:sendPaymentView.view];

	
}

- (void) dataStop {
	
	[sendingView.view removeFromSuperview];
	
}



- (void) authStop {
	
	[sendPaymentView.view removeFromSuperview];
    NSLog(@"in authStop");
	
}

+ (NSString*)myMethod {
    NSMutableString *stringToReturn = [[NSMutableString alloc] init];
    [stringToReturn appendString:@"lorem ipsum"];
    
    return [stringToReturn autorelease];
}

- (NSString *)getReadyToSend:(NSString *)stringToFix{
    
    
    NSString * myRequestString = (NSString *)CFURLCreateStringByAddingPercentEscapes(
    NULL,
    (CFStringRef)stringToFix,
    NULL,
    (CFStringRef)@"!*'();:@&=+$,/?%#[]",
    kCFStringEncodingUTF8 );
    
    return [myRequestString autorelease];

}
- (void) authorizeCC {
    
    if (ccCheckChange == YES) {
        ccNumberActual = ccNumber.text;
    }
    
    NSString* newFirst = [self getReadyToSend:ccFirst.text];
    NSString* newLast = [self getReadyToSend:ccLast.text];
    NSString* newNumber = [self getReadyToSend:ccNumberActual];
    NSString* newMonth = [self getReadyToSend:ccMonth.text];
    NSString* newCSV = [self getReadyToSend:ccCSV.text];
    NSString* newStreet1 = [self getReadyToSend:ccStreet1.text];
    NSString* newStreet2 = [self getReadyToSend:ccStreet2.text];
    NSString* newCity = [self getReadyToSend:ccCity.text];
    NSString* newState = [self getReadyToSend:ccState.text];
    NSString* newZip = [self getReadyToSend:ccZip.text];
        

	NSMutableString *myTempString = [[NSString alloc] initWithFormat:@"ccFirst=%@&ccLast=%@&ccNumber=%@&ccMonth=%@&ccCSV=%@&ccStreet1=%@&ccStreet2=%@&ccCity=%@&ccState=%@&ccZip=%@", newFirst, newLast, newNumber, newMonth, newCSV, newStreet1, newStreet2, newCity, newState,newZip];
    
    NSString *myRequestString = myTempString;
    NSLog(myRequestString);
	
	NSData *myRequestData = [ NSData dataWithBytes: [ myRequestString UTF8String ] length: [ myRequestString length ] ];
	NSMutableURLRequest *request = [ [ NSMutableURLRequest alloc ] initWithURL: [ NSURL URLWithString: @"https://sendrichard.com/orders/paypal.php" ] ]; 
	[ request setHTTPMethod: @"POST" ];
	[ request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
	[ request setHTTPBody: myRequestData ];
    
    responseData = [[NSMutableData data] retain];
	connection1 = [[NSURLConnection alloc] initWithRequest:request delegate:self];
 
}

- (void) gotoSuccess {
	
	SuccessViewController *successview  = [[SuccessViewController alloc] initWithNibName:@"SuccessView" bundle:nil];
	[self.navigationController pushViewController:successview animated:YES];
	[successview release];
	
}

- (void) dataSend {
    
    MyManager *manager = [MyManager sharedManager];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    NSString* nrname = [self getReadyToSend:manager.recip_name];
    NSString* nraddress1 = [self getReadyToSend:manager.recip_address1];
    NSString* nraddress2 = [self getReadyToSend:manager.recip_address2];
    NSString* nrcity = [self getReadyToSend:manager.recip_city];
    NSString* nrstate = [self getReadyToSend:manager.recip_state];
    NSString* nrzip = [self getReadyToSend:manager.recip_zip];
    NSString* nmessage = [self getReadyToSend:manager.theMessage];
    NSString* nemail = [self getReadyToSend:manager.theEmail];
    NSString* nsname = [self getReadyToSend:[prefs stringForKey:@"sender_txtName"]];
    NSString* nsaddress1 = [self getReadyToSend:[prefs stringForKey:@"sender_txtAddressOne"]];
    NSString* nsaddress2 = [self getReadyToSend:[prefs stringForKey:@"sender_txtAddressTwo"]];
    NSString* nscity = [self getReadyToSend:[prefs stringForKey:@"sender_txtCity"]];
    NSString* nsstate = [self getReadyToSend:[prefs stringForKey:@"sender_txtState"]];
    NSString* nszip = [self getReadyToSend:[prefs stringForKey:@"sender_txtZip"]];


    
	NSString *myTempString = [[NSString alloc] initWithFormat:@"rname=%@&raddress1=%@&raddress2=%@&rcity=%@&rstate=%@&rzip=%@&message=%@&email=%@&sname=%@&saddress1=%@&saddress2=%@&scity=%@&sstate=%@&szip=%@&txid=%@&oid=%@", nrname, nraddress1,nraddress2,nrcity,nrstate,nrzip,nmessage,nemail,nsname,nsaddress1,nsaddress2,nscity,nsstate,nszip,[manager.payJson objectForKey:@"TRANSACTIONID"],manager.oidReply];
	
	//NSString *myTempString = [[NSString alloc] initWithFormat:@"city=%@&state=%@", manager.theCity, manager.theState];
	NSString *myRequestString = [myTempString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	NSData *myRequestData = [ NSData dataWithBytes: [ myRequestString UTF8String ] length: [ myRequestString length ] ];
	NSMutableURLRequest *request = [ [ NSMutableURLRequest alloc ] initWithURL: [ NSURL URLWithString: @"https://sendrichard.com/orders/insertorder.php" ] ]; 
	[ request setHTTPMethod: @"POST" ];
	[ request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
	[ request setHTTPBody: myRequestData ];

    responseData = [[NSMutableData data] retain];
	connection2 = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	
}




-(void)sendButtonPressed:(id)sender {
    
    
    if(internetActive == NO){
        UIAlertView *someError = [[UIAlertView alloc] initWithTitle: @"No Internet Connection" message: @"Richard needs the internet to operate." delegate: self cancelButtonTitle: @"I'll Go Connect" otherButtonTitles: nil];
        [someError show];
		[someError release];
        NSLog(@"internet not active");
        
    }
    else if(hostActive == NO) {
        
        UIAlertView *someError = [[UIAlertView alloc] initWithTitle: @"Host Error" message: @"Richard is having trouble; please try again later." delegate: self cancelButtonTitle: @"OK" otherButtonTitles: nil];
        [someError show];
		[someError release];
        
        NSLog(@"host not active");
        
        
    }
    
    else{
    
    [editingField resignFirstResponder];

    [self authStart];

	[self performSelector:@selector(authorizeCC) withObject:nil afterDelay:1.0];


    }
}

- (void) insertData {
    
        
    [self dataSend];
        //[self performSelector:@selector(dataSend) withObject:nil afterDelay:0.0];
        //[self performSelector:@selector(dataStop) withObject:nil afterDelay:0.0];
        
        
        
        //[self performSelector:@selector(insertData) withObject:nil afterDelay:3.0];
        //[self performSelector:@selector(gotoSuccess) withObject:nil afterDelay:0.0];
        //[pool release];
    

}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
        UIAlertView *someError = [[UIAlertView alloc] initWithTitle: @"Connection Error" message: @"Please Try Again" delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
        [someError show];
        [someError release];
    NSLog(@"%@",error.code);
    
    sendButton.enabled = YES;

	[sendPaymentView.view removeFromSuperview];
    [sendingView.view removeFromSuperview];}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	[connection release];
    
    if (connection == connection1){
    [self authStop];
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	[responseData release];
    
	NSError *error;
	SBJsonParser *json = [[SBJsonParser new] autorelease];
        
    MyManager *manager = [MyManager sharedManager];
	
    manager.payJson = [json objectWithString:responseString error:&error];
	[responseString release];
        
        NSLog(@"Transaction ID: %@",[manager.payJson objectForKey:@"TRANSACTIONID"]);
        
        NSString *checkTID = [NSString stringWithFormat:@"%@",[manager.payJson objectForKey:@"ACK"]];
        NSLog(@"ACK: %@",[manager.payJson objectForKey:@"ACK"]);

	if ([checkTID isEqualToString:@"Success"] || [checkTID isEqualToString:@"SuccessWithWarning"]){
        //Load working credit card to defaults
        
        [self createKeychainValue:ccNumberActual forIdentifier:@"Password"];
        [self updateKeychainValue:ccNumberActual forIdentifier:@"Password"];
        
        
        NSUserDefaults *ccInfo = [NSUserDefaults standardUserDefaults];

        [ccInfo setObject:ccMonth.text forKey:@"ccMonth"];
        [ccInfo setObject:ccCSV.text forKey:@"ccCSV"];
        [ccInfo setObject:ccFirst.text forKey:@"ccFirst"];
        [ccInfo setObject:ccLast.text forKey:@"ccLast"];
        [ccInfo setObject:ccStreet1.text forKey:@"ccStreet1"];
        [ccInfo setObject:ccStreet2.text forKey:@"ccStreet2"];
        [ccInfo setObject:ccCity.text forKey:@"ccCity"];
        [ccInfo setObject:ccState.text forKey:@"ccState"];
        [ccInfo setObject:ccZip.text forKey:@"ccZip"];

        [ccInfo synchronize];
        
        [self dataStart];
        [self performSelector:@selector(insertData) withObject:nil afterDelay:3.0f];
        NSLog(@"Complete... nice job");


    }
	else {
        NSLog(@"Failed!");
        UIAlertView *someError = [[UIAlertView alloc] initWithTitle: @"Transaction Error" message: @"Please check info and try again" delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
        [someError show];
		[someError release];
        
        sendButton.enabled = YES;

	}
         
    }
    
    else{ 
        [self dataStop];
        [self gotoSuccess];
        
        NSLog(@"Data Sent Successfully");}
}



- (void)textFieldDidEndEditing:(UITextField *)textField {
    

	
}

-(void)textFieldDidChange:(UITextField *)textField {
    
    if (ccCheckChange == YES) {
        return;
        
    }
    
    else{
    ccCheckChange = YES;
        if ([ccNumber.text length] != 1) {
            ccNumber.text = @"";
        }
    }

}


- (void)scrollViewToCenterOfScreen:(UIView *)theView { 
	
    CGFloat viewCenterY = scrollView2.center.y;  
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];  
	
	
    CGFloat availableHeight = 264.0; // 264 is middle. found by applicationFrame.size.height - keyboardBounds.size.height;  Remove area covered by keyboard  
	
    CGFloat y = (viewCenterY - availableHeight) / 2.0;  
    if (y < 0) {  
        y = 0;  
    }  
    NSLog(@"%f",y);
    //scrollView2.contentSize = CGSizeMake(applicationFrame.size.width, applicationFrame.size.height + 216.0);  // 216 = height of keyboard
    if (CGPointEqualToPoint(scrollView2.contentOffset, CGPointMake(0, y)) == NO){
    
    [scrollView2 setContentOffset:CGPointMake(0, y) animated:YES];  
        
    }
	
}
					
-(void)payWithPayPal { //Advanced Payment
    
    if(internetActive == NO){
        UIAlertView *someError = [[UIAlertView alloc] initWithTitle: @"No Internet Connection" message: @"Richard needs the internet to operate." delegate: self cancelButtonTitle: @"I'll Go Connect" otherButtonTitles: nil];
        [someError show];
		[someError release];
        NSLog(@"internet not active");

    }
    else if(hostActive == NO) {
        
        UIAlertView *someError = [[UIAlertView alloc] initWithTitle: @"Host Error" message: @"Richard is having trouble; please try again later." delegate: self cancelButtonTitle: @"OK" otherButtonTitles: nil];
        [someError show];
		[someError release];
        
        NSLog(@"host not active");
        
        
    }
    
    else{
	
	//dismiss any native keyboards
	//[preapprovalField resignFirstResponder];
	
	//optional, set shippingEnabled to TRUE if you want to display shipping
	//options to the user, default: TRUE
	[PayPal getInstance].shippingEnabled = FALSE;
	
	//optional, set dynamicAmountUpdateEnabled to TRUE if you want to compute
	//shipping and tax based on the user's address choice, default: FALSE
	[PayPal getInstance].dynamicAmountUpdateEnabled = FALSE;
	
	//optional, choose who pays the fee, default: FEEPAYER_EACHRECEIVER
	[PayPal getInstance].feePayer = FEEPAYER_EACHRECEIVER;
	
	//for a payment with a single recipient, use a PayPalPayment object
	PayPalPayment *payment = [[[PayPalPayment alloc] init] autorelease];
	payment.recipient = @"jesse1_1303692158_biz@gmail.com";
	payment.paymentCurrency = @"USD";
	payment.description = @"A Richard";
	payment.merchantName = @"Richard Cards";
	
	//subtotal of all items, without tax and shipping
	payment.subTotal = [NSDecimalNumber decimalNumberWithString:@"1.00"];
	
	//invoiceData is a PayPalInvoiceData object which contains tax, shipping, and a list of PayPalInvoiceItem objects
	payment.invoiceData = [[[PayPalInvoiceData alloc] init] autorelease];
	payment.invoiceData.totalShipping = [NSDecimalNumber decimalNumberWithString:@"0"];
	payment.invoiceData.totalTax = [NSDecimalNumber decimalNumberWithString:@"0.00"];
	
	//invoiceItems is a list of PayPalInvoiceItem objects
	//NOTE: sum of totalPrice for all items must equal payment.subTotal
	//NOTE: example only shows a single item, but you can have more than one
	payment.invoiceData.invoiceItems = [NSMutableArray array];
	PayPalInvoiceItem *item = [[[PayPalInvoiceItem alloc] init] autorelease];
	item.totalPrice = payment.subTotal;
	item.name = @"A Richard";
	item.itemCount = [NSDecimalNumber decimalNumberWithString:@"1"];
	item.itemPrice = [NSDecimalNumber decimalNumberWithString:@"1"];
	item.totalPrice = [item.itemPrice decimalNumberByMultiplyingBy:item.itemCount];
	[payment.invoiceData.invoiceItems addObject:item];
	
	[[PayPal getInstance] checkoutWithPayment:payment];
        
        MyManager *manager = [MyManager sharedManager];
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
        NSString* nrname = [self getReadyToSend:manager.recip_name];
        NSString* nraddress1 = [self getReadyToSend:manager.recip_address1];
        NSString* nraddress2 = [self getReadyToSend:manager.recip_address2];
        NSString* nrcity = [self getReadyToSend:manager.recip_city];
        NSString* nrstate = [self getReadyToSend:manager.recip_state];
        NSString* nrzip = [self getReadyToSend:manager.recip_zip];
        NSString* nmessage = [self getReadyToSend:manager.theMessage];
        NSString* nemail = [self getReadyToSend:manager.theEmail];
        NSString* nsname = [self getReadyToSend:[prefs stringForKey:@"sender_txtName"]];
        NSString* nsaddress1 = [self getReadyToSend:[prefs stringForKey:@"sender_txtAddressOne"]];
        NSString* nsaddress2 = [self getReadyToSend:[prefs stringForKey:@"sender_txtAddressTwo"]];
        NSString* nscity = [self getReadyToSend:[prefs stringForKey:@"sender_txtCity"]];
        NSString* nsstate = [self getReadyToSend:[prefs stringForKey:@"sender_txtState"]];
        NSString* nszip = [self getReadyToSend:[prefs stringForKey:@"sender_txtZip"]];
        
        
        
        NSString *myTempString = [[NSString alloc] initWithFormat:@"https://sendrichard.com/orders/get_tx_id2.php?rname=%@&raddress1=%@&raddress2=%@&rcity=%@&rstate=%@&rzip=%@&message=%@&email=%@&sname=%@&saddress1=%@&saddress2=%@&scity=%@&sstate=%@&szip=%@&oid=%@", nrname, nraddress1,nraddress2,nrcity,nrstate,nrzip,nmessage,nemail,nsname,nsaddress1,nsaddress2,nscity,nsstate,nszip,manager.oidReply];
        NSLog(@"%@",myTempString);
        [PayPal getInstance].payment.ipnUrl = myTempString;

        
    }
}

#pragma mark -
#pragma mark PayPalPaymentDelegate methods

//paymentSuccessWithKey:andStatus: is a required method. in it, you should record that the payment
//was successful and perform any desired bookkeeping. you should not do any user interface updates.
//payKey is a string which uniquely identifies the transaction.
//paymentStatus is an enum value which can be STATUS_COMPLETED, STATUS_CREATED, or STATUS_OTHER
- (void)paymentSuccessWithKey:(NSString *)payKey andStatus:(PayPalPaymentStatus)paymentStatus {
	status = PAYMENTSTATUS_SUCCESS;
    MyManager *manager = [MyManager sharedManager];
    manager.payKey = payKey;
}

//paymentFailedWithCorrelationID:andErrorCode:andErrorMessage: is a required method. in it, you should
//record that the payment failed and perform any desired bookkeeping. you should not do any user interface updates.
//correlationID is a string which uniquely identifies the failed transaction, should you need to contact PayPal.
//errorCode is generally (but not always) a numerical code associated with the error.
//errorMessage is a human-readable string describing the error that occurred.
- (void)paymentFailedWithCorrelationID:(NSString *)correlationID andErrorCode:(NSString *)errorCode andErrorMessage:(NSString *)errorMessage {
	status = PAYMENTSTATUS_FAILED;
}

//paymentCanceled is a required method. in it, you should record that the payment was canceled by
//the user and perform any desired bookkeeping. you should not do any user interface updates.
- (void)paymentCanceled {
	status = PAYMENTSTATUS_CANCELED;
}

//paymentLibraryExit is a required method. this is called when the library is finished with the display
//and is returning control back to your app. you should now do any user interface updates such as
//displaying a success/failure/canceled message.
- (void)paymentLibraryExit {
	UIAlertView *alert = nil;
	switch (status) {
		case PAYMENTSTATUS_SUCCESS:
			[self.navigationController pushViewController:[[[SuccessViewController alloc] init] autorelease] animated:TRUE];
			break;
		case PAYMENTSTATUS_FAILED:
			alert = [[UIAlertView alloc] initWithTitle:@"Order failed" 
											   message:@"Your order failed. Touch \"Pay with PayPal\" to try again." 
											  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
			break;
		case PAYMENTSTATUS_CANCELED:
			alert = [[UIAlertView alloc] initWithTitle:@"Order canceled" 
											   message:@"You canceled your order. Touch \"Pay with PayPal\" to try again." 
											  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
			break;
	}
	[alert show];
	[alert release];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


-(IBAction)backgroundTouched:(UITextField *)textField {
    
    [editingField resignFirstResponder];    

}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [ccType release];
    ccType = nil;
    [self setCcType:nil];
    [ccMonth release];
    ccMonth = nil;
    [self setCcMonth:nil];
    [ccCSV release];
    ccCSV = nil;
    [self setCcCSV:nil];
    [ccFirst release];
    ccFirst = nil;
    [self setCcFirst:nil];
    [ccLast release];
    ccLast = nil;
    [self setCcLast:nil];
    [ccStreet1 release];
    ccStreet1 = nil;
    [self setCcStreet1:nil];
    [ccStreet2 release];
    ccStreet2 = nil;
    [self setCcStreet2:nil];
    [ccStreet1 release];
    ccStreet1 = nil;
    [ccStreet2 release];
    ccStreet2 = nil;
    [ccCity release];
    ccCity = nil;
    [ccState release];
    ccState = nil;
    [ccState release];
    ccState = nil;
    [self setCcStreet1:nil];
    [self setCcStreet2:nil];
    [self setCcCity:nil];
    [self setCcState:nil];
    [self setCcZip:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {

    [super dealloc];
}


@end
