//
//  QRCheckView.h
//  Richard Cards
//
//  Created by Jesse Green on 4/1/11.
//  Copyright 2011 None. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface QRCheckView : UIViewController {

    
    	IBOutlet UIActivityIndicatorView *sendingIndicator;
}

@property (nonatomic,retain) IBOutlet UIActivityIndicatorView *sendingIndicator;

@end
