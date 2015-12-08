//*******Global Variables************
//Variables
//initialize which to 0 to bring user to home page at the start
int screen = 0; 
int numBalls = 51;
float damping = 0.09;
int border = 50;
float ballReturn = 0;
float gap;
float left;
String infoState;
PImage img;
int avg;

//New Array list that stores the executions      
ArrayList<Execution> executions = new ArrayList<Execution>();
ArrayList<ExecutionByRace> races = new ArrayList<ExecutionByRace>();
ArrayList<ExecutionByState> states = new ArrayList<ExecutionByState>();
ArrayList<Float> sumExcut = new ArrayList<Float>();


//Arrays
float[] yearTotals = new float[395]; 
Ball[] balls = new Ball[numBalls];

//add mp3 for background music
import ddf.minim.*;
AudioPlayer player;
Minim minim;//audio context

//control P5
import controlP5.*;
ControlP5 cp5;
ControlP5 button;
int myValue = int(0);


void setup()
{
  size(1200, 600);
  textSize(10);
  frame.setResizable(true);
  smooth();
  frameRate(60);
  
  //play creepy ambience music in background
  minim = new Minim(this);
  player = minim.loadFile("UNDERGROUND ( Dark Ambient Music ) creepy Horror music.mp3", 2048);
  player.play();
  
  //call the load execution function
  loadExecutions();
  loadExecutPerYear();
  loadExecutionByRace();
  loadExecutionByState();
  loadBalls();
  
  //calcualte amount of buttons on screen three for scatter graph
  gap = 1200 /states.size();
  
  
  
//***************** control p5 *********************
  noStroke();
  cp5 = new ControlP5(this);
      
  // add a vertical slider
  cp5.addSlider("slider")
   .setPosition(80,10)
   .setSize(400,20)
   .setRange(0,394)
   .setValue(394)
   .setCaptionLabel("2002")
   ;
     
  // reposition the Label for controller 'slider'
  cp5.getController("slider").getValueLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
  cp5.getController("slider").getCaptionLabel().align(ControlP5.RIGHT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);

  button = new ControlP5(this);
  for(int i = 0; i < states.size(); i++)
  {
    button.addButton(states.get(i).stateAbr)
    .setValue(i)
    .setPosition(i*gap,0)
    .setSize(int(gap), int(gap))
    ;
  }
  infoState = "";
//*************************** 
}

//Control P5
void slider(int value) {
  myValue = int(value);
}




void draw()
{
  background(0);
  
  //assigns screen value to which user has chosen
  if(keyPressed)
  {
    if (key == '0')
    {
      screen = 0;
      //Bar chart slider hidden from menu
      cp5.setVisible(false);
      fill(255);
      ballReturn = 1;
    }
    if (key == '1')
    {
      screen = 1;
      //Bar chart slider hidden from screen one
      cp5.setVisible(false);
      button.setVisible(false);
      ballReturn = 1;
    }
    if (key == '2')
    {
      screen = 2;
      //Bar chart slider set to true so it is shown
      cp5.setVisible(true);
      button.setVisible(false);
      ballReturn = 1;
      
    }
    if(key == '3')
    {
      cp5.setVisible(false);
      button.setVisible(true);
      screen = 3;
      ballReturn = 0;
    }
    
    if(key == '4')
    {
      cp5.setVisible(false);
      button.setVisible(false);
      screen = 4;
      ballReturn = 0;
    }
    
  }
  
  if(screen == 0)
  {
    textAlign(CENTER,CENTER);
    textSize(12);
    frame.setSize(600, 600);
    fill(0);
    //initialy set to false
    cp5.setVisible(false);
    button.setVisible(false);
    
    //loads background image into menu
    img = loadImage("noose.jpg");
    img.resize(600,600);
    image(img, 0, 0);
    
    //calls menu function
    menu();
    
  }
  
  if(screen == 1)
  {
    frame.setSize(600, 600);
    drawTrendLineGraph(races, "1608");
  }
  
  if(screen == 2)
  {
    frame.setSize(600, 600);
    drawBarChart();
    
  }
  
  if(screen == 3)
  {
    frame.setSize(1200, 700);
    textSize(18);
    ballProjection();
    showStateInfo();
  }
  
  if(screen == 4)
  {
    frame.setSize(600, 600);
    
    //loads background image into menu
    img = loadImage("graveyard.jpg");
    img.resize(600,600);
    image(img, 0, 0);
    
    textSize(25);
    textAlign(CENTER,CENTER);
    fill(255);
    stroke(0);
    text("Interesting Facts", 300, 50); 
    textSize(15);
    avg = averageAge(executions.size());
    text("Average age of prisoners: " + avg  + " years old", 300, 200);
}
 

    
}
//displays info about state when state button clicked
 void controlEvent(ControlEvent theEvent)
{ 
    infoState = theEvent.getController().getName();
}

