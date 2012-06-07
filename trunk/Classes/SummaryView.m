//
//  SummaryView.m
//  Richard Cards
//
//  Created by Alan Dickinson on 1/15/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import "SendingView.h"
#import "SummaryView.h"
#import "MyManager.h"
#import "PaymentView.h"

#import <QuartzCore/QuartzCore.h>


@implementation SummaryView
SendingView *sendingView;

@synthesize lineName,myImage,textClass,scrollView;

- (void) zoomCard {
    
	
    CGRect zoomRect;
    float scale = .85;    
    // the zoom rect is in the content view's coordinates.   
    //    At a zoom scale of 1.0, it would be the size of the imageScrollView's bounds.  
    //    As the zoom scale decreases, so more content is visible, the size of the rect grows.  
    zoomRect.size.height = [zoomView frame].size.height / scale;  
    zoomRect.size.width  = [zoomView frame].size.width  / scale;  
    zoomRect.size.height = myImage.frame.size.height / scale;  
    zoomRect.size.width  = myImage.frame.size.width  / scale;
    
    // choose an origin so as to get the right center.  
    zoomRect.origin.x    = 0;// - (zoomRect.size.width  / 2.0);  
    zoomRect.origin.y    = 44;// - (zoomRect.size.height / 2.0);
    [zoomView zoomToRect:zoomRect animated:YES];
    [timer invalidate];
    zoomView.maximumZoomScale = 0.85;
    zoomView.minimumZoomScale = 0.85;
}

