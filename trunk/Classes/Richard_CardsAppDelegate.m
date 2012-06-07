//
//  Richard_CardsAppDelegate.m
//  Richard Cards
//
//  Created by Alan Dickinson on 6/4/10.
//  Copyright n/a 2010. All rights reserved.
//

#import "Richard_CardsAppDelegate.h"
#import "RootViewController.h"
#import "MessageView.h"


@implementation UINavigationBar (CustomImage)
- (void)drawRect:(CGRect)rect {
	UIImage *image = [UIImage imageNamed: @"NavBar.png"];
	[image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}
@end


@implementation Richard_CardsAppDelegate

@synthesize window;
@synthesize navigationController;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    // Override point for customization after app launch    
	
	self.navigationController.navigationBar.tintColor = //[UIColor lightGrayColor];
	[[UIColor alloc] initWithRed: 54.0/255 green: 68.0/255 blue: 130.0/255 alpha:1.0];

	
	[window addSubview:[navigationController view]];
    [window makeKeyAndVisible];
	
	self.navigationController.navigationBarHidden = TRUE;	
	/*
	UIButton *sampleButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[sampleButton setFrame:CGRectMake(11, 415, 298, 52)];
	[sampleButton setTitle:@"" forState:UIControlStateNormal];
	//[sampleButton setFont:[UIFont boldSystemFontOfSize:20]];
	[sampleButton setBackgroundImage:[[UIImage imageNamed:@"penarichard.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateNormal];
	[sampleButton setBackgroundImage:[[UIImage imageNamed:@"penarichard_hilite.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateHighlighted];
	[sampleButton addTarget:self action:@selector(startButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	[window addSubview:sampleButton];
	*/
	return YES;
}


-(void)startButtonPressed:(id)sender {
	
	NSLog(@"startPressed");
	
	/*
	 
	 ShowMoreController *controller = [[ShowMoreController alloc] initWithNibName:@"ShowMoreController" bundle:[NSBundle mainBundle]];
	 
	 controller.delegate = self;
	 [self.navigationController pushViewController:controller animated:YES];
	 [controller release];
	 controller = nil;
	 
	 */
	
	
	MessageView *messageview  = [[MessageView alloc] initWithNibName:@"MessageView" bundle:nil];
	[self.navigationController pushViewController:messageview animated:YES];
	[messageview release];
	
	
}



- (void)applicationWillTerminate:(UIApplication *)application {
	// Save data if appropriate
	NSLog(@"Terminating");
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[navigationController release];
	[window release];
	[super dealloc];
}


@end