//finds the average age in the data set
int averageAge(float size)
{
    float sum=0;
    int avrg=0;
    float ages[] = new float[executions.size()];
    for(int i =0;i< size;i++)
    {
      if(executions.get(i).age != 0)
      {
        ages[i] = executions.get(i).age;
        sum = ages[i] + sum; 
      }
    }
    
    //7338 == number of cells that have an age
    avrg = int(sum/7338);
    return avrg;
}


//displays box displaying the state details using execution by state details
void showStateInfo()
{
  for(int i = 0 ; i < states.size();i++)
  {
    if(infoState == states.get(i).stateAbr)
    {
      rect(0,0,150,80);
      fill(0);
      textAlign(CENTER,CENTER);
      textSize(18);
      text(states.get(i).state, 70,40);
      textSize(12);
      text("Total Executions: " + int(states.get(i).total), 70,60);
      println(infoState);
      textSize(12);
    }
  }
}

//loads the executions main file
void loadExecutions()
{
     String[] lines = loadStrings("executions.csv");
    for (int i = 0 ; i < lines.length ; i ++)
    {
      Execution execution = new Execution(lines[i]);
      executions.add(execution);
    }
        
}

//This is what is displayed in the line graph amount of executions carried out in each given year
void loadExecutPerYear()
{
  String[] strings = loadStrings("sumExcut.csv");
  
  for(String s:strings)
  {
    sumExcut.add(parseFloat(s));
  }
  
}

void loadExecutionByRace()
{
    String[] lines = loadStrings("executions_by_race.csv");
    for (int i = 0 ; i < lines.length ; i ++)
    {
      ExecutionByRace raceYear = new ExecutionByRace(lines[i]);
      races.add(raceYear);
      
      //adds each race total to give overall total for that year.
      yearTotals[i] = races.get(i).white + races.get(i).black + races.get(i).hispanic + races.get(i).nativeAmer;
      
    }
        
}

void loadBalls()
{
  for (int i = 0; i < numBalls; i++) {
    //divide the diameter by 5 in order to get a good ratio to fit screen
    balls[i] = new Ball(0, 0, states.get(i).total/5, i, random(250), states.get(i).stateAbr, states.get(i).state);
  }
}

void loadExecutionByState()
{
    String[] lines = loadStrings("totalStateExecutions.csv");
    for (int i = 0 ; i < lines.length ; i ++)
    {
      ExecutionByState state = new ExecutionByState(lines[i]);
      states.add(state);
    }
        
}

//displays the balls represented by each state
//balls size represents the amount of executions that took place in that state
void ballProjection()
{
  //used to reload the balls when user returns to screen 3
  if(ballReturn == 0)
    {
      loadBalls();
    } 
    
    // get min/max values for each sort axis and store in array
    float[] minMaxX = new float[2];
    float[] minMaxY = new float[2];
   
    //Sorts balls in relation to there diameter smallest to largest based on the x-axis
    minMaxX = getMinMax("diameter", balls.length);
    
    //sorts hue of color from smallest to largest in relation to y axis i.e keep all similar color in one row
    minMaxY = getMinMax("hue", balls.length);
  
    //iterate through each ball in order to plot
    for (int i = 0; i < balls.length; i++) {
      
      //displays balls moving at a smooth rate across to their final destination on the x and y axis
      balls[i].display();
      
      //pushes balls from the left of the screen
      float offsetX = border;
      float offsetY = border;
      
      //plots balls within a fixed area
      float plotW = width - border*4;
      float plotH = height - border*4;
      
      
      float valX = balls[i].diameter;
      float valY = balls[i].hue;
      
       // map values to x and y axis
      float posX = map(valX , minMaxX[0], minMaxX[1], offsetX*2, offsetX + plotW);
      float posY = map(valY , minMaxY[0], minMaxY[1], offsetY * 2, offsetY + plotH);
      
      // check if photo is visible
      balls[i].position(posX, posY);
    }
    ballReturn = 1;
}

