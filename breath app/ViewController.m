//
//  ViewController.m
//  breath app
//
//  Created by av_tehnik on 1/16/16.
//  Copyright © 2016 vitaliy pitvalo. All rights reserved.
//

#import "ViewController.h"
#import "MovingAverage.h"
@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *breathrate;

@property (weak, nonatomic)  NSMutableArray *dataList;

@property (strong, nonatomic)  NSNumber *lastMax;
@property (strong, nonatomic)  NSNumber *lastMin;
@property (weak, nonatomic) IBOutlet UIProgressView *progress;
@property (strong, nonatomic) NSDate *lastTime;

@property Boolean *timeMesured;
@property double averageRate;
@property int measure;

@property Boolean *enabled;

@property (strong, nonatomic)  MovingAverage *averege;
@property double lastValue;

@property double lastMinValue;
@property double lastMaxValue;


@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
//    [[UIAccelerometer sharedAccelerometer] setUpdateInterval:0.33];
       [[UIAccelerometer sharedAccelerometer]setDelegate:self];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    self.dataList =  [NSMutableArray new];
    self.averege = [[MovingAverage alloc] initWithPeriod:10];

    self.timeMesured = false;
    
    self.measure = 0;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)start:(id)sender {

    [self.breathrate setText:@"0%"];
    
    self.averageRate = 0;
    self.measure = 0;
    self.enabled = YES;
    self.lastTime  =[NSDate date];
    [self.progress setProgress:0.0];
}


- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:







(UIAcceleration *)acceleration{
    
    
    int rate = 0;
    float beatsSum = 0;
    
    
    if(self.enabled){

    [self.averege addDatum:[NSNumber numberWithFloat:acceleration.y]];
    
    double movingAverage = self.averege.movingAverage ;
    
    movingAverage = movingAverage+10;

    if(self.lastMinValue==0.0000000){
        self.lastMinValue = movingAverage;
    }
    if(self.lastMaxValue==0.0000000){
        self.lastMaxValue = movingAverage;
    }
    
    
    if(self.lastMaxValue < movingAverage){
        self.timeMesured = false;
    }else{
        self.lastMaxValue = self.lastMinValue;
    }
    
    if(self.lastMinValue > movingAverage){
        
        if( self.timeMesured == false){
            NSDate *methodFinish = [NSDate date];
            NSTimeInterval executionTime = [methodFinish timeIntervalSinceDate:self.lastTime];
            
            
            if(executionTime>1){
                self.measure++;
                [self.breathrate setText:[NSString stringWithFormat:@"%i%%", (self.measure*10)]];
                self.averageRate = self.averageRate + executionTime;
                [self.progress setProgress:(self.measure/10.f)];
                NSLog(@"%i", self.measure);

            }
            
            self.lastTime  =[NSDate date];
            self.timeMesured = true;
            

            
            if(self.measure==10){
                self.enabled = NO;
                
                while(beatsSum<60){
                    beatsSum = beatsSum + (self.averageRate/10);
                    rate++;
                }

                [self.breathrate setText:[NSString stringWithFormat:@"%iBPm",rate]];
                
                
            }
            
            
        }
    }else{
        self.lastMinValue = self.lastMaxValue;
    }
    
    
    if(self.lastMaxValue < movingAverage){
        self.lastMaxValue = movingAverage;
    }
    
    if(self.lastMinValue > movingAverage){
        self.lastMinValue = movingAverage;
    }
    }
    
}



@end
