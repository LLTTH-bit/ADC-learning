%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                              Example 6.5                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
%   1. Plots the Power Spectral Density of the bit-stream                 %
%   2. Calculates the SNR                                                 %
%   3. Calculates histograms at the integrator outputs                    %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;

t0=clock;

%-------------------------------------------------------------------------%
%                            Design variables                             %
%-------------------------------------------------------------------------%

bw=22.05e3;				% Base-band
R=64;                  % Oversampling
Fs=R*2*bw;				% Oversampling frequency
Ts=1/Fs;
N=1024*8;				% Samples number
nper=13;
Fin=nper*Fs/N;			% Input signal frequency (Fin = nper*Fs/N)
finrad=Fin*2*pi;		% Input signal frequency in radians
Amp_dB=-10;             % Input amblitude in dB

Ampl=10^(Amp_dB/20)-pi/1024;
Ntransient=100;
%
VrefN=-1;
VrefP=1;
Ncomp=7;
Delta=(VrefP-VrefN)/Ncomp

%-------------------------------------------------------------------------%
%                            Switches                                     %
%-------------------------------------------------------------------------%

SatQuant=0;             % if 0 no saturation if 1 saturation
QuantSat=1;             % Quantizer satuation ampitude
MultiBit=0;             % if 0 1-bit if 1 multi-bit
SatFirst=0;             % if 0 no saturation if 1 saturation
SatSecond=0;            % if 0 no saturation if 1 saturation
Vsat1=1.0;              % hard saturation of the second integrator
Vsat2=1.0;              % hard saturation of the second integrator

if MultiBit==0
    Ncomp=1;
end


s0=sprintf('** Simulation Parameters **');
s1=sprintf('   Fs(Hz)=%1.0f',Fs);
s2=sprintf('   Ts(s)=%1.6e',Ts);
s3=sprintf('   Fin(Hz)=%1.4f',Fin);
s4=sprintf('   BW(Hz)=%1.0f',bw);
s5=sprintf('   OSR=%1.0f',R);
s6=sprintf('   Npoints=%1.0f',N);
s7=sprintf('   tsim(sec)=%1.3f',N/Fs);
s8=sprintf('   Nperiods=%1.3f',N*Fin/Fs);
disp(s0)
disp(s1)
disp(s2)
disp(s3)
disp(s4)
disp(s5)
disp(s6)
disp(s7)
disp(s8)

%*************************************************************************%
A=1/2;
B=1/2;
%*************************************************************************%

%-------------------------------------------------------------------------%
%                       Open Simulink diagram first                       %
%-------------------------------------------------------------------------%

options=simset('RelTol', 1e-3, 'MaxStep', 1/Fs);
sim('Ex6_5', (N+Ntransient)/Fs, options);	% Starts Simulink simulation


%-------------------------------------------------------------------------%
%   Calculates SNR and PSD of the bit-stream and of the signal            %
%-------------------------------------------------------------------------%

w=hann(N);
f=Fin/Fs			% Normalized signal frequency
fB=N*(bw/Fs)		% Base-band frequency bins
yy1=zeros(1,N);
yy1=yout(2+Ntransient:1+N+Ntransient)';
y1_1=y1;
y2_1=y2;

