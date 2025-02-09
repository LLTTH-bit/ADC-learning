%% 计算等效噪声带宽
clear;
close all;
clc;
%% 矩形窗 hann窗 hann2窗
N=32;
rec = rectwin(N);
hann1 = hann(N);
hann2 = hann1.^2;

R = abs(fft(rec));
H1 = abs(fft(hann1));
H2 = abs(fft(hann2));

NBWR = sum(R.^2)/R(1)^2;

NBWH1 = sum(H1.^2)/H1(1)^2 ;

NBWH2 = sum(H2.^2)/H2(1)^2;