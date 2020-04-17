
float xp=abs(skeleton_points.get(4).x-skeleton_points.get(7).x);
float xp2=abs(skeleton_points.get(4).x-skeleton_points.get(11).x)+abs(skeleton_points.get(7).x-skeleton_points.get(14).x);
float yp=abs(skeleton_points.get(4).y-skeleton_points.get(7).y);
float yp2=abs(skeleton_points.get(4).y-skeleton_points.get(11).y)+abs(skeleton_points.get(7).y-skeleton_points.get(14).y);
float mov=xp*xp2*yp*yp2;
float feathery=map(mov,0,3000,0,1000);
float t=0;
float g =9;
{

if(feathery<200){
  //feather dropping
    //feather floating
    pushMatrix();
    float v=3;
    v=v*1.2;
    feathery= feathery+v*frameCount;
    translate(50, feathery, -200);
    tint(255, 255, 255, tintAlpha);
    img = loadImage("feather_small.png");
    image(img, 0, 0);
    popMatrix();
}
if(feathery>=200&feathery<700){
  //feather floating
    pushMatrix();
    translate(50, feathery+sin(t)*18, -200);
    tint(255, 255, 255, tintAlpha);
    img = loadImage("feather_small.png");
    image(img, 0, 0);
    popMatrix();
}
if(feathery>=700){
  feather rise
}

float xn=0;
//inside void draw
float xdist=skeleton_points.get(4).x-xn;
xn=skeleton_points.get(4).x;
