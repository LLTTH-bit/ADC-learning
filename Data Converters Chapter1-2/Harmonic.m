%% harmonic component folded into the first nyquist zone
close all;
clear;
clc;

%% 
fs = 1000;%sampling rate 1000hz
f1 = 300;%300hz
f2=600;%600hz,folded to 400hz 
f3 = 900;%900hz,folded to 100hz
f4 = 1200;%1200hz,floded to 200hz

T = 1/fs;

n = 0:T:999*T;

X = 20*sin(2*pi*f1*n) + 15*sin(2*pi*f2*n) + 10*sin(2*pi*f3*n) + 5*sin(2*pi*f4*n);


Y = abs(fft(X));

plot(Y(1:500),'color','b');
xlabel("f/hz");ylabel("magnitude");title("Harmonic Components");
grid on;
