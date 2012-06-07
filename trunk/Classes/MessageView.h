//
//  MessageView.h
//  Richard Cards
//
//  Created by Alan Dickinson on 6/4/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "MessageIntroView.h"


@interface MessageView : UIViewController <UITextFieldDelegate> {
	

	IBOutlet UITextView * msgTextField;

	UIButton * spiceButton;

	NSInteger whichApproach;
    
    NSMutableArray * approaches;
    
}

@property (nonatomic, retain) IBOutlet UITextView * liveOutputTextView;

@property (nonatomic, retain) IBOutlet UITextView * msgTextField;

@property (retain, nonatomic) UIButton *spiceButton;

@property (retain, nonatomic) NSMutableArray *approaches;



@property (nonatomic) NSInteger whichApproach;


@end
