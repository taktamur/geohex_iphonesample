//
//  Zone.h
//  GeoHex
//
//  Created by tak on 10/09/07.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MKMapView.h>




@interface GeoHexZone : NSObject {
	NSString *code;
	CLLocationCoordinate2D coordinate;
	CGPoint xy;
	int level;
}
@property(nonatomic,retain,readonly)NSString *code;
@property(readonly) CLLocationCoordinate2D coordinate;
@property(readonly) CGPoint xy;
@property(readonly) int level;

-(id) initiWithCode:(NSString *)code
		 coordinate:(CLLocationCoordinate2D)coordinate
				 xy:(CGPoint)xy
			  level:(int)level;

-(MKPolygon *)polygon;


@end