- (void)viewDidLoad {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardWillHideNotification object:nil];

    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	sender_txtName.text = [prefs stringForKey:@"sender_txtName"];
    sender_txtAddressOne.text = [prefs stringForKey:@"sender_txtAddressOne"];
    sender_txtAddressTwo.text = [prefs stringForKey:@"sender_txtAddressTwo"];
    sender_txtCity.text = [prefs stringForKey:@"sender_txtCity"];
    sender_txtState.text = [prefs stringForKey:@"sender_txtState"];
    sender_txtZip.text = [prefs stringForKey:@"sender_txtZip"];
    
    [scrollView setContentSize:CGSizeMake(320, 435)];
    
    [zoomView setScrollEnabled:YES];
    [zoomView setPagingEnabled:YES];
    [zoomView setBounces:YES];
    
    //myImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"summary_card.png"]];
    
    myImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"postcard.png"]];
    
    [self setMyImage:myImage];
    
    zoomView.contentSize = CGSizeMake(myImage.frame.size.width, myImage.frame.size.height);
    zoomView.maximumZoomScale = 1.0;
    zoomView.minimumZoomScale = 1.0;
    //zoomView.clipsToBounds = YES;
    zoomView.delegate = self;
    
    zoomAllView = [[UIView alloc] init];
    zoomAllView.frame = CGRectMake(0, 0, 640, 320);
    zoomAllView.userInteractionEnabled = YES;
    
    
    
    [zoomAllView addSubview:myImage];
    
    NSLog(@"%f",myImage.frame.size.height);
    



	
	self.title = @"Preview";

	//init var manager
	MyManager *manager = [MyManager sharedManager];
    
    //Add next button
    /*
	UIBarButtonItem *btnNext = [[[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleBordered target:self action:@selector(nextButtonPressed:)]autorelease];    
	self.navigationItem.rightBarButtonItem = btnNext;
	*/
	
	if([manager.recip_address2 length] == 0 ){
		
		NSString *themessage =[NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@",manager.recip_name,@"\n",manager.recip_address1,@"\n",manager.recip_city,@", ",manager.recip_state,@"  ",manager.recip_zip];	
		lineName.text = themessage;
	
	} else {
		
		NSString *themessage =[NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@",manager.recip_name,@"\n",manager.recip_address1,@"\n",manager.recip_address2,@"\n",manager.recip_city,@", ",manager.recip_state,@"  ",manager.recip_zip];
		lineName.text = themessage;

	}
	
		
    [self.view addSubview:cardView];
	//cardView.frame = CGRectOffset(cardView.frame, 0, -335);
	
	cardView.frame = CGRectOffset(cardView.frame, -1100, -20);
	
	// adding a UIWebView for styling and formatting flexibility.
	
	CGRect webFrame = CGRectMake(0, 0, 640, 320); 
	webView = [[UIWebView alloc] initWithFrame:webFrame];  
	[webView setOpaque:NO];
	[webView setUserInteractionEnabled:NO];
	webView.backgroundColor = [UIColor clearColor];
	[zoomAllView addSubview:webView]; 
	
	NSUInteger lenght = [manager.theMessage length];
    NSString* htmlMessage;
    htmlMessage = [manager.theMessage stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];
    lenght = ([htmlMessage length] - lenght)/3;
    NSLog(@"Length difference is: %i",lenght);
	NSLog(@"%@",manager.theMessage);
    
    CGSize textSize = [manager.theMessage sizeWithFont:[UIFont systemFontOfSize:17.0f]];
    
    NSLog(@"text label width: %f", textSize.width); 
    
    lenght = lenght*230 + textSize.width;
    
    if(lenght < 100) {
        textClass = @"cardmessage-0";
    } else if(lenght < 200) {
        textClass = @"cardmessage-1";
    } else if(lenght < 300) {
        textClass = @"cardmessage-2";
    } else if(lenght < 400) {
        textClass = @"cardmessage-3";
    } else if(lenght < 500) {
        textClass = @"cardmessage-4";
    } else if(lenght < 600) {
        textClass = @"cardmessage-5";
    } else if(lenght < 700) {
        textClass = @"cardmessage-6";
    } else if(lenght < 800) {
        textClass = @"cardmessage-7";
    } else if(lenght < 900) {
        textClass = @"cardmessage-8";
    } else if(lenght < 1000) {
        textClass = @"cardmessage-9";
    } else {
        textClass = @"cardmessage-10";
    }
    
	NSString *html = [NSString stringWithFormat:@"<html><head><link rel=\"stylesheet\" type=\"text/css\" href=\"cardmessage.css\" /></head><body><div id=\"card\"><div id=\"%@\"><div class=\"outerContainer\"><div class=\"innerContainer\"><p>%@</p></div></div></div><div id=\"address\">%@</br>%@</br>%@</br>%@</br></div></body></html>", textClass, htmlMessage,manager.recip_name,manager.recip_address1,manager.recip_address2,[NSMutableString stringWithFormat:@"%@, %@  %@", manager.recip_city,manager.recip_state,manager.recip_zip]];  
	NSURL *baseURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
	[webView loadHTMLString:html baseURL:baseURL];

	
    [zoomView setClipsToBounds:NO];
	CGRect startFrame =[cardView frame];    
	[UIView beginAnimations:@"move10" context:NULL];
	[UIView setAnimationDuration:0.7];
	[UIView setAnimationDelay:0.4];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	
    [cardView setFrame:CGRectMake(startFrame.origin.x + 1100, startFrame.origin.y, startFrame.size.width, startFrame.size.height)];
	
	[UIView setAnimationDelegate:self];
	[UIView setAnimationCurve: UIViewAnimationCurveEaseIn];
	[UIView commitAnimations];
    
    [zoomView addSubview:zoomAllView];

    
    CGRect zoomRect;  
    float scale = .533;  
    //float scale = 1.0;   
    // the zoom rect is in the content view's coordinates.   
    //    At a zoom scale of 1.0, it would be the size of the imageScrollView's bounds.  
    //    As the zoom scale decreases, so more content is visible, the size of the rect grows.  
    zoomRect.size.height = [zoomView frame].size.height / scale;  
    zoomRect.size.width  = [zoomView frame].size.width  / scale;  
    zoomRect.size.height = myImage.frame.size.height / scale;  
    zoomRect.size.width  = myImage.frame.size.width  / scale;
    
    // choose an origin so as to get the right center.  
    zoomRect.origin.x    = 0;// - (zoomRect.size.width  / 2.0);  
    zoomRect.origin.y    = 0;// - (zoomRect.size.height / 2.0);
    //[zoomView zoomToRect:zoomRect animated:NO];
    
    //timer = [NSTimer scheduledTimerWithTimeInterval:0.6 target:self selector:@selector(zoomCard) userInfo:nil repeats:NO];
	
	
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[nextButton setTitle:@"" forState:UIControlStateNormal];
	nextButton.frame = CGRectMake(171, 350, 139, 55); //(17, 350, 286, 55)
	[nextButton setBackgroundImage:[UIImage imageNamed:@"looks_good_small.png"] forState:UIControlStateNormal];
	[nextButton setBackgroundImage:[UIImage imageNamed:@"looks_good_small_pressed.png"] forState:UIControlStateHighlighted];	
	[nextButton addTarget:self action:@selector(nextButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:nextButton];
    
    //UIImage * spiceButtonImg = [[UIImage imageNamed:@"spicebtn.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:26];
    //UIImage * spiceButtonSelectedImg = [[UIImage imageNamed:@"spicebtn_selected.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:26];
    
    
    NSString * addressBtnTitle = [NSString stringWithFormat:@"RETURN ADDRESS\n%@ %@\n%@, %@ %@", sender_txtAddressOne.text, sender_txtAddressTwo.text, sender_txtCity.text, sender_txtState.text, sender_txtZip.text]; 
    
    
    reviewAddressButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [reviewAddressButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    reviewAddressButton.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
    [reviewAddressButton setTitle:addressBtnTitle forState:UIControlStateNormal];
    [reviewAddressButton addTarget:self action:@selector(returnAddress:) forControlEvents:UIControlEventTouchUpInside];
    [reviewAddressButton.titleLabel setFont:[UIFont fontWithName:@"Gotham Rounded" size:10.0]];
    
    [reviewAddressButton setShowsTouchWhenHighlighted:YES];
    
    reviewAddressButton.frame = CGRectMake(12, 350, 150, 55);

    
    [self.view addSubview:reviewAddressButton];
    
    UIButton *nextButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
	[nextButton2 setTitle:@"" forState:UIControlStateNormal];
	nextButton2.frame = CGRectMake(17, 390, 286, 55); //(17, 350, 286, 55)
	[nextButton2 setBackgroundImage:[UIImage imageNamed:@"looksgood.png"] forState:UIControlStateNormal];
	[nextButton2 setBackgroundImage:[UIImage imageNamed:@"looksgood_pressed.png"] forState:UIControlStateHighlighted];	
	[nextButton2 addTarget:self action:@selector(resignAddress:) forControlEvents:UIControlEventTouchUpInside];
	[scrollView addSubview:nextButton2];
    
    [self.view addSubview:returnAddressView];
	returnAddressView.frame = CGRectOffset(cardView.frame, 0, 480);

    
}


/*
- (void)viewWillDisappear: (BOOL)animated
{
	[sendingIndicator stopAnimating];
}
*/
-(void)returnAddress:(id)sender {
    
	
	CGRect startFrame =[returnAddressView frame];    
	[UIView beginAnimations:@"move10" context:NULL];
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationDelay:0];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	
    [returnAddressView setFrame:CGRectMake(startFrame.origin.x, startFrame.origin.y - 480, startFrame.size.width, startFrame.size.height)];
	
	[UIView setAnimationDelegate:self];
	[UIView setAnimationCurve: UIViewAnimationCurveEaseIn];
	[UIView commitAnimations];
}




-(void)resignAddress:(id)sender {
	
	CGRect startFrame =[returnAddressView frame];    
	[UIView beginAnimations:@"move10" context:NULL];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationDelay:0];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	
    [returnAddressView setFrame:CGRectMake(startFrame.origin.x, startFrame.origin.y + 480, startFrame.size.width, startFrame.size.height)];
	
	[UIView setAnimationDelegate:self];
	[UIView setAnimationCurve: UIViewAnimationCurveEaseIn];
	[UIView commitAnimations];
    
    [activeField resignFirstResponder];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:sender_txtName.text forKey:@"sender_txtName"];
    [prefs setObject:sender_txtAddressOne.text forKey:@"sender_txtAddressOne"];
    [prefs setObject:sender_txtAddressTwo.text forKey:@"sender_txtAddressTwo"];
    [prefs setObject:sender_txtCity.text forKey:@"sender_txtCity"];
    [prefs setObject:sender_txtState.text forKey:@"sender_txtState"];
    [prefs setObject:sender_txtZip.text forKey:@"sender_txtZip"];
    [prefs synchronize];
    
}

