%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                              Example 5.1                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;
points=2^10;                % points of the fft
f_in=100e6;
Tin=1/f_in;
Nsin=19;                    % number of sine waves in set of points
Tfft=Tin*Nsin;
T=Tfft/points;
Fs=1/T;

%-------------------------------------------------------------------------%
%                            Design variables                             %
%-------------------------------------------------------------------------%

Vt=0.026;
A=1;
Ibias=40e-3;
Cs=2e-12;
% ---------------------
t=[1:points]*T;                   
x=A*sin(2*pi*f_in*t);               % input signal
xdot=A*2*pi*f_in*cos(2*pi*f_in*t);  % input derivative
for i=1:points
    num=Ibias+Cs*xdot(i);
    den=Ibias-Cs*xdot(i);
    y(i)=x(i)+Vt*log(num/den);      % output signal
end

%-------------------------------------------------------------------------% 
%                             Graphic Outputs                             %
%-------------------------------------------------------------------------%
w=hann(points);
f=f_in/Fs;                                 % Normalized signal frequency
bw=Fs/2;
fB=points*(bw/Fs);                         % Base-band frequency bins
[snr,ptot]=calcSNR(y,f,fB,w',points);

figure(1);
clf;
ptot=ptot-max(ptot);                       % Normalized spectrum
plot(linspace(0,Fs/2,points/2), ptot(1:points/2),'r');
grid on;
title('PSD of the Output')
xlabel('Frequency [Hz]')
axis([0 12*f_in -200 0]);
CapCurr=Cs*A*2*pi*f_in;                    % Cap current
ratio=Ibias/CapCurr
ptot(Nsin*3+1)
