//
//  MapKitDragAndDropViewController.m
//  MapKitDragAndDrop
//
//  Created by digdog on 7/24/09.
//  Copyright 2009 Ching-Lan 'digdog' HUANG and digdog software.
//
//  Permission is hereby granted, free of charge, to any person obtaining
//  a copy of this software and associated documentation files (the
//  "Software"), to deal in the Software without restriction, including
//  without limitation the rights to use, copy, modify, merge, publish,
//  distribute, sublicense, and/or sell copies of the Software, and to
//  permit persons to whom the Software is furnished to do so, subject to
//  the following conditions:
//   
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//   
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
//  LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
//  OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
//  WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "MapKitDragAndDropViewController.h"
#import "DDAnnotation.h"
#import "DDAnnotationView.h"

@interface MapKitDragAndDropViewController ()

// Properties that don't need to be seen by the outside world.

@property (nonatomic, retain) NSMutableSet *				annotations;
@property (nonatomic, retain) CLLocationManager *			locationManager;
@property (nonatomic, retain) MKReverseGeocoder *			reverseGeocoder;

// Forward declarations

- (void)_coordinateChanged:(NSNotification *)notification;
@end

#pragma mark -
#pragma mark MapKitDragAndDropViewController implementation

@implementation MapKitDragAndDropViewController

- (void)_coordinateChanged:(NSNotification *)notification {
	DDAnnotation *annotation = notification.object;
	
	if (self.reverseGeocoder) {
		[self.reverseGeocoder cancel];
		self.reverseGeocoder.delegate = nil;
		self.reverseGeocoder = nil;
	}
	
	// Note: If you lookup too many times within a very short of period, you might get error from Apple/Google.
	// e.g."/SourceCache/ProtocolBuffer/ProtocolBuffer-19/Runtime/PBRequester.m:446 server returned error: 503"
	// So you should avoid doing this in your code. This is just a demostration about how to reverse geocoding.
	self.reverseGeocoder = [[MKReverseGeocoder alloc] initWithCoordinate:annotation.coordinate];
	self.reverseGeocoder.delegate = self;
	[self.reverseGeocoder start];	
}

@synthesize annotations = _annotations;
@synthesize locationManager = _locationManager;
@synthesize reverseGeocoder = _reverseGeocoder;
@synthesize mapView = _mapView;

#pragma mark -
#pragma mark View controller boilerplate

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];	

	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(_coordinateChanged:)
												 name:@"DDAnnotationCoordinateDidChangeNotification" 
											   object:nil];	

	self.annotations = [[NSMutableSet alloc] initWithCapacity:1];
	
	// Start by locating current position
	self.locationManager = [[CLLocationManager alloc] init];
	self.locationManager.delegate = self;
	[self.locationManager startUpdatingLocation];	
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self]; 
	
	for (DDAnnotation *annotation in _annotations) {
		[_mapView removeAnnotation:annotation];
		[annotation release];
	}
	_mapView.delegate = nil;
	[_mapView release];
	_mapView = nil;
	
	[_annotations release];
	_annotations = nil;		
	
	_locationManager.delegate = nil;
	[_locationManager release];
	_locationManager = nil;
	
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	self.mapView.delegate = nil;
	self.mapView = nil;
}

#pragma mark -
#pragma mark CLLocationManagerDelegate methods

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
	
	// Add annotation to map
	DDAnnotation *annotation = [[DDAnnotation alloc] initWithCoordinate:newLocation.coordinate addressDictionary:nil];
	annotation.title = @"Drag to move Pin";
	[self.annotations addObject:annotation];
	[self.mapView addAnnotation:annotation];
	[annotation release];

	// We only update location once, and let users to do the rest of the changes by dragging annotation to place they want
	[manager stopUpdatingLocation];
}

#pragma mark -
#pragma mark MKMapViewDelegate methods

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
	
	if (annotation == mapView.userLocation) {
		return nil;
	}
	
	DDAnnotationView *annotationView = (DDAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"Pin"];
	if (annotationView == nil) {
		annotationView = [[[DDAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Pin"] autorelease];
	}
	// Dragging annotation will need _mapView to convert new point to coordinate;
	annotationView.mapView = mapView;
	
	UIImageView *leftIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"digdog.png"]];
	annotationView.leftCalloutAccessoryView = leftIconView;
	[leftIconView release];
	
	UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
	annotationView.rightCalloutAccessoryView = rightButton;		
	
	return annotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
	if ([control isKindOfClass:[UIButton class]]) {		
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://digdog.tumblr.com"]];
	}
}

#pragma mark -
#pragma mark Notification and ReverseGeocoding

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)newPlacemark {
	for (DDAnnotation *annotation in _annotations) {
		if (annotation.coordinate.latitude == geocoder.coordinate.latitude && annotation.coordinate.longitude == geocoder.coordinate.longitude) {
			annotation.subtitle = [[newPlacemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
		}
	}
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error {
	for (DDAnnotation *annotation in _annotations) {
		if (annotation.coordinate.latitude == geocoder.coordinate.latitude && annotation.coordinate.longitude == geocoder.coordinate.longitude) {
			annotation.subtitle = nil;
		}
	}
}
@end