- (void)keyboardWasHidden:(NSNotification *)aNotification { 
    
    CGRect frame = scrollView.frame;
	frame.origin.y -= 0;
	frame.size.height += 215;
	scrollView.frame = frame;
    
    
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    
    return zoomAllView;
    
}

- (void)keyboardWasShown:(NSNotification *)aNotification { 
    

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

- (void)textFieldDidBeginEditing:(UITextField *)textField {
	
    
    activeField = textField;
    NSLog(@"in texfieldediting");
    
    CGRect textFieldRect =
    [scrollView.window convertRect:textField.bounds fromView:textField];
    
    
    //NSLog(@"textFieldRect: %@", NSStringFromCGRect(textFieldRect));
    //NSLog(@"viewRect: %@", NSStringFromCGRect(viewRect));
    
    
    
    
    CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    
    if (fabs(scrollView.contentOffset.y - (scrollView.contentOffset.y + midline - 145.0)) > 1){
        
        [scrollView setContentOffset:CGPointMake(0, (scrollView.contentOffset.y + midline - 145.0)) animated:YES];  
        //NSLog(@"not equal");
        
    }
	//[self scrollViewToCenterOfScreen:textField]; 
	
}



- (void) dataStart {
	
    sendingView = [[SendingView alloc] initWithNibName:@"SendingView" bundle:nil];
    [self.view addSubview:sendingView.view];
	
}

- (void) dataStop {
	
	[sendingView.view removeFromSuperview];
	
}
 

- (void) dataSend {
	
	NSString *signature;		
	MyManager *manager = [MyManager sharedManager];
	
	//if (manager.theSwitch == 0){
		signature = @"0";
	//} else {
	//	signature = @"1";	
	//}
	
	NSLog(@"my ns string = %@", signature);
	NSString *myTempString = [[NSString alloc] initWithFormat:@"name=%@&address1=%@&address2=%@&city=%@&state=%@&zip=%@&message=%@&signed=%@&email=%@", manager.recip_name, manager.recip_address1, manager.recip_address2, manager.recip_city, manager.recip_state, manager.recip_zip, manager.theMessage, signature,manager.theEmail];
	
	//NSString *myTempString = [[NSString alloc] initWithFormat:@"city=%@&state=%@", manager.theCity, manager.theState];
	NSString *myRequestString = [myTempString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	NSData *myRequestData = [ NSData dataWithBytes: [ myRequestString UTF8String ] length: [ myRequestString length ] ];
	NSMutableURLRequest *request = [ [ NSMutableURLRequest alloc ] initWithURL: [ NSURL URLWithString: @"https://sendrichard.com/orders/insertorder.php" ] ]; 
	[ request setHTTPMethod: @"POST" ];
	[ request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
	[ request setHTTPBody: myRequestData ];
	NSURLResponse *response;
	NSError *err;
	NSData *returnData = [ NSURLConnection sendSynchronousRequest: request returningResponse:&response error:&err];
	//NSString *content = [NSString stringWithUTF8String:[returnData bytes]];
	//NSLog(@"responseData: %@", content);
	
}

-(void)nextButtonPressed:(id)sender {
	
	PaymentView *paymentview  = [[PaymentView alloc] initWithNibName:@"PaymentView" bundle:nil];
	[self.navigationController pushViewController:paymentview animated:YES];
	[paymentview release];
    [self performSelector:@selector(adjustZoomView) withObject:nil afterDelay:1.0];

	
}
	
-(void)adjustZoomView{
    
    [zoomView setContentOffset:CGPointMake(320, 0) animated:NO];
	
	
}

-(void)sendButtonPressed:(id)sender {

	[self dataStart];
	[self performSelector:@selector(dataSend) withObject:nil afterDelay:0.0];
	[self performSelector:@selector(dataStop) withObject:nil afterDelay:0.0];
	[self performSelector:@selector(gotoPayment) withObject:nil afterDelay:0.0];
	
	
}
 


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
//- (void)viewDidDisappear:(BOOL)animated {
//    [zoomView setContentOffset:CGPointMake(320, 0) animated:YES];
//    
//}
- (void)viewDidUnload {
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	//[sendingView release]; //causes a delayed crash. neat.
    [zoomView release];
    [webView release];
    [zoomAllView release];
    [myImage release];
    [super dealloc];
}


@end
