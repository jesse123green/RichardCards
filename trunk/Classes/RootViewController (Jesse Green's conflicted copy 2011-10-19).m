//
//  RootViewController.m
//  Richard Cards
//
//  Created by Alan Dickinson on 6/4/10.
//  Copyright n/a 2010. All rights reserved.
//

#import "RootViewController.h"
#import "MessageView.h"
#import "MyManager.h"
#import "QRCheckView.h"
#import "SBJson.h"
#import "Reachability.h"


@implementation RootViewController
QRCheckView *qrcheckView;

@synthesize txtEmail, resultText, internetActive, hostActive;


#pragma mark -
#pragma mark View lifecycle



- (void)viewDidLoad {
	
    txtEmail.borderStyle = UITextBorderStyleRoundedRect;
		
    [super viewDidLoad];

	
	NSLog(@"Launched");
	
	self.title = @"Home";
	
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	txtEmail.text = [prefs stringForKey:@"useremail"];
	
	
	//MyManager *manager = [MyManager sharedManager];
	//txtEmail.text = manager.theEmail;
    MyManager *manager = [MyManager sharedManager];
    
    //Clear QRCode
    NSLog(@"refreshed");

	
	//array = [[NSMutableArray alloc] init];
	//[array addObject:@"Message"];
	
	/* debugg 
	 
	 //CGRect myImageRect = CGRectMake(0.0f, 0.0f, 320.0f, 480.0f);
	 //UIImageView *myImage = [[UIImageView alloc] initWithFrame:myImageRect];
	 
	 UIImageView *myImage = [UIImageView alloc];
	 
	 [myImage setImage:[UIImage imageNamed:@"rc_main.png"]];
	 
	 [myImage setFrame:CGRectMake(0.0f, 0.0f, 320.0f, 480.0f)];
	 
	 myImage.opaque = YES; // explicitly opaque for performance
	 [self.view addSubview:myImage];
	 [myImage release];
	 
	 */
    

	
	
	
	
	
	UIButton *startButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[startButton setTitle:@"" forState:UIControlStateNormal];
	//startButton.frame = CGRectMake(0, 337, 320, 113);
	startButton.frame = CGRectMake(12, 168, 177, 55);
	[startButton setBackgroundImage:[UIImage imageNamed:@"btn_newrichard_pressed.png"] forState:UIControlStateNormal];
	[startButton setBackgroundImage:[UIImage imageNamed:@"btn_newrichard.png"] forState:UIControlStateHighlighted];	
	[startButton addTarget:self action:@selector(startButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:startButton];
    
    
    
    
    UIButton *replyButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[replyButton setTitle:@"" forState:UIControlStateNormal];
	//startButton.frame = CGRectMake(0, 337, 320, 113);
	replyButton.frame = CGRectMake(202, 168, 107, 55);
	[replyButton setBackgroundImage:[UIImage imageNamed:@"btn_replytoarichard.png"] forState:UIControlStateNormal];
	[replyButton setBackgroundImage:[UIImage imageNamed:@"btn_replytoarichard_pressed.png"] forState:UIControlStateHighlighted];	
	[replyButton addTarget:self action:@selector(replyButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:replyButton];
	
	
	//[startButton removeFromSuperview];
	
	
	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    
    // CHECK FOR INTERNET CONNECTION
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus:) name:kReachabilityChangedNotification object:nil];
    
    internetReachable = [[Reachability reachabilityForInternetConnection] retain];
    [internetReachable startNotifier];
    
    // check if a pathway to a random host exists
    hostReachable = [[Reachability reachabilityWithHostName: @"www.sendrichard.com"] retain];
    [hostReachable startNotifier];
    
    // now patiently wait for the notification
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

-(void) replyButtonPressed:(id)sender
{
    
    if(internetActive == NO){
            UIAlertView *someError = [[UIAlertView alloc] initWithTitle: @"No Internet Connection" message: @"Richard needs the internet to read a reply." delegate: self cancelButtonTitle: @"I'll Go Connect" otherButtonTitles: nil];
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
    
    
    // ADD: present a barcode reader that scans from the camera feed
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    
    ZBarImageScanner *scanner = reader.scanner;
    // TODO: (optional) additional reader configuration here
    
    // EXAMPLE: disable rarely used I2/5 to improve performance
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    
    // present and release the controller
    [self presentModalViewController: reader
                            animated: YES];
    [reader release];
}

}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    UIAlertView *someError = [[UIAlertView alloc] initWithTitle: @"Connection Error" message: @"Please Try Again" delegate: self cancelButtonTitle: @"I will" otherButtonTitles: nil];
    [someError show];
    [someError release];}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	[connection release];
    
    
        NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        [responseData release];
        
        NSError *error;
        SBJsonParser *json = [[SBJsonParser new] autorelease];
        
        MyManager *manager = [MyManager sharedManager];
        
        manager.oidReplyValid = [json objectWithString:responseString error:&error];
        [responseString release];
        
        NSLog(@"QR Code is: %@",[manager.oidReplyValid objectForKey:@"QRCHECK"]);
        
        
        if ([manager.oidReplyValid objectForKey:@"QRCHECK"] == NULL){
            UIAlertView *someError = [[UIAlertView alloc] initWithTitle: @"Connection Error" message: @"A connection error occurred. Please try again." delegate: self cancelButtonTitle: @"OK" otherButtonTitles: nil];
            [someError show];
            [someError release];
        }
        else {
            
        [self performSelector:@selector(dataStop) withObject:nil afterDelay:0.0];
        [self performSelector:@selector(finishRead) withObject:nil afterDelay:0.0];
           // NSLog(@"Complete... nice job");
        }
    

    // 2 is valid code, 1 is invalid code, 0 is connection error  
        
    }

