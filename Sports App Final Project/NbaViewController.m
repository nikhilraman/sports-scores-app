//
//  ViewController.m
//  Sports App Final Project
//
//  Created by Nikhil Raman on 4/21/16.
//  Copyright © 2016 cis195. All rights reserved.
//

#import "NbaViewController.h"
#import "BettingInfoViewController.h"

#define baseNBAOddsURL @"https://jsonodds.com/api/odds/nba?oddType=Game" 

#define JsonOddsApiKey @"c423e5a1-c2f0-41b9-91fb-417a57117006"

@interface NbaViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray *gamesArray;
@property NSDictionary *singleGameOdds;
@property NSString *homeTeamSelected;
@property NSString *awayTeamSelected;


@end

@implementation NbaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.gamesArray = [[NSMutableArray alloc] init];
    [self loadGamesFromNbaApi];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.title = @"NBA Schedule";
    //self.navigationController.navigationItem.title = @"NBA Schedule";
    // Do any additional setup after loading the view, typically from a nib.
}

- (void) loadGamesFromNbaApi {
    // TO DO: Implement the gathering of data from the NBA API. Use the nba api url and create a request to gather a listing of today's games
    NSLog(@"Entering NBA game loading");
    NSURL *url = [NSURL URLWithString:baseNBAOddsURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:JsonOddsApiKey forHTTPHeaderField:@"JsonOdds-API-Key"];
    //[request setValue:@"Game" forKey:@"oddType"];
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest:request
                completionHandler:^(NSData * data, NSURLResponse *response, NSError *error) {
                    NSMutableArray *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                    //NSArray *games = [[json objectForKey:@"photos"] objectForKey:@"photo"];
                    self.gamesArray = [json mutableCopy];
                     NSLog(@"Obtained data");
                    dispatch_queue_t mainQueue = dispatch_get_main_queue();
                    dispatch_async(mainQueue, ^{
                        [self.tableView reloadData];
                    });
                }] resume];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // TO DO: Implement number of rows in section
    return self.gamesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     // TO DO: Implement the desired view for each cell to be displayed
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"nbaGameCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"nbaGameCell"];
    }
    
    
    NSDictionary *game = self.gamesArray[indexPath.row];
    NSString *homeTeam = [game objectForKey:@"HomeTeam"];
    UILabel *homeTeamLabel = (UILabel *)[cell viewWithTag:2];
    homeTeamLabel.textColor = [UIColor blueColor];
    //homeTeamLabel.textColor = [UIColor lightTextColor];
    homeTeamLabel.text = homeTeam;
    
    NSString *awayTeam = [game objectForKey:@"AwayTeam"];
    UILabel *awayTeamLabel = (UILabel *)[cell viewWithTag:1];
    awayTeamLabel.textColor = [UIColor redColor];
    //awayTeamLabel.textColor = [UIColor lightTextColor];
    awayTeamLabel.text = awayTeam;
    
    NSString *dateString = [game objectForKey:@"MatchTime"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    NSDate *gameTime = [dateFormatter dateFromString:dateString];
    //NSLog(@"Date is: %@", [dateFormatter stringFromDate:gameTime]);
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"EDT"]];
    [dateFormatter setDateFormat:@"MM/dd '|' hh:mm"];
    NSString *newDateString = [dateFormatter stringFromDate:gameTime];
    UILabel *dateLabel = (UILabel *)[cell viewWithTag:3];
    dateLabel.text = newDateString;
    
    //[gameTime ]
    
    
    //UILabel *testLabel = (UILabel *)[cell viewWithTag:1];
    //testLabel.text = @"test!";
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // TO DO: Handle what happens if user taps on a cell
    
    NSDictionary *game = self.gamesArray[indexPath.row];
    NSArray *gameOdds = [game objectForKey:@"Odds"];
    self.singleGameOdds = gameOdds[0];
    self.homeTeamSelected = [game objectForKey:@"HomeTeam"];
    self.awayTeamSelected = [game objectForKey:@"AwayTeam"];
    [self performSegueWithIdentifier:@"nbaToOdds" sender:self];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:@"nbaToOdds"]) {
        UITabBarController *tbc = (UITabBarController *)segue.destinationViewController;
        BettingInfoViewController *biVC = [tbc.viewControllers objectAtIndex:0];
        biVC.odds = self.singleGameOdds;
        biVC.homeTeamName = self.homeTeamSelected;
        biVC.awayTeamName = self.awayTeamSelected;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
