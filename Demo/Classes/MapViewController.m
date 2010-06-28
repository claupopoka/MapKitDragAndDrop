//
//  MapViewController.m
//  Sample
//
//  Created by digdog on 6/26/10.
//  Copyright Ching-Lan 'digdog' HUANG and digdog software 2010. All rights reserved.
//

#import "MapViewController.h"
#import "DDAnnotation.h"
#import "DDAnnotationView.h"

@interface MapViewController () 
- (void)coordinateChanged_:(NSNotification *)notification;
@end


@implementation MapViewController

- (void)viewDidLoad {

    [super viewDidLoad];
	
	// NOTE: This is optional, DDAnnotationCoordinateDidChangeNotification only fired in iPhone OS 3, not in iOS 4.
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(coordinateChanged_:) name:@"DDAnnotationCoordinateDidChangeNotification" object:nil];
	
	CLLocationCoordinate2D theCoordinate;
	theCoordinate.latitude = 37.810000;
    theCoordinate.longitude = -122.477989;
	
	DDAnnotation *annotation = [[[DDAnnotation alloc] initWithCoordinate:theCoordinate addressDictionary:nil] autorelease];
	annotation.title = @"Drag to Move Pin";
	annotation.subtitle = [NSString	stringWithFormat:@"%f %f", annotation.coordinate.latitude, annotation.coordinate.longitude];
	
	[self.mapView addAnnotation:annotation];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	self.mapView = nil;
}

- (void)dealloc {

	// NOTE: This is optional, DDAnnotationCoordinateDidChangeNotification only fired in iPhone OS 3, not in iOS 4.
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	// NOTE: We're using modern runtime with synthesizing ivar by default, and we can't access ivar directly.
	self.mapView = nil;
	
    [super dealloc];
}

#pragma mark -
#pragma mark DDAnnotationCoordinateDidChangeNotification

// NOTE: DDAnnotationCoordinateDidChangeNotification won't fire in iOS 4, use -mapView:annotationView:didChangeDragState:fromOldState: instead.
- (void)coordinateChanged_:(NSNotification *)notification {
	
	DDAnnotation *annotation = notification.object;
	annotation.subtitle = [NSString	stringWithFormat:@"%f %f", annotation.coordinate.latitude, annotation.coordinate.longitude];
}

#pragma mark -
#pragma mark MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)annotationView didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState {
	
	if (oldState == MKAnnotationViewDragStateDragging) {
		DDAnnotation *annotation = (DDAnnotation *)annotationView.annotation;
		annotation.subtitle = [NSString	stringWithFormat:@"%f %f", annotation.coordinate.latitude, annotation.coordinate.longitude];		
	}
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {

    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;		
	}
	
	static NSString * const kPinAnnotationIdentifier = @"PinIdentifier";
	MKAnnotationView *draggablePinView = [mapView dequeueReusableAnnotationViewWithIdentifier:kPinAnnotationIdentifier];
	
	if (draggablePinView) {
		draggablePinView.annotation = annotation;
	} else {		
		draggablePinView = [[[DDAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:kPinAnnotationIdentifier] autorelease];
		
		if ([draggablePinView isKindOfClass:[DDAnnotationView class]]) {
			((DDAnnotationView *)draggablePinView).mapView = mapView;
		} else {
			// NOTE: draggablePinView will be draggable enabled MKPinAnnotationView when running under iOS 4.
		}
	}		
	
	return draggablePinView;
}

@end
