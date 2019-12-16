plot(c(0,8),c(0,8));f=function(x,y,d,l,v){if(l>.01){w=x+l*cos(d);z=y+l*sin(d);segments(x,y,w,z);f(w,z,d+pi/4*v,.38*l,v);f(w,z,d,.87*l,-v)}};f(4,0,pi/2,1,1)
