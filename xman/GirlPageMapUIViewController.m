//
//  GirlPageMapUIViewController.m
//  xman
//
//  Created by Liu Ming on 4/08/16.
//  Copyright © 2016 Liu Ming. All rights reserved.
//

#import "GirlPageMapUIViewController.h"


@interface GirlPageMapUIViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITextField *postCodeView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@end

@implementation GirlPageMapUIViewController


- (IBAction)textEditingBegin:(id)sender {
    self.activeField = sender;
}

- (IBAction)textEditingEnd:(id)sender {
    self.activeField = nil;
}

- (IBAction)textEditReturn:(id)sender {
//    [self nextScreen];
}

//-(void)nextScreen{}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.mapView.delegate = self;
//    if(self.appDelegate != nil){
//        MKCircle *circle = [MKCircle circleWithCenterCoordinate:self.appDelegate.curLocation.coordinate radius:1000];
//        [self.mapView addOverlay:circle];
//    }
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    if([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedWhenInUse){
        [self.locationManager requestWhenInUseAuthorization ];
    }
    
    self.mapView.showsUserLocation = YES;
    [self.pageDelegate onShow:self.pageIndex title:@"location"];
    
    [self updateKeyboardPanelMiddleButton];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.postCodeView becomeFirstResponder];
}

-(void)attachContent{}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    [self updateLocation];
}

- (void)mapView:(MKMapView *)aMapView didUpdateUserLocation:(MKUserLocation *)aUserLocation {
    [self updateLocation];
}

-(void)updateLocation{
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.005;
    span.longitudeDelta = 0.005;
    CLLocationCoordinate2D location;
    location.latitude = self.appDelegate.curLocation.coordinate.latitude;
    location.longitude = self.appDelegate.curLocation.coordinate.longitude;
    region.span = span;
    region.center = location;
    [self.mapView setRegion:region animated:YES];
}

-(void)updateKeyboardPanelMiddleButton{
    [self.keyboardPanel.middleButton setHidden:NO];
    [self.keyboardPanel.middleButton setTitle:@"save" forState:UIControlStateNormal];
    [self.keyboardPanel.middleButton addTarget:self action:@selector(nextScreen) forControlEvents:UIControlEventTouchUpInside];
}

@end
