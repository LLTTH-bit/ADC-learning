%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                              Example 1.1                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%-------------------------Simulation parameters---------------------------%
%                                                                         %
%   The number of points used in the simulation equals the main clock     %
%   frequency = 2048 Hz. The sampling frequency is 2048 Hz / 64 = 32 Hz.  %
%   The input signal is a truncated  sin(wt)/(wt) function.               %
%                                                                         %
%-------------------------------------------------------------------------%

clear;
close all;
clc;
points=2^11;           
S=64;                   % sampling period
t=[1:points];           % clock-times (x 2048) used in the simulation
N=128;                  % number of points used in the modulating function

tt=8*pi*[(0:N-1)/(N-1)]-4*pi+0.001;    
w=(sin(tt)./tt)';       % the above 0.001 shift avoids 0/0 in the sin(x)/x
tw=[0:N-1];
tw=tw*points/(N-1);
y=interp1(tw,w,t)  ;    % interpolation of w

%---------------------------Graphics--------------------------------------%
%                                                                         %
%    figure(1) --> Fig 1.5 page 6                                         %
%    figure(2) --> Fig 1.6 page 7                                         %
%                                                                         %
%-------------------------------------------------------------------------%

figure(1);
plot(y);
grid on;
title('Modulating Function in the Time-domain')
axis([1 points -1 1]); 
sp=abs(fft(y));         % spectrum of the pseudo sinc function
hold on;
plot([1 points],[-0.6 -0.6],'r-x');
hold off;
text(points/2,-0.5,'1 sec', 'HorizontalAlignment','center', 'Fontsize',...
    12, 'Color', 'r');

figure(2)
plot(sp(1:40));
title('Spectrum of the Modulating Function');
grid on;
xlim([1,40]);

%-------------------------------------------------------------------------%
%                                                                         %
%        Modulation of the truncate sinc with pure sine waves             %
%                                                                         %
%-------------------------------------------------------------------------%

f1=1/1024;              % frequencies
f2=3/1024;
f3=5/1024;
f4=7/1024;              %相当于2 6 10 14hz的正弦波，sinc函数为4hz
sin1=sin(2*pi*f1*t);    % sinewaves
sin2=sin(2*pi*f2*t);
sin3=sin(2*pi*f3*t);
sin4=sin(2*pi*f4*t);
k0=1;                 % amplitudes of components�
k1=1;
k2=1;
k3=1;
k4=1.2;
%-------------------------------------------------------------------------%
%                                                                         %
%                Weigthed superposition of components                     %
%                                                                         %
%-------------------------------------------------------------------------%

yout=k0*y+k1*y.*sin1+k2*y.*sin2+k3*y.*sin3+k4*y.*sin4;

%-----下面是自己修改的代码-----%
y1 = y.*sin1;
y2 = y.*sin2;
y3 = y.*sin3;
y4 = y.*sin4;
%------&&&&&&&&&&&&&&&&&&-----%


%-------------------------------------------------------------------------%
%                                                                         %
%                               Sampling                                  %
%                                                                         %
%-------------------------------------------------------------------------%

index=1;
b=S;
for i=1:points
    if i<b
        ysamp(i)=0;
    end
    if i==b
        ysamp(i)=yout(index)*S;
        b=b+S;
        index=index+S;
    end
end

%---------------------------Graphics--------------------------------------%
%                                                                         %
%    figure(3) --> Fig 1.7 page 7                                         %
%    figure(4) --> Fig 1.8 page 8                                         %
%                                                                         %
%-------------------------------------------------------------------------%

sp=abs(fft(yout));      % spectrum of the signal before sampling
figure(3)
plot(sp(1:100));
title('Spectrum of the Input Signal')
grid on;
xlim([1,100]);

figure(4)
sp=abs(fft(ysamp));     % spectrum of the sampled signal
plot(sp(1:100));
title('Spectrum of the sampled Signal')
grid on;
xlim([1,100])