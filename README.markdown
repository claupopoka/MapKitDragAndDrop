# MapKitDragAndDrop 2.1

MapKit sample for custom draggable AnnotationView with CoreAnimation pin lift/drop/bounce effects.

## Features

* **Draggable** pin with **CoreAnimation** effects in the MapView
* Use CLLocationManager to find current position
* Use MKReverseGeocoder to lookup address

## Design
* **DDAnnotation** is thin, just subclass from MKPlacemark, which also confirms to MKAnnotation protocol.
* **DDAnnotation** can be init'd with existing address info, so you won't need to reverse geocoding when creating the annotation.
* **DDAnnotation** re-declared MKAnnotation's readonly property 'coordinate' to readwrite-able. So you can update the coordinate after created.
* **DDAnnotationView** is subclassing from MKAnnotationView now, and using several pin images from MapKit.framework.
* To enable drag-and-drop, you must assign MKMapView instace to **DDAnnotationView**.
* **DDAnnotationView** now comes with **CoreAnimation** effects, including:
    1. Pin bounce when touched.
    2. Pin bounce and left for dragging.
    3. Pin drop and bounce when releasing the touch without moving.
    4. Pin lift, drop and bounce when releasing the touch after moving to the new position.  
* **DDAnnotationView** won't do any animations unless MKMapView instance is assigned.

## Issues

* If you lookup too many times within a very short of period, you might get error from Apple/Google(so don't do this in your real world apps):

        /SourceCache/ProtocolBuffer/ProtocolBuffer-19/Runtime/PBRequester.m:446 server returned error: 503

* Pin animations are almost perfect, but still need some works, I will kept things updated if possible.

## License 

This sample code is licensed under MIT license.
