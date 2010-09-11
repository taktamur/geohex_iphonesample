//
//  main.m
//  GeoHex
//
//  Created by tak on 10/09/04.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>


int main(int argc, char *argv[]) {
/*
	projPJ pj_merc, pj_latlong;
	double x=-16.0, y=20.25;
	
	if (!(pj_merc = pj_init_plus("+proj=merc +ellps=clrk66 +lat_ts=33")) )
		exit(1);
	if (!(pj_latlong = pj_init_plus("+proj=latlong +ellps=clrk66")) )
		exit(1);
	x *= DEG_TO_RAD;
	y *= DEG_TO_RAD;
	pj_transform(pj_latlong, pj_merc, 1, 1, &x, &y, NULL );
	NSLog( @"%.2f\t%.2f\n", x, y);
	
*/	
	
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    int retVal = UIApplicationMain(argc, argv, nil, nil);
    [pool release];
	
	
    return retVal;
}