- (void) dataStart {
	
    qrcheckView = [[QRCheckView alloc] initWithNibName:@"QRCheckView" bundle:nil];
    [self.view addSubview:qrcheckView.view];
	
}


- (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    // ADD: get the decode results
    id<NSFastEnumeration> results =
    [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        // EXAMPLE: just grab the first barcode
        break;
    
    // EXAMPLE: do something useful with the barcode data
    // resultText.text = symbol.data;
    
    MyManager *manager = [MyManager sharedManager];
    NSArray* stringComponents = [symbol.data componentsSeparatedByString:@"oid="];
	manager.oidReply = [stringComponents objectAtIndex:[stringComponents count]-1];
    
    NSLog(@"QRCode: %@", manager.oidReply);
    
    [reader dismissModalViewControllerAnimated: YES];
    
    [self dataStart];
    [self performSelector:@selector(dataSend) withObject:nil afterDelay:0.0];

    
    // EXAMPLE: do something useful with the barcode image
    // ADD: dismiss the controller (NB dismiss from the *reader*!)
    

}

- (void) finishRead {
    MyManager *manager = [MyManager sharedManager];  

    
    NSLog(@"Valid Code: %@", manager.oidReply);
    
    
    if ([[manager.oidReplyValid objectForKey:@"QRCHECK"] isEqualToString:@"ERROR"]) {
        
        UIAlertView *someError = [[UIAlertView alloc] initWithTitle: @"Connection Error" message: @"A connection error occurred. Please try again later." delegate: self cancelButtonTitle: @"OK" otherButtonTitles: nil];
		
		[someError show];
		[someError release];
    }
    else if([[manager.oidReplyValid objectForKey:@"QRCHECK"] isEqualToString:@"INVALID"]){
        UIAlertView *someError = [[UIAlertView alloc] initWithTitle: @"Invalid Code" message: @"The scanned code is invalid. Please try again." delegate: self cancelButtonTitle: @"OK" otherButtonTitles: nil];
		
		[someError show];
		[someError release];
    }
    else if([[manager.oidReplyValid objectForKey:@"QRCHECK"] isEqualToString:@"VALID"]){
        
        MessageView *messageview  = [[MessageView alloc] initWithNibName:@"MessageView" bundle:nil];
        [self.navigationController pushViewController:messageview animated:YES];
        [messageview release];
        
    }
}


- (void) dataSend {
    
    MyManager *manager = [MyManager sharedManager];
    
    
    NSString *myTempString = [[NSString alloc] initWithFormat:@"oid=%@", manager.oidReply];

    
	NSString *myRequestString = [myTempString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];   
    
	
	NSData *myRequestData = [ NSData dataWithBytes: [ myRequestString UTF8String ] length: [ myRequestString length ] ];
	NSMutableURLRequest *request = [ [ NSMutableURLRequest alloc ] initWithURL: [ NSURL URLWithString: @"https://sendrichard.com/orders/checkqr.php" ] ]; 
	[ request setHTTPMethod: @"POST" ];
	[ request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
	[ request setHTTPBody: myRequestData ];
    
    responseData = [[NSMutableData data] retain];
	connection1 = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    
    

    }

   

- (void) dataStop {
	
	[qrcheckView.view removeFromSuperview];
	
}

- (BOOL) validateEmail: (NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; 
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex]; 
	
    return [emailTest evaluateWithObject:candidate];
}

//- (BOOL)textFieldShouldReturn:(UITextField *)textField {

//[self.navigationController setNavigationBarHidden:YES animated:YES];

//}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
	
	UITouch * touch = [touches anyObject];
    if(touch.phase == UITouchPhaseBegan) {
        [self.txtEmail resignFirstResponder];
    }
}


