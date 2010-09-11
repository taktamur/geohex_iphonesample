//
//  MainViewController.m
//  GeoHex
//
//  Created by tak on 10/09/04.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "MainViewController.h"
#import "GeoHex.h"


// ピンAnnotationのクラス
@interface MyAnnotation : NSObject <MKAnnotation> {  
    CLLocationCoordinate2D coordinate;  
}  
@property (nonatomic) CLLocationCoordinate2D coordinate;  
@end  
@implementation MyAnnotation
@synthesize coordinate;
@end


@implementation MainViewController

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
	if( mapview == nil ){
		mapview = [[MKMapView alloc] initWithFrame:self.view.bounds];
		mapview.delegate = self;
		
		// 縮尺を設定
		MKCoordinateRegion zoom = mapview.region;
		zoom.span.latitudeDelta = 0.005;
		zoom.span.longitudeDelta = 0.005;
		[mapview setRegion:zoom animated:NO];
		[self.view addSubview:mapview];
		
		CLLocationCoordinate2D c = CLLocationCoordinate2DMake( 35.68130345007702,139.76614472618104);
		[mapview setCenterCoordinate:c];
		MyAnnotation *a = [[[MyAnnotation alloc]init]autorelease];
		a.coordinate = c;
		[mapview addAnnotation:a];
	}
	
	/*

	CLLocationCoordinate2D loc;
	loc.longitude = 139.77200267066956;
	loc.latitude = 35.68318581463666;

	CGPoint p = [GeoHex loc2xy:loc];
	NSLog( @" %@", NSStringFromCGPoint(p));
	// x 15559348.164455008  y 4257115.338999562
	loc = [GeoHex xy2loc:p];
*/	
/*	
	CLLocationCoordinate2D loc2;//東京駅のマーク
	loc2.longitude = 139.76614472618104;
	loc2.latitude = 35.68130345007702;

	GeoHexZone *zone = [GeoHex zoneFromLocation:loc2 withLevel:16];
	MKPolygon *polygon = [GeoHex polygonFromZone:zone];
	
	[mapview addOverlay:polygon];
	[mapview setCenterCoordinate:zone.coordinate animated:YES];
	
	[mapview addAnnotation:zone];
*/	
}



#pragma mark MKMapViewDelegate methods
- (MKOverlayView *)mapView:(MKMapView *)mapView
			viewForOverlay:(id<MKOverlay>)overlay {
	MKPolygonView *view = [[[MKPolygonView alloc] initWithOverlay:overlay]
						  autorelease];
	view.fillColor = [UIColor blueColor];
	view.strokeColor = [UIColor redColor];
	view.lineWidth=1;
	view.alpha = 0.3;
	return view;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
	MKPinAnnotationView *view = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"hoge"];
	view.animatesDrop = YES;
	view.draggable = YES;
	return view;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)annotationView didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState
{
	NSLog(@"%@",annotationView);
	if( newState == MKAnnotationViewDragStateEnding ){
		CLLocationCoordinate2D c = annotationView.annotation.coordinate;
		GeoHexZone *zone = [GeoHex zoneFromLocation:c withLevel:16];
		MKPolygon *polygon = [zone polygon];
		[mapview addOverlay:polygon];
	}
}

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller {
    
	[self dismissModalViewControllerAnimated:YES];
}


- (IBAction)showInfo:(id)sender {    
	
	FlipsideViewController *controller = [[FlipsideViewController alloc] initWithNibName:@"FlipsideView" bundle:nil];
	controller.delegate = self;
	
	controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:controller animated:YES];
	
	[controller release];
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}




/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


- (void)dealloc {
    [super dealloc];
}


@end
