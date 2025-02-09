%% simple adc
clear;
close all;
clc;
%% generate sine sequence
fs = 1000;%sampling rate
f1 = 200;%signal frequency

T =1/fs;%sampling period

n = T:T:20*T;

x = 2^10*sin(2*pi*f1*n);
subplot(1,3,1);plot(x,'color','b');title("raw signal");xlabel("n");ylabel("magnitude");grid on;

x = round(x);
subplot(1,3,2);plot(x,'color','b');title("rounded signal");xlabel("n");ylabel("magnitude");grid on;
%% analog-digital-analog
x_d = dec2bin(x);%digital code

x_a = my_bin2dec(x_d);%signal converted from digital code

subplot(1,3,3);plot(x_a,'color','b');title("signal converted from digital code");xlabel("n");ylabel("magnitude");grid on;