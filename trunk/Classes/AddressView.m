//
//  AddressView.m
//  Richard Cards
//
//  Created by Alan Dickinson on 6/4/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "AddressView.h"
#import "SummaryView.h"
#import "MyManager.h"


@implementation AddressView



@synthesize recip_txtName, recip_txtAddressOne, recip_txtAddressTwo, recip_txtCity, recip_txtState, recip_txtZip, sender_txtName, sender_txtAddressOne, sender_txtAddressTwo, sender_txtCity, sender_txtState, sender_txtZip, scrollView;



 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
		
    }
    return self;
}




- (void) writeVariables {
	
	MyManager *manager = [MyManager sharedManager];
    
    manager.recip_name = [recip_txtName text];
    manager.recip_address1 = [recip_txtAddressOne text];
    manager.recip_address2 = [recip_txtAddressTwo text];
    manager.recip_city = [recip_txtCity text];
    manager.recip_state = [recip_txtState text];
    manager.recip_zip = [recip_txtZip text];
    
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:sender_txtName.text forKey:@"sender_txtName"];
    [prefs setObject:sender_txtAddressOne.text forKey:@"sender_txtAddressOne"];
    [prefs setObject:sender_txtAddressTwo.text forKey:@"sender_txtAddressTwo"];
    [prefs setObject:sender_txtCity.text forKey:@"sender_txtCity"];
    [prefs setObject:sender_txtState.text forKey:@"sender_txtState"];
    [prefs setObject:sender_txtZip.text forKey:@"sender_txtZip"];
    [prefs synchronize];

	
	
	//BOOL result1 = [self validateEmail: manager.theEmail];
	

	/*
	if ([manager.theName length] == 0) {
		
		UIAlertView *someError = [[UIAlertView alloc] initWithTitle: @"Incomplete Form" message: @"Please fill in a Name" delegate: self cancelButtonTitle: @"OK" otherButtonTitles: nil];
		
		[someError show];
		[someError release];
	}
	else if([manager.theAddress1 length] == 0 ){
		
		UIAlertView *someError = [[UIAlertView alloc] initWithTitle: @"Incomplete Form" message: @"Please fill in an Address" delegate: self cancelButtonTitle: @"OK" otherButtonTitles: nil];
		
		[someError show];
		[someError release];	
	}	
	else if([manager.theCity length] == 0 ){
		
		UIAlertView *someError = [[UIAlertView alloc] initWithTitle: @"Incomplete Form" message: @"Please fill in a City" delegate: self cancelButtonTitle: @"OK" otherButtonTitles: nil];
		
		[someError show];
		[someError release];	
	}	
	else if([manager.theState length] == 0 ){
		
		UIAlertView *someError = [[UIAlertView alloc] initWithTitle: @"Incomplete Form" message: @"Please fill in a State" delegate: self cancelButtonTitle: @"OK" otherButtonTitles: nil];
		
		[someError show];
		[someError release];	
	}	
	else if([manager.theZip length] == 0 ){
		
		UIAlertView *someError = [[UIAlertView alloc] initWithTitle: @"Incomplete Form" message: @"Please fill in a Zip" delegate: self cancelButtonTitle: @"OK" otherButtonTitles: nil];
		
		[someError show];
		[someError release];	
	}
	in
	else {
	*/	
		SummaryView *summaryview  = [[SummaryView alloc] initWithNibName:@"SummaryView" bundle:nil];
		[self.navigationController pushViewController:summaryview animated:YES];
		[summaryview release];
		
	//}
	

}

- (IBAction) convert: (id) sender {
	
	[self writeVariables];
	
    
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

	//Header Label
	self.title = @"Address";
	
	////////////////

	
	
	
	
	
	//////////////

	
	MyManager *manager = [MyManager sharedManager];      
    
    recip_txtName.text = manager.recip_name;
    recip_txtAddressOne.text = manager.recip_address1;
    recip_txtAddressTwo.text = manager.recip_address2;
    recip_txtCity.text = manager.recip_city;
    recip_txtState.text = manager.recip_state;
    recip_txtZip.text = manager.recip_zip;
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	sender_txtName.text = [prefs stringForKey:@"sender_txtName"];
    sender_txtAddressOne.text = [prefs stringForKey:@"sender_txtAddressOne"];
    sender_txtAddressTwo.text = [prefs stringForKey:@"sender_txtAddressTwo"];
    sender_txtCity.text = [prefs stringForKey:@"sender_txtCity"];
    sender_txtState.text = [prefs stringForKey:@"sender_txtState"];
    sender_txtZip.text = [prefs stringForKey:@"sender_txtZip"];
    



	
	//Add next button
	UIBarButtonItem *btnNext = [[[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleBordered target:self action:@selector(convert:)]autorelease];    
	self.navigationItem.rightBarButtonItem = btnNext;
	
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
	


    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardWillHideNotification object:nil];

}



