//
//  MessageView.m
//  Richard Cards
//
//  Created by Alan Dickinson on 6/4/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "MessageView.h"
#import "AddressView.h"
#import "MyManager.h"
#import "SummaryView.h"


@implementation MessageView

@synthesize msgTextField, liveOutputTextView, spiceButton, approaches, whichApproach;

// set active spacing amount
//#define ACTIVE_SPACER_LENGTH 18



/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
 // Custom initialization
 }
 return self;
 }
 */


- (void)viewDidLoad {
	
    
    approaches = [[NSMutableArray alloc]init];
    //NSMutableArray * approaches_len = [[NSMutableArray alloc]init];

    
    whichApproach = -1;
    
    [approaches addObject:@"Hey Jerkface, "];
    [approaches addObject:@"Listen Bitch, "];
    [approaches addObject:@"You shiteating cockgobbler, "];
    [approaches addObject:@"Shitty Person, "];
    [approaches addObject:@"Hey Mr. Dickbag McCockGobbler, "];
    [approaches addObject:@"Dear Friend, "];
    [approaches addObject:@""];
    
	
	msgTextField.text = @"";
	
    [super viewDidLoad];
	
	self.title = @"Message";
	
	
	//MyManager *manager = [MyManager sharedManager];  
    	//NSLog(@"Valid Code: %@", manager.oidReplyValid);
	//msgTextField.text = [NSString stringWithFormat:@"         %@",manager.theMessage];
	
	/*
	
	UIImage * keyCardBG = [[UIImage imageNamed:@"intro_btn.png"] stretchableImageWithLeftCapWidth:24 topCapHeight:12];
	UIImage * keyCardSelectedBG = [[UIImage imageNamed:@"into_btn.png"] stretchableImageWithLeftCapWidth:24 topCapHeight:12];  // used to be 8 and 12
	
	key = [UIButton buttonWithType:UIButtonTypeCustom];
	[key setBackgroundImage:keyCardBG forState:UIControlStateNormal];
	[key setBackgroundImage:keyCardSelectedBG forState:UIControlStateHighlighted];
	[key setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[key setTitle:@"You're" forState:UIControlStateNormal];
	[key addTarget:self action:@selector(changeApproachPressed:) forControlEvents:UIControlEventTouchUpInside];
	[key sizeToFit];
	[key setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 21.0, 0.0, 9.0)];
	[key.titleLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
	
	key.frame = CGRectMake( 5.0, 7.0, 75, 25 );
	
	[self.view addSubview:key];
     
    */
    
    UIImage * spiceButtonImg = [[UIImage imageNamed:@"spicebtn.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:26];
    UIImage * spiceButtonSelectedImg = [[UIImage imageNamed:@"spicebtn_selected.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:26];
    
    spiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [spiceButton setBackgroundImage:spiceButtonImg forState:UIControlStateNormal];
    [spiceButton setBackgroundImage:spiceButtonSelectedImg forState:UIControlStateHighlighted];
    [spiceButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [spiceButton setTitle:@"SPICE IT UP" forState:UIControlStateNormal];
    [spiceButton setReversesTitleShadowWhenHighlighted:YES];
    [spiceButton setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [spiceButton addTarget:self action:@selector(changeApproachPressed:) forControlEvents:UIControlEventTouchUpInside];
    [spiceButton sizeToFit];
    [spiceButton setTitleEdgeInsets:UIEdgeInsetsMake(5.0, 0.0, 0.0, 0.0)];
    [spiceButton.titleLabel setFont:[UIFont fontWithName:@"Gotham Rounded" size:12.0]];
    
    spiceButton.frame = CGRectMake(3.0, 169.0, 100, 27);
    
    [self.view addSubview:spiceButton];
	
	
	UIBarButtonItem *btnNext = [[[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleBordered target:self action:@selector(nextButtonPressed:)]autorelease];    
	self.navigationItem.rightBarButtonItem = btnNext;
	
	
	
}




-(void)changeApproachPressed:(id)sender {
    
    if (whichApproach == [approaches count] - 1) {
        whichApproach = -1;
    }
    
    
    
    whichApproach = whichApproach + 1;
    NSLog(@"%i",whichApproach);
    NSLog(@"%i",[approaches count]);
    if (whichApproach != 0 ) {
        
        NSString *temp = msgTextField.text;
        
        msgTextField.text = [msgTextField.text stringByReplacingOccurrencesOfString: [approaches objectAtIndex:whichApproach-1] withString:[approaches objectAtIndex:whichApproach] options:NULL range:NSMakeRange(0, [[approaches objectAtIndex:whichApproach-1] length])];
        if ([temp isEqualToString:msgTextField.text]) {
                    msgTextField.text = [[approaches objectAtIndex:whichApproach] stringByAppendingString:msgTextField.text];
        }

        
    }
    else{
        msgTextField.text = [[approaches objectAtIndex:whichApproach] stringByAppendingString:msgTextField.text];
        
    }


    
    
    
    /*
	
	// code here for changing the button intro 
	
	if (key.titleLabel.text == @"You're") {
		
		[key setTitle:@"You" forState:UIControlStateNormal];
		[key setTitle:@"You" forState:UIControlStateHighlighted];
		
		CGRect newFrame = CGRectMake( 5.0, 7.0, 55, 25 );
		
		
		introSpace = 11;
		
		
		[UIView beginAnimations:@"adjustIntroButton" context:NULL];
		[UIView setAnimationDuration:1.0];
		[UIView setAnimationDelay:0.3];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
		
		self.key.frame = newFrame;
		
		[UIView setAnimationDelegate:self];
		[UIView commitAnimations];
		
		
		NSString * tempMessageString = msgTextField.text;
		[tempMessageString replaceOccurrencesOfString:@"               " withString:@"           " options:NULL range:NSMakeRange(0, [msgTextField text].length)];
		msgTextField.text = tempMessageString;
		
		
	}
    */
    
    
	
}


-(void)nextButtonPressed:(id)sender {
	
	NSLog(@"nextButtonPressed");
	
	
	if ([msgTextField text].length > 500 && [msgTextField text].length <= 570) {
		
		UIAlertView *someError = [[UIAlertView alloc] initWithTitle: @"A Bit Too Long" message: @"The best Richard Cards get right to the point. Please shorten your message." delegate: self cancelButtonTitle: @"OK" otherButtonTitles: nil];
		
		[someError show];
		[someError release];
		
	} else if ([msgTextField text].length > 570) {
		
		UIAlertView *someError = [[UIAlertView alloc] initWithTitle: @"Way Too Long" message: @"The best Richard Cards get right to the point. Please shorten your message." delegate: self cancelButtonTitle: @"OK" otherButtonTitles: nil];
		
		[someError show];
		[someError release];
	} else {
		
		MyManager *manager = [MyManager sharedManager];
		manager.theMessage = [msgTextField text];
        NSLog(@"Reply is a: %@", manager.oidReplyValid);
        
        
        if ([[manager.oidReplyValid objectForKey:@"QRCHECK"] isEqualToString:@"VALID"]) {
            
            SummaryView *summaryview  = [[SummaryView alloc] initWithNibName:@"SummaryView" bundle:nil];
            [self.navigationController pushViewController:summaryview animated:YES];
            [summaryview release];
        }
        else{
            
        //[msgTextField resignFirstResponder];
		
		AddressView *addressview  = [[AddressView alloc] initWithNibName:@"AddressView" bundle:nil];
		[self.navigationController pushViewController:addressview animated:YES];
		
		[addressview release];
		
		}
	}
	
	
}




- (void)textViewDidChange:(UITextView *)textView {
	
	//if([textView.text length] 
    
    NSUInteger lenght = [textView.text length];
    NSString* htmlMessage;
    htmlMessage = [textView.text stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];
    lenght = ([htmlMessage length] - lenght)/3;
    
    CGSize textSize = [textView.text sizeWithFont:[UIFont systemFontOfSize:17.0f]];
    
    lenght = lenght*230 + textSize.width;
	if (lenght > 3120) {
        
        liveOutputTextView.textColor = [UIColor colorWithRed:236.0/255.0 green:58.0/255.0 blue:64.0/255.0 alpha:0.5];
		liveOutputTextView.text = [NSString stringWithFormat:@"Message Length Too Long"];
        
    }
    else{
        liveOutputTextView.text = @"";
        
    }
    /*
	int maxChars = 3120;
	int charsLeft = maxChars - [textView.text length];
	int absoluteCharsLeft = fabs(charsLeft);
	
	if(charsLeft < 21 && charsLeft > 1 || charsLeft == 0) {
		liveOutputTextView.textColor = [UIColor grayColor];
		liveOutputTextView.text = [NSString stringWithFormat:@"%d Characters Left",charsLeft];
	}
	else if(charsLeft == 1) {
		liveOutputTextView.textColor = [UIColor grayColor];
		liveOutputTextView.text = [NSString stringWithFormat:@"%d Character Left",charsLeft];
	}
	else if(charsLeft == -1) {
		liveOutputTextView.textColor = [UIColor colorWithRed:236.0/255.0 green:58.0/255.0 blue:64.0/255.0 alpha:0.5];
		liveOutputTextView.text = [NSString stringWithFormat:@"%d Character Too Many",absoluteCharsLeft];
	}
	else if(charsLeft < -1) {
		liveOutputTextView.textColor = [UIColor colorWithRed:236.0/255.0 green:58.0/255.0 blue:64.0/255.0 alpha:0.5];
		liveOutputTextView.text = [NSString stringWithFormat:@"%d Characters Too Many",absoluteCharsLeft];
	}
	else if(charsLeft > 21) {
		liveOutputTextView.text = @"";
	}
	*/
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
	
	
	NSInteger i = [textView.text length];
	
	NSLog(@"%@", [NSNumber numberWithInt:i]);
	
	/*
	if ([textView.text length] > introSpace) {
		return YES;
		NSLog(@"change it? yes...");
	}
	
	if ([textView.text length] == introSpace && [text isEqualToString:@""]) {
		return NO;
		NSLog(@"change it? no...");
	}
     */
	
	
	return YES;
	
}



-(void)viewWillAppear:(BOOL)animated { 
	[self.navigationController setNavigationBarHidden:NO animated:YES]; // hides
	[msgTextField becomeFirstResponder];
	
}

-(void)viewWillDisappear:(BOOL)animated { 
	
	NSArray *viewControllers = self.navigationController.viewControllers;
	if (viewControllers.count > 1 && [viewControllers objectAtIndex:viewControllers.count-2] == self) {
		// View is disappearing because a new view controller was pushed onto the stack
		
	} else if ([viewControllers indexOfObject:self] == NSNotFound) {
		// View is disappearing because it was popped from the stack
		
		if (![self.navigationController isNavigationBarHidden])
			[self.navigationController setNavigationBarHidden:YES animated:YES]; // hide cuz we're goin back to the main screen
		MyManager *manager = [MyManager sharedManager];
		manager.theMessage = [msgTextField text];
        
	}	
	
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	[self becomeFirstResponder];
	//[self onLoginButtonClicked];
	return YES;
}

/*
 
 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 
 
 MyManager *manager = [MyManager sharedManager];
 manager.theMessage = [msgArray objectAtIndex:indexPath.row];
 
 AddressView *addressview  = [[AddressView alloc] initWithNibName:@"AddressView" bundle:nil];
 [self.navigationController pushViewController:addressview animated:YES];
 
 [addressview release];
 
 
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
	[msgTextField release];
    [super dealloc];
}


@end
