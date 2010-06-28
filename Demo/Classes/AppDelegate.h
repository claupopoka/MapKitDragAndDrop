//
//  SampleAppDelegate.h
//  Sample
//
//  Created by digdog on 6/26/10.
//  Copyright Ching-Lan 'digdog' HUANG and digdog software 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MapViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet MapViewController *viewController;

@end