/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/



-(void)viewWillAppear:(BOOL)animated { 
//	[self.navigationController setNavigationBarHidden:NO animated:YES]; // hides
	
    
//[txtName becomeFirstResponder];


    [super viewWillAppear:animated];
    [scrollView setContentSize:CGSizeMake(320, 560)];
    
     //   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardDidHideNotification object:nil];
       // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];

    

}

- (void)keyboardWasShown:(NSNotification *)aNotification { 
    
    NSLog(@"keys shown");
    NSTimeInterval animationDuration = 0.300000011920929;
	CGRect frame = scrollView.frame;
	frame.origin.y -= 0;
	frame.size.height -= 215;
	[UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:animationDuration];
	scrollView.frame = frame;
	[UIView commitAnimations];
    
	
    
}

- (void)keyboardWasHidden:(NSNotification *)aNotification {
    
    NSLog(@"rect1: %@", NSStringFromCGRect(scrollView.frame));
    
    if (CGRectEqualToRect(scrollView.frame, CGRectMake(0,-2,320, 418)) == NO) {
        
    
    NSLog(@"keys removed");
    
    NSTimeInterval animationDuration = 0.300000011920929;
	CGRect frame = scrollView.frame;
	frame.origin.y += 0;
	frame.size.height += 215;
	[UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:animationDuration];
	scrollView.frame = frame;
	[UIView commitAnimations];
    
    }
    
    
    
    
}




- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	
	NSInteger nextTag = textField.tag + 1;
	UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
	
	
	if (nextResponder) {
		[nextResponder becomeFirstResponder];
        return NO;
	}
	else{
		[self writeVariables];
        return YES;
    }
}

////////////

-(IBAction)getContact {
    sendReceive = 0;
	// creating the picker
	ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
	// place the delegate of the picker to the controller
	picker.peoplePickerDelegate = self;
	
	// showing the picker
	[self presentModalViewController:picker animated:YES];
	// releasing
	[picker release];
}

