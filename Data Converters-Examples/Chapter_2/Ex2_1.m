%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                              Example 2.1                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%-------------------------------------------------------------------------%
%                                                                         %
%                           Simulation parameters                         %
%                                                                         %
%-------------------------------------------------------------------------%

clear;
close all;
clc;
nbit=12;
points=2^nbit;
t=1:points;

%---------------------------INL random term-------------------------------%
%                                                                         %
%     generation of a random sequence of numbers whose maximum            %
%     is about 0.225                                                      %
%                                                                         %
%-------------------------------------------------------------------------%

gain_random=0.45;
INLR= gain_random*rand(points,1);
INLR=INLR-mean(INLR);%标准差为0.45，均值为0的一组数据

%---------------------------INL correlated term---------------------------%
%                                                                         %
%     generation of the polynomial function y=n+an^2+bn^3+cn^4            %
%     n=(running_bin-2^(N-1))/2^N                                         %
%                                                                         %
%-------------------------------------------------------------------------%

a=-0.01;
b=0.01;
c=0.02;
gain_corr=800;
n=([1:points]-points/2)/points;
y=a*n.*n+b*n.*(n.*n)+c*n.*(n.*(n.*n)   );
k=(y(points)-y(1))/(n(points)-n(1));
INL=gain_corr*((y-y(1))-(n-n(1))*k);
INL=INL';


%-------------------------------------------------------------------------%
%                                Total INL                                %
%-------------------------------------------------------------------------%

TOTALINL=(INL+INLR);

%-------------------------------------------------------------------------%
%                                   DNL                                   %
%-------------------------------------------------------------------------%

DNL=zeros(points,1);
DNL(1)=INL(1);
for i=2:points
DNL(i)=TOTALINL(i)-TOTALINL(i-1);
end

%--------------------------------Graphics---------------------------------%
%                                                                         %
%     figure(1) --> Figure 2.9(a) page 59                                 %
%     figure(2) --> Figure 2.9(b) page 59                                 %
%                                                                         %
%-------------------------------------------------------------------------%

figure(1);
plot(t,TOTALINL,t,INL);
grid
title('INL')
xlim([1 points])

figure(2);
plot(DNL);
grid
title('DNL')
xlim([1 points])

TOTALINL=TOTALINL/2^(nbit-1);

%-------------------------------------------------------------------------%
%                            Input sinewave                               %
%-------------------------------------------------------------------------%

timepoint=2^12;                 % number of samples
sinewaves=61;                   % number of periods
f_in=sinewaves/timepoint;       % input frequency
t=[1:timepoint];                % sample-times used
amp=0.45;                             
x=amp*sin(2*pi*f_in*t);

%-------------------------------------------------------------------------%
%                           Quantization error                            %
%-------------------------------------------------------------------------%

x=round(x*2^(nbit-1))/2^(nbit-1);
errq=amp*sin(2*pi*f_in*t)-x;
pow_er=sum(errq.*errq)

%-------------------------------------------------------------------------%
%                          INL error calculation                          %
%-------------------------------------------------------------------------%

for i=1:timepoint
    bin=x(i)*2^(nbit-1)+2^(nbit-1)/2;
    bb(i)=bin;
    err(i)=TOTALINL(bin);
end;

%--------------------------------Graphics---------------------------------%
%                                                                         %
%     figure(3) --> Figure 2.10(a) page 59                                %
%     figure(4) --> Figure 2.10(b) page 59                                %
%                                                                         %
%-------------------------------------------------------------------------%

spx=abs(fft(x));
sp=20*log10(spx+1e-10);       % spectrum
delta=max(sp);
sp=sp-delta;
figure(3);
plot(t(1:1024),sp(1:1024));
title('Reference Spectrum [DB]')
axis([0 1024 -120 0])
grid on;

y=x+err;
spy=abs(fft(y));
sp=20*log10(spy+1e-10);      % spectrum 
delta=max(sp);
sp=sp-delta;
figure(4);
plot(t(1:1024),sp(1:1024));
title('Spectrum of Signal corrupted by INL [dB]')
axis([0 t(1024) -120 0])
grid on;






