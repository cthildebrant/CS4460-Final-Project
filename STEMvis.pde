import controlP5.*;
import org.gicentre.utils.stat.*;
import org.gicentre.utils.*;
import org.gicentre.utils.gui.Tooltip;
import de.bezier.data.*;
 
MyOwnClass moc;
BarChart barChart;
XlsReader reader;
Tooltip dod;
PVector lastClick;
PFont myFont;
PVector curr;
int[] stemGroups;
float[] genEnrollment;
String[] groupLabels;
int[] yearIndexes;
ControlP5 cp5;
int sliderValue = 0;
Slider sli;
int myColor = color(0,0,0);
 
// Initialises the sketch and loads data into the chart.
void setup()
{
  size(800,600);
  
  // Uncomment the following two lines to see the available fonts 
  //String[] fontList = PFont.list();
  //println(fontList);
  myFont = createFont("Georgia", 12);
  textFont(myFont);
  textAlign(CENTER, CENTER);
  
  moc = new MyOwnClass(this);
  
  lastClick = new PVector(0.0f, 0.0f);
  
  dod = new Tooltip((PApplet)this, myFont, 20.0f, width/6);
  dod.setText("Test");
  dod.setIsActive(false);
  
  cp5 = new ControlP5(this);
  cp5.addSlider("sliderValue")
     .setPosition(100,50)
     .setWidth(400)
     .setRange(2002, 2012) // values can range from big to small as well
     .setValue(128)
     .setNumberOfTickMarks(11)
     .setHandleSize(15)
     .snapToTickMarks(true)
     .setSliderMode(Slider.FLEXIBLE)
     ;
  
  // Column indexes for each year represented on the chart 
  yearIndexes = new int[11];
  for(int i=0; i<yearIndexes.length; i++){
     yearIndexes[i] = i+1;
  }
  
  //Row indexes of each minority group in the table, column is 0 for all
  stemGroups = new int[9];
  stemGroups[0] = 1; //ALL GROUPS ALL FIELDS, S&E is +2, nonS&E is +44
  //for the rest the index will be a string in the first cell on an empty row
  //go to index+1 for all fields
  //go to index+3 for S&E
  //go to index+45 for nonS&E
  stemGroups[1] = 47; // US Citizens
  stemGroups[2] = 94; // White
  stemGroups[3] = 141; // Asian or Pacific Islander
  stemGroups[4] = 188; // Black
  stemGroups[5] = 235; // Hispanic
  stemGroups[6] = 282; // American or Alaskan Native
  stemGroups[7] = 329; // Other
  stemGroups[8] = 376; // Temporary resident
  
  
  reader = new XlsReader( this, "table3.xls");

  genEnrollment = new float[6];
  groupLabels = new String[6];
  
  
  for(int i=0; i<groupLabels.length; i++){
    //println(reader.getString(stemGroups[i+2],0));
    groupLabels = new String[]{"White","Asian","Black","Hispanic","NA/AN","Other"};
  }
  //printArray(groupLabels);
  
  
  
  for(int i=0; i<genEnrollment.length; i++){
    genEnrollment[i] = reader.getFloat(stemGroups[i+2]+1, yearIndexes[0]);
    //index of year indeces should be from slider
  }
  
  //printArray(genEnrollment);
  
  barChart = new BarChart(this);
  barChart.setData(genEnrollment);
  
  // Scaling
  barChart.setMinValue(0);
  barChart.setMaxValue(1000000);
   
  // Axis appearance
  //textFont(createFont("Serif",1),1);
  textFont(myFont);
   // SIZE NOT CHANGING
  
  barChart.showValueAxis(true);
  barChart.setBarLabels(groupLabels);
  barChart.setBarGap(50);
  barChart.setCategoryAxisLabel("\nGroup");
  barChart.showCategoryAxis(true);
  barChart.showValueAxis(true);
}
 
// Draws the chart in the sketch
void draw()
{
  background(255);
  
  updateGenEnrollment();
  
  barChart.draw(75,50,width-50,height-75);
  dod.draw(lastClick.x, lastClick.y);
 
  // Draw a title over the top of the chart.
  fill(125);
  textSize(20);
  //text("General Enrollment of Racial Groups in 2002", 70,30);
  text("General Enrollment of Racial Groups in " + sliderValue, 70,30);
}

void mousePressed(){
  lastClick.x = mouseX;
  lastClick.y = mouseY;
  curr = barChart.getScreenToData(lastClick);
  if(curr!=null) updateDOD(curr);
  //println(barChart.getScreenToData(new PVector(mouseX, mouseY)));
  if(dod.isActive()){dod.setIsActive(false);}
  else if(curr!=null) dod.setIsActive(true);
}

void updateDOD(PVector vec){
  int i = (int)vec.x;
  String str;
  str = String.format("%s\n" + "%d", groupLabels[i], (int)genEnrollment[i]);
  //dod.setText(groupLabels[i]+ "\n" + genEnrollment[i]);
  dod.setText(str);
}

void updateGenEnrollment(){
  for(int i=0; i<genEnrollment.length; i++){
    genEnrollment[i] = reader.getFloat(stemGroups[i+2]+1, yearIndexes[sliderValue-2002]);
  }
}

class MyOwnClass
{
  PApplet sketchRef;

  MyOwnClass(PApplet pa)
  {
    sketchRef = pa;
  }
}