-(IBAction)getContact2 {
    sendReceive = 1;
	// creating the picker
	ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
	// place the delegate of the picker to the controller
	picker.peoplePickerDelegate = self;
	
	// showing the picker
	[self presentModalViewController:picker animated:YES];
	// releasing
	[picker release];
}

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker {
    // assigning control back to the main controller
	[self dismissModalViewControllerAnimated:YES];
}
- (BOOL)peoplePickerNavigationController: (ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    
    if (sendReceive == 0) {
        recip_txtAddressOne.text = @"";
        recip_txtCity.text = @"";
        recip_txtState.text = @"";
        recip_txtZip.text = @"";
    }else{
        sender_txtAddressOne.text = @"";
        sender_txtCity.text = @"";
        sender_txtState.text = @"";
        sender_txtZip.text = @"";
    }

	
	
	
	// setting the first name
    NSString *myTempString1 = (NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
	
	// setting the last name
    NSString *myTempString2 = (NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
	NSLog(@"Address One = %@", myTempString2);
    
    if (sendReceive == 0) {
        if (myTempString1 == nil) {
            recip_txtName.text = [[NSString alloc] initWithFormat:@"%@", myTempString2];
        }else if (myTempString2 == nil){
            recip_txtName.text = [[NSString alloc] initWithFormat:@"%@", myTempString1];	
        }else {
            recip_txtName.text = [[NSString alloc] initWithFormat:@"%@ %@", myTempString1, myTempString2];
        }
    }else{
        if (myTempString1 == nil) {
            sender_txtName.text = [[NSString alloc] initWithFormat:@"%@", myTempString2];
        }else if (myTempString2 == nil){
            sender_txtName.text = [[NSString alloc] initWithFormat:@"%@", myTempString1];	
        }else {
            sender_txtName.text = [[NSString alloc] initWithFormat:@"%@ %@", myTempString1, myTempString2];
        }
    }

    
	ABMultiValueRef name1 =(NSString*)ABRecordCopyValue(person,kABPersonPhoneProperty);
	//NSString* mobile=@"";
	NSString* mobileLabel;
	for(CFIndex i=0;i<ABMultiValueGetCount(name1);i++)
	{
		mobileLabel=(NSString*)ABMultiValueCopyLabelAtIndex(name1, i);

	}
    
	ABMutableMultiValueRef multiValue = ABRecordCopyValue(person, kABPersonAddressProperty);
	for(CFIndex i=0;i<ABMultiValueGetCount(multiValue);i++)
	{
		
        
        CFDictionaryRef dict = ABMultiValueCopyValueAtIndex(multiValue, 0);
        CFStringRef street = CFDictionaryGetValue(dict, kABPersonAddressStreetKey);
        CFStringRef city = CFDictionaryGetValue(dict, kABPersonAddressCityKey);
        CFStringRef state = CFDictionaryGetValue(dict, kABPersonAddressStateKey);
        CFStringRef zip = CFDictionaryGetValue(dict, kABPersonAddressZIPKey);	
        CFRelease(dict);
		
        if (sendReceive == 0) {
            recip_txtAddressOne.text = (NSString *)street;
            recip_txtCity.text = (NSString *)city;
            recip_txtState.text = (NSString *) state;
            recip_txtZip.text = (NSString *) zip;
        } else{
            sender_txtAddressOne.text = (NSString *)street;
            sender_txtCity.text = (NSString *)city;
            sender_txtState.text = (NSString *) state;
            sender_txtZip.text = (NSString *) zip;
        }

        
		
	}
	// remove the controller
    [self dismissModalViewControllerAnimated:YES];
	
    return NO;
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier{
    return NO;
}

//////////

- (void)textFieldDidBeginEditing:(UITextField *)textField {
	
    
    activeField = textField;
    
    
    CGRect textFieldRect =
    [scrollView.window convertRect:textField.bounds fromView:textField];

    
    //NSLog(@"textFieldRect: %@", NSStringFromCGRect(textFieldRect));
    //NSLog(@"viewRect: %@", NSStringFromCGRect(viewRect));
    
    
    
    
    CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    
    if (fabs(scrollView.contentOffset.y - (scrollView.contentOffset.y + midline - 145.0)) > 1){
        
        [scrollView setContentOffset:CGPointMake(0, (scrollView.contentOffset.y + midline - 145.0)) animated:YES];  
        NSLog(@"not equal");
        
    }
	//[self scrollViewToCenterOfScreen:textField]; 
	
}

- (void)textFieldDidEndEditing:(UITextField *)textField {

	
}

-(IBAction)backgroundTouched:(UITextField *)textField {
    
    
    
    [activeField resignFirstResponder];
    
    
    
}



- (void)scrollViewToCenterOfScreen:(UIView *)theView { 
	
    CGFloat viewCenterY = theView.center.y;  
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];  
	
	
    CGFloat availableHeight = 340.0; // 264 is middle. found by applicationFrame.size.height - keyboardBounds.size.height;  Remove area covered by keyboard  
	
    CGFloat y = viewCenterY - availableHeight / 2.0;  
    if (y < 0) {  
        y = 0;  
    }  
    scrollView.contentSize = CGSizeMake(applicationFrame.size.width, applicationFrame.size.height + 216.0);  // 216 = height of keyboard
    [scrollView setContentOffset:CGPointMake(0, y) animated:YES];  
	
} 

-(void)viewWillDisappear:(BOOL)animated { 
	
	NSArray *viewControllers = self.navigationController.viewControllers;
	if (viewControllers.count > 1 && [viewControllers objectAtIndex:viewControllers.count-2] == self) {
		// View is aring because a new view controller was pushed onto the stack
		
	} else if ([viewControllers indexOfObject:self] == NSNotFound) {
		// View is aring because it was popped from the stack
		
		MyManager *manager = [MyManager sharedManager];

        manager.recip_name = [recip_txtName text];
        manager.recip_address1 = [recip_txtAddressOne text];
        manager.recip_address2 = [recip_txtAddressTwo text];
        manager.recip_city = [recip_txtCity text];
        manager.recip_state = [recip_txtState text];
        manager.recip_zip = [recip_txtZip text];
        
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setObject:sender_txtName.text forKey:@"sender_txtName"];
        [prefs setObject:sender_txtAddressOne.text forKey:@"sender_txtAddressOne"];
        [prefs setObject:sender_txtAddressTwo.text forKey:@"sender_txtAddressTwo"];
        [prefs setObject:sender_txtCity.text forKey:@"sender_txtCity"];
        [prefs setObject:sender_txtState.text forKey:@"sender_txtState"];
        [prefs setObject:sender_txtZip.text forKey:@"sender_txtZip"];
        [prefs synchronize];
		
		//if (![self.navigationController isNavigationBarHidden])
			//[self.navigationController setNavigationBarHidden:YES animated:YES]; // hide cuz we're goin back to the main screen

		
	}	
	
}


- (void)dealloc {
    [super dealloc];
}






@end
