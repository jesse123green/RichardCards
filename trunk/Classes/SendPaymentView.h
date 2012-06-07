//
//  SendPaymentView.h
//  Richard Cards
//
//  Created by Jesse Green on 6/28/11.
//  Copyright 2011 None. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SendPaymentView : UIViewController {
    
	IBOutlet UIActivityIndicatorView *sendingIndicator;
	IBOutlet UIButton *activityButton;
	
}

@property (nonatomic,retain) IBOutlet UIActivityIndicatorView *sendingIndicator;
@property (nonatomic,retain) IBOutlet UIButton *activityButton;

@end
