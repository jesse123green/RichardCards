//
//  ReaderSampleAppDelegate.h
//  ReaderSample
//
//  Created by spadix on 8/4/10.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface ReaderSampleAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    RootViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet RootViewController *viewController;

@end

