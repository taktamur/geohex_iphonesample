//
//  GeoHex.m
//  GeoHex
//
//  Created by tak on 10/09/05.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GeoHex.h"
#import <math.h>

@interface NSString (GeoHex)
- (NSString *)charAt:(int)index;
@end
@implementation NSString (GeoHex)
- (NSString *)charAt:(int)index
{
	return [self substringWithRange:NSMakeRange(index,1)];
}
@end


@implementation GeoHex

static NSString *h_key = @"abcdefghijklmnopqrstuvwxyz0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
static double h_base = 20037508.3;
static double h_deg = M_PI*(30.0/180.0);
static int h_range=21; 


+(CLLocationCoordinate2D)xy2loc:(CGPoint) p
{
	double lon = ( p.x / h_base ) * 180.0;
	double lat = ( p.y / h_base ) * 180.0;
	lat = 180.0 / M_PI * ( 2 * atan( exp( lat * M_PI / 180 )) - M_PI/2 );
	return CLLocationCoordinate2DMake(lat,lon);
}


+(CGPoint)loc2xy:(CLLocationCoordinate2D) loc
{
	double x = loc.longitude * h_base / 180.0;
	double y = log( tan((90.0+loc.latitude) * M_PI / 360.0))/(M_PI / 180.0);
	y *= h_base / 180.0;
	return CGPointMake(x,y);
}

+(GeoHexZone *)zoneFromLocation:(CLLocationCoordinate2D) loc withLevel:(int)_level
{
	double h_k = tan(h_deg);
	double h_size = h_base/ pow(2,_level)/3;  // 101.916037495931

	CGPoint z_xy = [GeoHex loc2xy:loc];

	double lon_grid = z_xy.x;
	double lat_grid = z_xy.y;
	double unit_x = 6*h_size;
	double unit_y = 6*h_size*h_k;
	
	double h_pos_x = (lon_grid + lat_grid/h_k)/unit_x;
	double h_pos_y = (lat_grid - h_k*lon_grid)/unit_y;
	
	double h_x_0 = floor(h_pos_x);
	double h_y_0 = floor(h_pos_y);
	
	double h_x_q = floor((h_pos_x - h_x_0)*100)/100;
	double h_y_q = floor((h_pos_y - h_y_0)*100)/100;
	
	double  h_x = round(h_pos_x);
	double  h_y = round(h_pos_y);

	double  h_max= round(h_base/unit_x + h_base/unit_y);

	if(h_y_q>-h_x_q+1){
		if((h_y_q<2*h_x_q)&&(h_y_q>0.5*h_x_q)){
			h_x = h_x_0 + 1;
			h_y = h_y_0 + 1;
		}
	}else if(h_y_q<-h_x_q+1){
		if((h_y_q>(2*h_x_q)-1)&&(h_y_q<(0.5*h_x_q)+0.5)){
			h_x = h_x_0;
			h_y = h_y_0;
		}
	}

	double h_lat = (h_k*h_x*unit_x + h_y*unit_y)/2.0;
	double h_lon = (h_lat - h_y*unit_y)/h_k;

	CGPoint xyloc = CGPointMake(h_lon, h_lat);
	CLLocationCoordinate2D z_loc = [GeoHex xy2loc:xyloc];
	
	double z_loc_x = z_loc.longitude;
	double z_loc_y = z_loc.latitude;

	if(h_base - h_lon <h_size){
		z_loc_x = 180;
		double h_xy = h_x;
		h_x = h_y;
		h_y = h_xy;
	}
	
	double h_x_p =0;
	double h_y_p =0;

	if(h_x<0) h_x_p = 1;
	if(h_y<0) h_y_p = 1;
	
	
	int h_x_abs = abs(h_x)*2+h_x_p;
	int h_y_abs = abs(h_y)*2+h_y_p;

	double h_x_10000 = floor((h_x_abs%77600000)/1296000);
	double h_x_1000 = floor((h_x_abs%1296000)/216000);
	double h_x_100 = floor((h_x_abs%216000)/3600);
	double h_x_10 = floor((h_x_abs%3600)/60);
	double h_x_1 = floor((h_x_abs%3600)%60);

	double h_y_10000 = floor((h_y_abs%77600000)/1296000);
	double h_y_1000 = floor((h_y_abs%1296000)/216000);
	double h_y_100 = floor((h_y_abs%216000)/3600);
	double h_y_10 = floor((h_y_abs%3600)/60);
	double h_y_1 = floor((h_y_abs%3600)%60);
	
	NSMutableString *h_code = [NSMutableString stringWithCapacity:10];
	[h_code	appendString:[h_key charAt:_level%60]];	

	if(h_max >=1296000/2){
		[h_code appendString:[h_key charAt:(h_x_10000)]];
		[h_code appendString:[h_key charAt:(h_y_10000)]];
	}
	if(h_max >=216000/2){
		[h_code appendString:[h_key charAt:(h_x_1000)]];
		[h_code appendString:[h_key charAt:(h_y_1000)]];
	}
	if(h_max >=3600/2){
		[h_code appendString:[h_key charAt:(h_x_100)]];
		[h_code appendString:[h_key charAt:(h_y_100)]];
	}
	if(h_max >=60/2){
		[h_code appendString:[h_key charAt:(h_x_10)]];
		[h_code appendString:[h_key charAt:(h_y_10)]];
	}
	 
	[h_code appendString:[h_key charAt:(h_x_1)]];
	[h_code appendString:[h_key charAt:(h_y_1)]];

	GeoHexZone *zone = [[[GeoHexZone alloc] initiWithCode:h_code
											   coordinate:CLLocationCoordinate2DMake(z_loc_y, z_loc_x)
													   xy: CGPointMake( h_x, h_y )
													level:_level]autorelease];
	return zone;
}

