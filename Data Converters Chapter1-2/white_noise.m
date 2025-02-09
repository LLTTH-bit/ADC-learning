%% add white noise to sine sequence
clear;
close all;
clc;
%% generate sine sequence-add white nois-FFT
f1 = 200;%signal frequency
fs = 1000;%sampling rate
T = 1/fs;%sampling period

n = 1*T:T:1000*T;

x = 10*sin(2*pi*f1*n);

n = randn(1,1000);
xn = x+n;

Y = abs(fft(x));
YN = abs(fft(xn));

Yd = YN-Y;%diff

subplot(1,3,1);plot(Y(1:500),'color','b');title("Before");xlabel("f/hz");ylabel("magnitude");grid on;
subplot(1,3,2);plot(YN(1:500),'color','b');title("After");xlabel("f/hz");ylabel("magnitude");grid on;
subplot(1,3,3);plot(Yd(1:500),'color','b');title("Diff");xlabel("f/hz");ylabel("magnitude");grid on;


