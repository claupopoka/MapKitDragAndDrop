//
//  MapViewController.h
//  Sample
//
//  Created by digdog on 6/26/10.
//  Copyright Ching-Lan 'digdog' HUANG and digdog software 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapViewController : UIViewController <MKMapViewDelegate> {
}

@property (nonatomic, retain) IBOutlet MKMapView *mapView;

@end

