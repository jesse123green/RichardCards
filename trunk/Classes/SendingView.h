//
//  SendingView.h
//  Richard Cards
//
//  Created by Jesse Green on 2/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SendingView : UIViewController {

	IBOutlet UIActivityIndicatorView *sendingIndicator;
	IBOutlet UIButton *activityButton;
	
}

@property (nonatomic,retain) IBOutlet UIActivityIndicatorView *sendingIndicator;
@property (nonatomic,retain) IBOutlet UIButton *activityButton;

@end