//used to sort each of the values in the ball array from min to max 
float[] getMinMax(String sortField, int count) {
   
  // create temporary array to hold sort values
  float tempArray[] = new float[count];
   
  // populate temporary array with sort values
  for (int i = 0; i < balls.length; i++) {
    if (sortField == "diameter") { // only add to array if photo is visible
      tempArray[i] = balls[i].diameter;
    } else if (sortField == "hue") {
      tempArray[i] = balls[i].hue;
    }
    
  }
   
  // store minumum and maximum values in array. minMax[0] store minimum; minMax[1] stores maximum
  float[] minMax = new float[2];
   
  minMax[0] = MAX_FLOAT; // MAX_FLOAT is the highest possible float number
  minMax[1] = MIN_FLOAT; // MIN_FLOAT is the lowest possible float number
 
  for (int i = 0; i < tempArray.length; i++) {
     if (tempArray[i] < minMax[0]) { // get minimum
       minMax[0] = tempArray[i];
     }
     if (tempArray[i] > minMax[1]) { // get maximum
       minMax[1] = tempArray[i];
     }
     
  }
   
  return minMax;
}


//draws bar chart for particular year
//years technically measured from 0 -> 394 i.e 1608 -> 2002
void drawBarChart()
{
  float border = width*0.1f;
  // Print the text 
   textAlign(CENTER, CENTER);   
   float textY = (50); 
   textSize(15);
   text("Executions By Race for year: "+ (myValue+1608), width * 0.5f, textY);
 
   drawBarAxis();  
  float barWidth = (width-(border*2)) / 4;
  
  //White Bar
  fill(255);
  stroke(255);
  float x = 0 * barWidth + border;
  rect(x, height-border, barWidth, - map(int(races.get(myValue).white),0,150,0,height));
  text("White",x + (width/8), height - (border*0.5));
  text(int(races.get(myValue).white), x + (width/8), height - (border*0.8));

  //Black Bar  
  fill(50);
  stroke(50);
  float x1 = 1 * barWidth  + border;
  rect(x1, height-border, barWidth, - map(int(races.get(myValue).black),0,150,0,height));
  fill(255);
  text("Black",x1 + (width/8), height - (border*0.5));
  text(int(races.get(myValue).black), x1 + (width/8), height - (border*0.8));
  
  //Hispanic Bar
  fill(130);
  stroke(130);
  float x2 = 2 * barWidth  + border;
  rect(x2, height-border, barWidth, - map(int(races.get(myValue).hispanic),0,150,0,height));
  fill(255);
  text("Hispanic",x2 + (width/8), height - (border*0.5));
  text(int(races.get(myValue).hispanic), x2 + (width/8), height - (border*0.8));
  
  //Native American Bar
  fill(190);
  stroke(190);
  float x3 = 3 * barWidth  + border;
  rect(x3, height-border, barWidth, - map(int(races.get(myValue).nativeAmer),0,150,0,height));
  fill(255);
  text("Native Amer.",x3 + (width/8), height - (border*0.5));
  text(int(races.get(myValue).nativeAmer), x3 + (width/8), height - (border*0.8));
}

void drawBarAxis()
{
  float border = width*0.1f;
  line(border, height - border, width - border, height - border);
  
  // Draw the vertical axis
  line(border, border , border, height - border);
}


