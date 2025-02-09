%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                              Example 1.4                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
close all;
clc;

%-------------------------------------------------------------------------%
%                                                                         %
%                           Simulation parameters                         %
%                                                                         %
%-------------------------------------------------------------------------%

points=2^10;                    % The number of points used                   
f_in1=1/17;
f_in2=1/19;                     % input frequencies
t=[1:points];                   % sample-times used
                                % input signal
                                
x=0.4*sin(2*pi*f_in1*t)+0.6*sin(2*pi*f_in2*t);

%--------------------------------Graphics---------------------------------%
%                                                                         %
%    figure(1) --> Fig 1.22(a) page 29                                    %
%    figure(3) --> Fig 1.22(b) page 29                                    %
%    figure(4) --> Fig 1.23(a) page 30                                    %
%    figure(5) --> Fig 1.23(b) page 30                                    %
%                                                                         %
%-------------------------------------------------------------------------%

figure(1);
plot(x)
title('Input');
grid on;
xlim([1 points]);

w1 = window(@blackman,points);  % window
figure (2)
plot(w1(1:1024))
title('Blackman window');
grid on;
xlim([1 points]);

xw=x.*w1';                      % windowed input
figure (3)
plot(xw);
title('Windowed Input');
grid on;
xlim([1 points]);

sp=abs(fft(x));                 % spectrum of input
figure (4)
plot(sp(1:100));
title('Input Spectrum');
grid on;
xlim([1 100]);

sp=abs(fft(xw));                % spectrum of the windowed input
figure (5)
plot(sp(1:100))
title('Windowed Input Spectrum');
grid on;
xlim([1 100]);
