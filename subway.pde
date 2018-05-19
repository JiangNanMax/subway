Table table;       //站点信息
Table link;        //站点间的连接
Table traffic;    //客流量
PImage shanghai;
int R,C;          //临时变量
int w = 1280;     //宽
int h =720;      //高
float minLng = 134.6412879;  //经度范围
float maxLng = 135.9199972;
float minLat = 35.9535469;   //纬度范围
float maxLat = 36.6819062;
int interval = 1;                //绘图的间隔
int N = 24*60/interval;          //interval为1，一分钟采集一次
int current = 5 * 60;          //当前时间点
int offset = 0;                //标识进站或出站


void setup() {
  size(1280,720);
  smooth();
  background(250);
  fill(102);
  strokeCap(ROUND);
  frameRate(30);
  textFont(createFont("MicrosoftYaHei",13));
  table = loadTable("stations_with_geo.csv");
  link = loadTable("links_with_geo.csv");
  traffic = loadTable("oneday_traffic.csv");
  shanghai = loadImage("shanghai.png");
}

void draw() {
  drawBackground();
  
  for(int i=0;i<304;i++){
    float lat=traffic.getFloat(current,i*7);
    float lng=traffic.getFloat(current,i*7+1);
    int cr=traffic.getInt(current,i*7+2);
    int cg=traffic.getInt(current,i*7+3);
    int cb=traffic.getInt(current,i*7+4);
    float entry;
    
    if(offset==0){
      entry=traffic.getFloat(current,i*7+5)*3;
    }else{
      entry=traffic.getFloat(current,i*7+6)*3;
    }
    fill(cr,cg,cb,120);
    ellipse(w*(lng-minLng)/(maxLng-minLng),h*(maxLat-lat)/(maxLat-minLat),entry,entry);
  }
  
  current=current+1;

  if(current==N){
    exit();
  }
}

void drawBackground() {
  image(shanghai,0,0,w,h);
  int bg=250;
  
  int hour=current/60;
  int minute=current%60;
  fill(bg);
  textSize(30);
  if(hour<10 &&minute<10){
    text('0'+str(hour)+":0"+str(minute),950,60);
  }else if(hour>=10 && minute<10){
    text(str(hour)+":0"+str(minute),950,60);
  }else if(hour<10 && minute>=10){
    text('0'+str(hour)+":"+str(minute),950,60);
  }else{
    text(str(hour)+":"+str(minute),950,60);
  }
  textSize(18);
  if(offset==0){
    text("Entries / per 3m", 1050, 60);
  }else{
    text("Exits / per 3m", 1050, 60);
  }
  textSize(12);
  int tmp=0;
  for(int i=0;i<10;i++){
    String s=traffic.getString(N+current-current%10,10*2*offset+i*2);
    int num=traffic.getInt(N+current-current%10,10*2*offset+i*2+1);
    if(num>=20){
      textAlign(RIGHT);
      fill(bg);
      text(s,1020,96+20*tmp);
      textAlign(LEFT);
      text(num,1050+num/5, 96+20*tmp);
      noStroke();
      fill(bg,255-tmp*20);
      rect(1040, 96+20*tmp-9,num/5,10);
      tmp+=1;
    }
  }
  
  
  R=link.getRowCount();
  C=link.getColumnCount();
  for(int i=0;i<R;i++){
    float latO=link.getFloat(i,1);
    float lngO=link.getFloat(i,2);
    float latD=link.getFloat(i,4);
    float lngD=link.getFloat(i,5);
    int cr=link.getInt(i,7);
    int cg=link.getInt(i,8);
    int cb=link.getInt(i,9);
    stroke(cr,cg,cb);
    strokeWeight(2);
    line(w*(lngO-minLng)/(maxLng-minLng), h*(maxLat-latO)/(maxLat-minLat), w*(lngD-minLng)/(maxLng-minLng), h*(maxLat-latD)/(maxLat-minLat));
  }
  
  R=table.getRowCount();
  C=table.getColumnCount();
  for(int i=0;i<R;i++){
    float lat=table.getFloat(i,1);
    float lng=table.getFloat(i,2);
    int category=table.getInt(i,4);
    if(category==1){
      fill(204);
      noStroke();
      ellipse(w*(lng-minLng)/(maxLng-minLng), h*(maxLat-lat)/(maxLat-minLat),6,6);
    }else{
      fill(204);
      noStroke();
      ellipse(w*(lng-minLng)/(maxLng-minLng), h*(maxLat-lat)/(maxLat-minLat),3,3);
    }
  }
}
