//
//  MainViewController.h
//  GeoHex
//
//  Created by tak on 10/09/04.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "FlipsideViewController.h"
#import <MapKit/MapKit.h>


@interface MainViewController : UIViewController <FlipsideViewControllerDelegate,MKMapViewDelegate> {
    MKMapView *mapview;
}

- (IBAction)showInfo:(id)sender;

@end
