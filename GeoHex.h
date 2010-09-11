//
//  GeoHex.h
//  GeoHex
//
//  Created by tak on 10/09/05.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MKMapView.h>
#import "GeoHexZone.h"


@interface GeoHex : NSObject {

}

+(CGPoint)loc2xy:(CLLocationCoordinate2D) loc;
+(CLLocationCoordinate2D)xy2loc:(CGPoint) p;
+(GeoHexZone *)zoneFromLocation:(CLLocationCoordinate2D) loc withLevel:(int)_level;
+(MKPolygon *)polygonFromZone:(GeoHexZone *)zone;

@end
