//
//  SummaryView.h
//  Richard Cards
//
//  Created by Alan Dickinson on 1/15/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SummaryView : UIViewController <UIScrollViewDelegate> {

	IBOutlet UILabel *lineName;
	IBOutlet UIButton *sendButton;


//	IBOutlet UILabel *previewLineOne;
//	IBOutlet UILabel *previewLineTwo;
//	IBOutlet UILabel *previewLineThree;
//	IBOutlet UILabel *previewLineFour;
	//IBOutlet UILabel *previewState;
	//IBOutlet UILabel *previewZip;
	
	IBOutlet UILabel *previewCardMessage;
    IBOutlet UIScrollView *zoomView;
	UIImageView *myImage;
    NSTimer *timer;
    IBOutlet UIView *cardView;
    IBOutlet UIView *returnAddressView;
    UIWebView *webView;
    UIView *zoomAllView;
    NSString *textClass;
    
    UIButton * reviewAddressButton;
    
    IBOutlet UITextField *sender_txtName;
	IBOutlet UITextField *sender_txtAddressOne;
	IBOutlet UITextField *sender_txtAddressTwo;
	IBOutlet UITextField *sender_txtCity;
	IBOutlet UITextField *sender_txtState;
	IBOutlet UITextField *sender_txtZip;
    UITextField *activeField;
}

@property (nonatomic,retain) IBOutlet UILabel *lineName;
@property (nonatomic,retain) UIImageView *myImage;
@property (nonatomic,retain) NSString *textClass;
@property (nonatomic,retain) IBOutlet UIScrollView *scrollView;


@end