- (void)textFieldDidBeginEditing:(UITextField *)textField {
	/*
	NSTimeInterval animationDuration = 0.300000011920929;
	CGRect frame = self.view.frame;
	frame.origin.y -= 215;
	frame.size.height += 0;
	[UIView beginAnimations:@"ResizeForKeyboard" context:nil];
	[UIView setAnimationDuration:animationDuration];
	self.view.frame = frame;
	[UIView commitAnimations];  
     */
	
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	/*
	NSTimeInterval animationDuration = 0.300000011920929;
	CGRect frame = self.view.frame;
	frame.origin.y += 215;
	frame.size.height += 0;
	[UIView beginAnimations:@"ResizeForKeyboard" context:nil];
	[UIView setAnimationDuration:animationDuration];
	self.view.frame = frame;
	[UIView commitAnimations];
    */
	
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
    
}

-(void)startButtonPressed:(id)sender {
	
	NSLog(@"startPressed");
	[txtEmail resignFirstResponder];
	/*
	 
	 ShowMoreController *controller = [[ShowMoreController alloc] initWithNibName:@"ShowMoreController" bundle:[NSBundle mainBundle]];
	 
	 controller.delegate = self;
	 [self.navigationController pushViewController:controller animated:YES];
	 [controller release];
	 controller = nil;
	 
	 */
	MyManager *manager = [MyManager sharedManager];
    
    //Clear QRCode

    manager.oidReply = @"";	
    [manager.oidReplyValid setObject:@"" forKey:@"QRCHECK"];

     
	
	if ([self validateEmail: [txtEmail text]]){
		NSLog(@"The email is valid?");
        manager.theEmail = [txtEmail text];
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setObject:txtEmail.text forKey:@"useremail"];
        [prefs synchronize];
        
	}
	else{
		NSLog(@"The email is not valid");
	}
    	
	
	MessageView *messageview  = [[MessageView alloc] initWithNibName:@"MessageView" bundle:nil];
	[self.navigationController pushViewController:messageview animated:YES];
	[messageview release];
	
	
}


/*
 - (void)viewWillAppear:(BOOL)animated {
 [super viewWillAppear:animated];
 }
 */
/*
 - (void)viewDidAppear:(BOOL)animated {
 [super viewDidAppear:animated];
 }
 */

 - (void)viewWillDisappear:(BOOL)animated {
 [super viewWillDisappear:animated];
[[NSNotificationCenter defaultCenter] removeObserver:self];
 }

/*
 - (void)viewDidDisappear:(BOOL)animated {
 [super viewDidDisappear:animated];
 }
 */

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */


#pragma mark -
#pragma mark Table view data source











// mega comment out
/*
 
 
 
 
 
 
 
 
 
 
 
 // Customize the number of sections in the table view.
 - (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
 return 1;
 }
 
 
 // Customize the number of rows in the table view.
 - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
 return [array count];
 }
 
 
 // Customize the appearance of table view cells.
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 
 static NSString *CellIdentifier = @"Cell";
 
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
 if (cell == nil) {
 cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
 }
 
 // Configure the cell.
 
 cell.textLabel.text = [array objectAtIndex:indexPath.row]; // added this line, all else in method is original
 return cell;
 }
 
 
 
 
 
 
 
 
 
 
 
 
 end mega comment out */













/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source.
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
 }   
 }
 */


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */


/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


#pragma mark -
#pragma mark Table view delegate

/*
 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 
 
 //all this is added
 [tableView deselectRowAtIndexPath:indexPath animated:YES];
 self.navigationController.navigationBarHidden = FALSE;
 
 if ([[array objectAtIndex:indexPath.row] isEqual:@"Message"]) 
 {
 MessageView *messageview  = [[MessageView alloc] initWithNibName:@"MessageView" bundle:nil];
 [self.navigationController pushViewController:messageview animated:YES];
 [messageview release];
 }
 
 
 }
 */

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	NSLog(@"Memory Warning");
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];

}


- (void)dealloc {
    [super dealloc];
}


@end