ptot=zeros(1,N);
[snr,ptot]=calcSNR(yy1(1:N),f,fB,w',N);
Rbit=(snr-1.76)/6.02;	% Equivalent resolution in bits


%*************************************************************************%
A=1/2;
B=2;
%*************************************************************************%

%-------------------------------------------------------------------------%
%                       Open Simulink diagram first                       %
%-------------------------------------------------------------------------%

options=simset('RelTol', 1e-3, 'MaxStep', 1/Fs);
sim('Ex6_5', (N+Ntransient)/Fs, options);	% Starts Simulink simulation


%-------------------------------------------------------------------------%
%   Calculates SNR and PSD of the bit-stream and of the signal            %
%-------------------------------------------------------------------------%

w=hann(N);
f=Fin/Fs			% Normalized signal frequency
fB=N*(bw/Fs)		% Base-band frequency bins
yy2=zeros(1,N);
yy2=yout(2+Ntransient:1+N+Ntransient)';
y1_2=y1;
y2_2=y2;

ptot2=zeros(1,N);
[snr2,ptot2]=calcSNR(yy2(1:N),f,fB,w',N);
Rbit2=(snr2-1.76)/6.02;	% Equivalent resolution in bits

%-------------------------------------------------------------------------%
%                   Power of the Quantization Error                       %
%-------------------------------------------------------------------------%
%                                                                         %
%        Add to the noise a sine wave whose power is 1                    %
%        Estimate the spectrum and obtain the absolute                    %
%        value of the noise by normalization                              %
%                                                                         %
%-------------------------------------------------------------------------%

yy2=zeros(1,N);
yy2=yout1(2+Ntransient:1+N+Ntransient);
Time=[1:N]*Ts;
sine_ref=sqrt(2)*sin(finrad*Time);
yy2=yy2+sine_ref';
stot=((abs(fft((yy2(1:N)'.*w')))).^2);  	    
signal =sum(stot(nper-4:nper+4));
noise=sum(stot(1:N/2))-signal;
powerQ=noise/signal;


%-------------------------------------------------------------------------%
%                               Plots                                     %
%-------------------------------------------------------------------------%

figure(1);
clf;
plot(linspace(0,Fs/2,N/2), ptot(1:N/2), 'r');
hold on;
plot(linspace(0,Fs/2,N/2), ptot2(1:N/2), 'b');
grid on;
title('PSD of a 2nd-Order Sigma-Delta Modulator')
xlabel('Frequency [Hz]')
ylabel('PSD [dB]')
axis([0 Fs/2 -200 0]);

figure(2);
clf;
semilogx(linspace(0,Fs/2,N/2), ptot(1:N/2), 'r');
hold on;
semilogx(linspace(0,Fs/2,N/2), ptot2(1:N/2), 'b');
grid on;
title('PSD with Saturation in Both Integrators')
xlabel('Frequency [Hz]')
ylabel('PSD [dB]')
axis([0 Fs/2 -200 0]);
text_handle = text(floor(Fs/R),-15, sprintf('SNR = %4.1fdB @ OSR=%d\n',...
    snr,R));
text_handle = text(floor(Fs/R),-30, sprintf('Rbit = %2.2f bits @ OSR=%d\n',...
    Rbit,R));

s1=sprintf('   SNR(dB)=%1.3f',snr);
s2=sprintf('   Simulation time =%1.3f min',etime(clock,t0)/60);
disp(s1)
disp(s2)


figure(3);
clf;
plot(linspace(0,Fs/2,N/2), ptot(1:N/2), 'r');
hold on;
plot(linspace(0,Fs/2,N/2), ptot2(1:N/2), 'b');
title('PSD of a 2nd-Order Sigma-Delta Modulator (detail)')
xlabel('Frequency [Hz]')
ylabel('PSD [dB]')
axis([0 2*(Fs/R) -200 0]);
grid on;
hold off;
text_handle = text(floor(Fs/R),-20, sprintf('SNR = %4.1fdB @ OSR=%d\n',...
    snr,R));
text_handle = text(floor(Fs/R),-40, sprintf('Rbit = %2.2f bits @ OSR=%d\n',...
    Rbit,R));

s1=sprintf('   SNR(dB)=%1.3f',snr);
s2=sprintf('   Simulation time =%1.3f min',etime(clock,t0)/60);
disp(s1)
disp(s2)

%-------------------------------------------------------------------------%
%                   Histograms of the integrator outputs                  %
%-------------------------------------------------------------------------%

figure(4)
nbins=200;
[bin1,xx1_1]=hist(y1_1, nbins);
[bin2,xx2_1]=hist(y2_1, nbins);
[bin1,xx1_2]=hist(y1_2, nbins);
[bin2,xx2_2]=hist(y2_2, nbins);

clf;
subplot(2,2,1), 
plot(xx1_1, bin1, 'r');
grid on;
title('First Integrator Output')
xlabel('Voltage [V]')
ylabel('Occurrences')
subplot(2,2,3); 
plot(xx1_2, bin1, 'r');
grid on;
title('First Integrator Output')
xlabel('Voltage [V]')
ylabel('Occurrences')
subplot(2,2,2); 
plot(xx2_1, bin2, 'r')
grid on;
title('Second Integrator Output [B=1/2]')
xlabel('Voltage [V]')
ylabel('Occurrences')
subplot(2,2,4); 
plot(xx2_2, bin2, 'r')
grid on;
title('Second Integrator Output [B=2]')
xlabel('Voltage [V]')
ylabel('Occurrences')

figure(5)
subplot(2,1,1), plot(y1_1,'r');
axis([0 8000 -4 4])
title('First Integrator Output (with Saturation)')
ylabel('Amplitude')
grid
axis([0 8000 -1.5 1.5])
subplot(2,1,2), plot(y2_1);
Xlim([0 8000])
title('Second Integrator Output (with Saturation)')
ylabel('Amplitude')
grid
Delta=(VrefP-VrefN)/Ncomp
MaxY1=max(abs(y1))
MaxY2=max(abs(y2))
MaxOut=max(abs(yout))
pwnoise=powerQ                  % Noise power
ExcessNoise=powerQ/(Delta^2/12)
ExcessdB=10*log10(ExcessNoise)


