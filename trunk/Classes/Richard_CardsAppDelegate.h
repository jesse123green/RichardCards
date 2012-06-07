//
//  Richard_CardsAppDelegate.h
//  Richard Cards
//
//  Created by Alan Dickinson on 6/4/10.
//  Copyright n/a 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Richard_CardsAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end