//Draw the Vertical and Horizontal axis Line Graph 
void drawAxis(ArrayList<Execution> executions, int horizIntervals, int verticalIntervals, float vertDataRange, float border)
{
  stroke(200, 200, 200);
  fill(200, 200, 200);  
  
  // Draw the horizontal azis  
  line(border, height - border, width - border, height - border);
  
  float windowRange = (width - (border * 2.0f));  
  float tickSize = border * 0.1f;
      
  for (int i = 0 ; i <= horizIntervals ; i ++)
  {   
   // Draw the ticks
   float x = map(i, 0, horizIntervals, border, border + windowRange);   
      
   textAlign(CENTER, CENTER);   
   float textY = height - (border * 0.5f); 
   text((int) map(i, 0, horizIntervals, 1602, 2002), x, textY);
   
  } 
  
  // Draw the vertical axis
  line(border, border , border, height - border);
  
  for (int i = 0 ; i <= verticalIntervals ; i ++)
  {
    float y = map(i, 0, verticalIntervals, height - border,  border);
    line(border - tickSize, y, border, y);
    float hAxisLabel = map(i, 0, verticalIntervals, 0, vertDataRange);
        
    textAlign(RIGHT, CENTER);  
    text((int)hAxisLabel, border - (tickSize * 2.0f), y);
  }   
}

//draws the graph using draw axis
void drawTrendLineGraph(ArrayList<ExecutionByRace> data, String title)
{
  background(0);
  float border = width * 0.1f;
  // Print the text 
   textAlign(CENTER, CENTER);   
   float textY = (border * 0.5f); 
   text("Capital Punishment data 1602 - 2002", width * 0.5f, textY);
   textSize(12);
   fill(0,0,255);
   text("White",width * 0.8, textY);
   fill(0,255,0);
   text("Black",width * 0.8, textY+15);
   fill(255,255,0);
   text("Hispanic",width * 0.8, textY+30);
   fill(255,0,0);
   text("NativeAmer",width * 0.8, textY+45);
   
   
  drawAxis(executions, 10, 10, 130, border);   
  float windowRange = (width - (border * 2.0f));
  float dataRange = 130;      
  float lineWidth =  windowRange / (float) (data.size() - 1) ;
  
  stroke(0,0,255);
  for (int i = 1 ; i < data.size() ; i ++)
  {
    float x1 = map(i - 1, 0, data.size(), border, border + windowRange);
    float x2 = map(i, 0, data.size(), border, border + windowRange);
    float y1 = map(data.get(i - 1).white, 0, dataRange, height - border, (height - border) - windowRange);
    float y2 = map(data.get(i).white, 0, dataRange, height - border, (height - border) - windowRange);
    line(x1, y1, x2, y2);
  }  
  
    stroke(0,255,0);
  for (int i = 1 ; i < data.size() ; i ++)
  {
    float x1 = map(i - 1, 0, data.size(), border, border + windowRange);
    float x2 = map(i, 0, data.size(), border, border + windowRange);
    float y1 = map(data.get(i - 1).black, 0, dataRange, height - border, (height - border) - windowRange);
    float y2 = map(data.get(i).black, 0, dataRange, height - border, (height - border) - windowRange);
    line(x1, y1, x2, y2);
  } 
  
     stroke(255,255,0);
  for (int i = 1 ; i < data.size() ; i ++)
  {
    float x1 = map(i - 1, 0, data.size(), border, border + windowRange);
    float x2 = map(i, 0, data.size(), border, border + windowRange);
    float y1 = map(data.get(i - 1).hispanic, 0, dataRange, height - border, (height - border) - windowRange);
    float y2 = map(data.get(i).hispanic, 0, dataRange, height - border, (height - border) - windowRange);
    line(x1, y1, x2, y2);
  }   
 
   stroke(255,0,0);
  for (int i = 1 ; i < data.size() ; i ++)
  {
    float x1 = map(i - 1, 0, data.size(), border, border + windowRange);
    float x2 = map(i, 0, data.size(), border, border + windowRange);
    float y1 = map(data.get(i - 1).nativeAmer, 0, dataRange, height - border, (height - border) - windowRange);
    float y2 = map(data.get(i).nativeAmer, 0, dataRange, height - border, (height - border) - windowRange);
    line(x1, y1, x2, y2);
  }   
}



//function to load up the menu screen
void menu()
{
   textSize(18);
   text("Capital Punishment Data\n USA:1608-2002",300,300);
   
   textSize(16);
   text("Press 1: Line Graph",300,370);
   text("Press 2: Bar Chart",300,390);
   text("Press 3: Scatter Graph",300,410);
   text("Press 4: Dataset Facts",300,430);
   text("Press 0: Return to Menu",300,450);
}



