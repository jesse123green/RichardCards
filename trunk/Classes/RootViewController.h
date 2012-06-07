//
//  RootViewController.h
//  Richard Cards
//
//  Created by Alan Dickinson on 6/4/10.
//  Copyright n/a 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Reachability;
//@interface RootViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
@interface RootViewController 
    : UIViewController 
        < ZBarReaderDelegate >
{
	

		IBOutlet UITextField *txtEmail;
        UITextView *resultText;
    NSURLConnection *connection1;
    NSMutableData *responseData;
    
    Reachability* internetReachable;
    Reachability* hostReachable;
    BOOL internetActive;
    BOOL hostActive;
	 
}

// - (IBAction)startButtonPressed:(id)sender;
- (void) checkNetworkStatus:(NSNotification *)notice;

@property (nonatomic,retain) IBOutlet UITextField *txtEmail;
@property (nonatomic, retain) IBOutlet UITextView *resultText;
@property (nonatomic, assign) BOOL internetActive;
@property (nonatomic, assign) BOOL hostActive;


@end
