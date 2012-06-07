
#import "SuccessViewController.h"
#import "PayPal.h"
#import "PayPalAdvancedPayment.h"
#import "PayPalPreapprovalDetails.h"
#import "MyManager.h"


@implementation SuccessViewController

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	self.view = [[[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] autorelease];
	self.view.autoresizesSubviews = FALSE;
	UIColor *color = [UIColor groupTableViewBackgroundColor];
	if (CGColorGetPattern(color.CGColor) == NULL) {
		color = [UIColor lightGrayColor];
	}
	self.view.backgroundColor = color;
	self.title = @"Success!";
	
	NSMutableString *buf = [NSMutableString string];
	
	[buf appendString:@"Congratulations!  You successfully "];
    
    
    //MyManager *manager = [MyManager sharedManager];
    
    //NSMutableDictionary *transactionDetails = [[PayPal getInstance] getTransactionDetailsWithPayKey:manager.payKey];
    
    

	
	if ([PayPal getInstance].payment != nil) {
		NSNumberFormatter *formatter = [[[NSNumberFormatter alloc] init] autorelease];
		[formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
		[formatter setCurrencyCode:[PayPal getInstance].payment.paymentCurrency];
		[formatter setNegativeFormat:[NSString stringWithFormat:@"-%@", [formatter positiveFormat]]];
		[buf appendFormat:@"paid %@ to ", [formatter stringFromNumber:[PayPal getInstance].payment.total]];
		
		NSString *recipient = nil;
		if ([PayPal getInstance].payment.singleReceiver != nil) {
			recipient = [PayPal getInstance].payment.singleReceiver.merchantName;
			if (recipient == nil || [PayPal getInstance].payment.isPersonal) {
				recipient = [PayPal getInstance].payment.singleReceiver.recipient;
			}
		} else {
			for (PPReceiverPaymentDetails *receiver in [PayPal getInstance].payment.receiverPaymentDetails) {
				if (receiver.merchantName.length > 0) {
					recipient = receiver.merchantName;
					break;
				}
			}
			if (recipient == nil) { //no merchant name provided on any of the recipients
				recipient = [NSMutableString string];
				for (PPReceiverPaymentDetails *receiver in [PayPal getInstance].payment.receiverPaymentDetails) {
					if (receiver.recipient.length > 0) {
						if (recipient.length > 0) {
							[(NSMutableString *)recipient appendString:@", "];
						}
						[(NSMutableString *)recipient appendString:receiver.recipient];
					}
				}
			}
		}
		[buf appendFormat:@"%@.", recipient];
	} else if ([PayPal getInstance].preapprovalDetails != nil) {
		NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
		[formatter setDateStyle:NSDateFormatterShortStyle];
		[formatter setTimeStyle:NSDateFormatterNoStyle];
		
		NSString *recipient = [PayPal getInstance].preapprovalDetails.merchantName;
		NSString *startDate = [formatter stringFromDate:[PayPal getInstance].preapprovalDetails.startDate];
		NSString *endDate = [formatter stringFromDate:[PayPal getInstance].preapprovalDetails.endDate];
		[buf appendFormat:@"preapproved payments to %@ from %@ until %@.", recipient, startDate, endDate];
	}
	
	UIFont *font = [UIFont systemFontOfSize:16.];
	CGSize size = [buf sizeWithFont:font constrainedToSize:CGSizeMake(self.view.frame.size.width - 20., MAXFLOAT)];
	UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(10., 10., self.view.frame.size.width - 20., size.height)] autorelease];
	label.backgroundColor = [UIColor clearColor];
	label.numberOfLines = 0;
	label.font = font;
	label.text = buf;
	[self.view addSubview:label];
	
	UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	button.frame = CGRectMake(round((self.view.frame.size.width - 294.) / 2.), label.frame.origin.y + label.frame.size.height + 10., 294., 43.);
	[button setTitle:@"Done" forState:UIControlStateNormal];
	[button addTarget:self action:@selector(backToMainMenu) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:button];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	self.navigationItem.hidesBackButton = TRUE;
}



- (void)backToMainMenu {
	[self.navigationController setNavigationBarHidden:TRUE animated:YES];
	[self.navigationController popToRootViewControllerAnimated:TRUE];
	

}

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

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


- (void)dealloc {
    [super dealloc];
}


@end
