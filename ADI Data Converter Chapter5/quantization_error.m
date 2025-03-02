%% quantization error periodic
clear;
close all;
clc;

%% 
f_s  = 512;%sampling frequency
f_in = 64;%input frequency

n = 0:511;

T = 1/f_s;
t = n * T;


y = sin(2*pi*f_in*t);
y_r= round(y);
y_d = y - y_r;

Y = abs(fft(y_r));

subplot(1,2,1);

stem(t(1:64),y(1:64));
xlabel("t");
ylabel("Magnitude");
title("Sampled Data");
grid on;% Time Domain


subplot(1,2,2);
plot(0:255,Y(1:256));

xlabel("f/Hz");
ylabel("Magnitude");
title("FFT");
grid on;%Freq Domain