+(MKPolygon *)polygonFromZone:(GeoHexZone *)zone
{
	double h_size = h_base/ pow(2,zone.level)/3;

	double h_lat = zone.coordinate.latitude;
	double h_lon = zone.coordinate.longitude;
	
	CGPoint h_xy = [GeoHex loc2xy: zone.coordinate];
	
	double h_x = h_xy.x;
	double h_y = h_xy.y;

	double h_deg = tan(M_PI*(60.0/180.0));
	
	double h_top = [GeoHex xy2loc:CGPointMake(h_x, (h_y + h_deg* h_size) )].latitude;
	double h_btm = [GeoHex xy2loc:CGPointMake(h_x, (h_y - h_deg* h_size) )].latitude;
	
	NSMutableArray *ret = [NSMutableArray arrayWithCapacity:0];
	if( (h_btm> 85.051128514)||(h_top<-85.051128514)) return [[[MKPolygon alloc]init]autorelease];

	double h_l = [GeoHex xy2loc:CGPointMake( (h_x - 2* h_size), h_y)].longitude;
	double h_r = [GeoHex xy2loc:CGPointMake( (h_x + 2* h_size), h_y)].longitude;
	double h_cl = [GeoHex xy2loc:CGPointMake( (h_x - 1* h_size), h_y)].longitude;
	double h_cr = [GeoHex xy2loc:CGPointMake( (h_x + 1* h_size), h_y)].longitude;
	
	CLLocationCoordinate2D coordinates[7];
	coordinates[0] = CLLocationCoordinate2DMake(h_lat,h_l);
	coordinates[1] = CLLocationCoordinate2DMake(h_top,h_cl);
	coordinates[2] = CLLocationCoordinate2DMake(h_top,h_cr);
	coordinates[3] = CLLocationCoordinate2DMake(h_lat,h_r);
	coordinates[4] = CLLocationCoordinate2DMake(h_btm,h_cr);
	coordinates[5] = CLLocationCoordinate2DMake(h_btm,h_cl);
	coordinates[6] = CLLocationCoordinate2DMake(h_lat,h_l);
	
	return [MKPolygon polygonWithCoordinates:coordinates count:7];
}
@end
