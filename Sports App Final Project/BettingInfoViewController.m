//
//  BettingInfoViewController.m
//  Sports App Final Project
//
//  Created by Nikhil Raman on 4/21/16.
//  Copyright © 2016 cis195. All rights reserved.
//

#import "BettingInfoViewController.h"

@interface BettingInfoViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property NSMutableArray *moneylines;
@property NSMutableArray *spreads;
@property NSMutableArray *overUnder;

@end

@implementation BettingInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadOddsInfo];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    // Do any additional setup after loading the view.
}

- (IBAction)backButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) loadOddsInfo {
    NSNumber *MLHome = [self.odds objectForKey:@"MoneyLineHome"];
    NSString *MLHomeString = [MLHome stringValue];
    if (MLHome.doubleValue > 0) {
        MLHomeString = [@"+" stringByAppendingString:MLHomeString];
    }
    NSNumber *MLAway = [self.odds objectForKey:@"MoneyLineAway"];
    NSString *MLAwayString = [MLAway stringValue];
    if (MLAway.doubleValue > 0) {
        MLAwayString = [@"+" stringByAppendingString:MLAwayString];
    }
    NSNumber *pointSpreadHome = [self.odds objectForKey:@"PointSpreadHome"];
    NSString *spreadHomeString = [pointSpreadHome stringValue];
    if (pointSpreadHome.doubleValue > 0) {
        spreadHomeString = [@"+" stringByAppendingString:spreadHomeString];
    }
    NSNumber *pointSpreadAway = [self.odds objectForKey:@"PointSpreadAway"];
    NSString *spreadAwayString = [pointSpreadAway stringValue];
    if (pointSpreadAway.doubleValue > 0) {
        spreadAwayString = [@"+" stringByAppendingString:spreadAwayString];
    }
    NSNumber *pointSpreadHomeLine = [self.odds objectForKey:@"PointSpreadHomeLine"];
    NSNumber *pointSpreadAwayLine = [self.odds objectForKey:@"PointSpreadAwayLine"];
    NSNumber *totalNumber = [self.odds objectForKey:@"TotalNumber"];
    NSNumber *overLine = [self.odds objectForKey:@"OverLine"];
    NSNumber *underLine = [self.odds objectForKey:@"UnderLine"];
    
    NSString *moneyLineAway = [[MLAwayString stringByAppendingString:@" -- "]
        stringByAppendingString:self.awayTeamName];
    NSString *moneyLineHome = [[MLHomeString stringByAppendingString:@" -- "]
        stringByAppendingString:self.homeTeamName];
    NSString *awaySpread = [[[[spreadAwayString stringByAppendingString:@" ("]
        stringByAppendingString:pointSpreadAwayLine.stringValue]
        stringByAppendingString:@") -- "]
        stringByAppendingString:self.awayTeamName];
    NSString *homeSpread = [[[[spreadHomeString
        stringByAppendingString:@" ("]
        stringByAppendingString:pointSpreadHomeLine.stringValue]
        stringByAppendingString:@") -- "]
        stringByAppendingString:self.homeTeamName];
    NSString *over = [[[[totalNumber.stringValue stringByAppendingString:@" ("]
        stringByAppendingString:overLine.stringValue]stringByAppendingString:@") -- "] stringByAppendingString:@"Over"];
    NSString *under = [[[[totalNumber.stringValue stringByAppendingString:@" ("]
        stringByAppendingString:underLine.stringValue]stringByAppendingString:@") -- "] stringByAppendingString:@"Under"];
    
    self.moneylines = [@[moneyLineAway, moneyLineHome] mutableCopy];
    self.spreads = [@[awaySpread, homeSpread] mutableCopy];
    self.overUnder = [@[over, under] mutableCopy];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(section == 0) {
        return @"Moneyline";
    }
    else if (section == 1) {
        return @"Spread";
    }
    else {
        return @"Over/Under";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"oddsCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"oddsCell"];
    }
    
    NSString *info;
    UILabel *infoLabel = (UILabel *)[cell viewWithTag:1];
    if (indexPath.section == 0) {
        infoLabel.textColor = [UIColor purpleColor];
        info = self.moneylines[indexPath.row];
    }
    else if (indexPath.section == 1) {
        infoLabel.textColor = [UIColor darkGrayColor];
        info = self.spreads[indexPath.row];
    }
    else {
        infoLabel.textColor = [UIColor orangeColor];
        info = self.overUnder[indexPath.row];
    }
    infoLabel.text = info;
    
    return cell;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
