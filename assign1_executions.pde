//*******Global Variables************

//New Array list that stores the executions      
ArrayList<Execution> executions = new ArrayList<Execution>();
ArrayList<Float> sumExcut = new ArrayList<Float>();
//initialize which to 0 to bring user to home page at the start
int screen = 0; 


void setup()
{
  size(500, 500);
  background(0);
  
  //call the load execution function
  loadExecutions();
  loadExecutPerYear();

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
    }
    if (key == '1')
    {
      screen = 1;
    }
    if (key == '2')
    {
      screen = 2;
    }
  }
  
  if(screen == 0)
  {
    menu();
  }
  
  if(screen == 1)
  {
    drawTrendLineGraph(sumExcut, "1602");
  }
    
}
//function that loads the data into an array list
void loadExecutions()
{
    String[] lines = loadStrings("executions.csv");
    for (int i = 0 ; i < lines.length ; i ++)
    {
      Execution execution = new Execution(lines[i]);
      executions.add(execution);
    }
}

void loadExecutPerYear()
{
  String[] strings = loadStrings("sumExcut.csv");
  
  for(String s:strings)
  {
    sumExcut.add(parseFloat(s));
  }
  
}

//Draw the Vertical and Horizontal axis
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
    line(x, height - (border - tickSize)
      , x, (height - border));    
      
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
void drawTrendLineGraph(ArrayList<Float> data, String title)
{
  background(0);
  float border = width * 0.1f;
  // Print the text 
   textAlign(CENTER, CENTER);   
   float textY = (border * 0.5f); 
   text("Capital Punishment data 1602 - 2002", width * 0.5f, textY);
   
  drawAxis(executions, 10, 10, 200, border);   
  float windowRange = (width - (border * 2.0f));
  float dataRange = 200;      
  float lineWidth =  windowRange / (float) (data.size() - 1) ;
  
  stroke(255);
  for (int i = 1 ; i < data.size() ; i ++)
  {
    float x1 = map(i - 1, 0, data.size(), border, border + windowRange);
    float x2 = map(i, 0, data.size(), border, border + windowRange);
    float y1 = map(data.get(i - 1), 0, dataRange, height - border, (height - border) - windowRange);
    float y2 = map(data.get(i), 0, dataRange, height - border, (height - border) - windowRange);
    line(x1, y1, x2, y2);
  }  
}

//function to load up the menu screen
void menu()
{
   textSize(11);
   textAlign(CENTER,CENTER);
   text("Welcome to my programe",250,30);
   
   text("Please Select an Option:",250,50);
   text("Press 1: Line Graph",250,70);
   text("Press 2: Bar Chart",250,90);
   
}


