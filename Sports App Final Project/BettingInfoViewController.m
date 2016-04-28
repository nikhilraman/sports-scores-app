//
//  BettingInfoViewController.m
//  Sports App Final Project
//
//  Created by Nikhil Raman on 4/21/16.
//  Copyright © 2016 cis195. All rights reserved.
//

#import "BettingInfoViewController.h"

@interface BettingInfoViewController ()

@property (strong, nonatomic) IBOutlet UILabel *moneyLineHome;
@property (strong, nonatomic) IBOutlet UILabel *moneyLineAway;
@property (strong, nonatomic) IBOutlet UILabel *homeSpread;
@property (strong, nonatomic) IBOutlet UILabel *awaySpread;

@property (strong, nonatomic) IBOutlet UILabel *under;
@property (strong, nonatomic) IBOutlet UILabel *over;

@property (strong, nonatomic) IBOutlet UILabel *homeTeam;
@property (strong, nonatomic) IBOutlet UILabel *awayTeam;

@end

@implementation BettingInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self displayOddsInfo];
    // Do any additional setup after loading the view.
}

- (IBAction)backButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) displayOddsInfo {
    NSNumber *MLHome = [self.odds objectForKey:@"MoneyLineHome"];
    NSNumber *MLAway = [self.odds objectForKey:@"MoneyLineAway"];
    NSNumber *pointSpreadHome = [self.odds objectForKey:@"PointSpreadHome"];
    NSNumber *pointSpreadAway = [self.odds objectForKey:@"PointSpreadAway"];
    NSNumber *pointSpreadHomeLine = [self.odds objectForKey:@"PointSpreadHomeLine"];
    NSNumber *pointSpreadAwayLine = [self.odds objectForKey:@"PointSpreadAwayLine"];
    NSNumber *totalNumber = [self.odds objectForKey:@"TotalNumber"];
    NSNumber *overLine = [self.odds objectForKey:@"OverLine"];
    NSNumber *underLine = [self.odds objectForKey:@"UnderLine"];
    
    
    self.moneyLineHome.text = [MLHome stringValue];
    self.moneyLineAway.text = [MLAway stringValue];
    
    NSString *HS = [pointSpreadHome stringValue];
    NSString *HSL = [pointSpreadHomeLine stringValue];
    self.homeSpread.text = [[[HS stringByAppendingString:@" ("]stringByAppendingString:HSL] stringByAppendingString:@")"];
    
    NSString *AS = [pointSpreadAway stringValue];
    NSString *ASL = [pointSpreadAwayLine stringValue];
    self.awaySpread.text = [[[AS stringByAppendingString:@" ("]stringByAppendingString:ASL] stringByAppendingString:@")"];
    
    NSString *U = [totalNumber stringValue];
    NSString *UL = [underLine stringValue];
    self.under.text = [[[U stringByAppendingString:@" ("]stringByAppendingString:UL] stringByAppendingString:@")"];
    
    NSString *O = [totalNumber stringValue];
    NSString *OL = [overLine stringValue];
    self.over.text = [[[O stringByAppendingString:@" ("]stringByAppendingString:OL] stringByAppendingString:@")"];
    
    self.homeTeam.text = self.homeTeamName;
    self.awayTeam.text = self.awayTeamName;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
