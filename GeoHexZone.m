//
//  Zone.m
//  GeoHex
//
//  Created by tak on 10/09/07.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GeoHexZone.h"
#import "GeoHex.h"

@implementation GeoHexZone

@synthesize code;
@synthesize coordinate;
@synthesize xy;
@synthesize level;

-(id) initiWithCode:(NSString *)_code
		 coordinate:(CLLocationCoordinate2D)_coordinate
				 xy:(CGPoint)_xy
			  level:(int)_level
{
	if( (self = [super init])!=nil ){
		code = [_code copy];
		coordinate = _coordinate;
		xy = _xy;
		level = _level;
	}
	return self;
}

-(MKPolygon *)polygon
{
	return [GeoHex polygonFromZone:self];
}


-(void)dealloc
{
	[code release];
	[super dealloc];
}

@end
