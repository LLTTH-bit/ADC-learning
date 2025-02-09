%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                              Example 7.2                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
%   1. Plots the Power Spectral Density of the bit-stream                 %
%   2. Calculates the SNR                                                 %
%   3. Calculates histograms at the integrator outputs                    %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear

t0=clock;

%-------------------------------------------------------------------------%
%                            Design variables                             %
%-------------------------------------------------------------------------%

bw=22.05e3;				% Base-band
R=64;                   % Oversampling
Fs=R*2*bw;				% Oversampling frequency
Ts=1/Fs;
N=1024*8;				% Samples number
nper=63;
Fin=nper*Fs/N;			% Input signal frequency (Fin = nper*Fs/N)
finrad=Fin*2*pi;		% Input signal frequency in radians
Amp_dB=-6;             % Input amblitude in dB

Ampl=10^(Amp_dB/20)-pi/1024;
Ntransient=100;
%
VrefN=-1;
VrefP=1;
Ncomp=7;
levelsDAC=160;
DeltaADC=(VrefP-VrefN)/(Ncomp+1)
DeltaDAC=(VrefP-VrefN)/(Ncomp)
ClipDAC=(levelsDAC-1)*DeltaDAC/2
MultiBit=0;

%-------------------------------------------------------------------------%
%                       Open Simulink diagram first                       %
%-------------------------------------------------------------------------%

options=simset('RelTol', 1e-3, 'MaxStep', 1/Fs);
sim('Ex7_2', (N+Ntransient)/Fs, options);	% Starts Simulink simulation

%-------------------------------------------------------------------------%
%       Calculates SNR and PSD of the bit-stream and of the signal        %
%-------------------------------------------------------------------------%

w=hann(N);
f=Fin/Fs                        % Normalized signal frequency
fB=N*(bw/Fs)                    % Base-band frequency bins
yy1=zeros(1,N);
yy1=yout(2+Ntransient:1+N+Ntransient)';

ptot=zeros(1,N);
[snr,ptot]=calcSNR(yy1(1:N),f,fB,w',N);
Rbit=(snr-1.76)/6.02;           % Equivalent resolution in bits

%-------------------------------------------------------------------------%
%                               Plots                                     %
%-------------------------------------------------------------------------%

figure(2);
clf;
semilogx(linspace(0,Fs/2,N/2), ptot(1:N/2), 'r');
grid on;
title('PSD of the Output')
xlabel('Frequency [Hz]')
ylabel('PSD [dB]')
axis([0 Fs/2 -200 0]);
text_handle = text(floor(Fs/R),-15, sprintf('SNR = %4.1fdB @ OSR=%d\n',snr,R));
text_handle = text(floor(Fs/R),-30, sprintf('Rbit = %2.2f bits @ OSR=%d\n',Rbit,R));

s1=sprintf('   SNR(dB)=%1.3f',snr);
s2=sprintf('   Simulation time =%1.3f min',etime(clock,t0)/60);
disp(s1)
disp(s2)

s1=sprintf('   SNR(dB)=%1.3f',snr);
s2=sprintf('   Simulation time =%1.3f min',etime(clock,t0)/60);
disp(s1)
disp(s2)
MaxOut=max(abs(yout));
LevelDAC=2*MaxOut/DeltaDAC+1
