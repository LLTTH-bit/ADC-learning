%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                              Example 6.4                                %
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
R=64;                   % Oversampling
Fs=R*2*bw;				% Oversampling frequency
Ts=1/Fs;
N=1024*8;				% Samples number
nper=13;
Fin=nper*Fs/N;			% Input signal frequency (Fin = nper*Fs/N)
finrad=Fin*2*pi;		% Input signal frequency in radians
Amp_dB=-2.4;            % Input amblitude in dB

Ampl=10^(Amp_dB/20);%-pi/2048;
Ntransient=100;

VrefN=-1;
VrefP=1;
Ncomp=7;
Delta=(VrefP-VrefN)/Ncomp


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
%-------------------------------------------------------------------------%
%                          Switches quantizer                             %
%-------------------------------------------------------------------------%

SatQuant=0;             % if 0 no saturation if 1 saturation
QuantSat=0;             % Quantizer saturation amplitude
MultiBit=1;             % if 0 1-bit if 1 multi-bit
if MultiBit==0
    Ncomp=1;
end



%-------------------------------------------------------------------------%
%                 Switches --> IDEAL INTEGRATORS                          %
%-------------------------------------------------------------------------%

SatFirst=0;             % if 0 no saturation if 1 saturation
SatSecond=0;            % if 0 no saturation if 1 saturation
Vsat1=1.0;              % hard saturation of the first integrator
Vsat2=1.0;              % hard saturation of the second integrator


%-------------------------------------------------------------------------%
%                       Open Simulink diagram first                       %
%-------------------------------------------------------------------------%

options=simset('RelTol', 1e-3, 'MaxStep', 1/Fs);
sim('Ex6_4', (N+Ntransient)/Fs, options);	% Starts Simulink simulation


%-------------------------------------------------------------------------%
%   Calculates SNR and PSD of the bit-stream and of the signal            %
%-------------------------------------------------------------------------%

w=hann(N);
f=Fin/Fs                        % Normalized signal frequency
fB=N*(bw/Fs)                    % Base-band frequency bins
yy1=zeros(1,N);
yy1=yout(2+Ntransient:1+N+Ntransient)';
y1_ideal=y1;
y2_ideal=y2;

ptot1=zeros(1,N);
[snr1,ptot1]=calcSNR(yy1(1:N),f,fB,w',N);
Rbit1=(snr1-1.76)/6.02;         % Equivalent resolution in bits

%-------------------------------------------------------------------------%
%                 Switches --> SATURATION OF 1st INTEGRATOR               %
%-------------------------------------------------------------------------%

SatFirst=1;             % if 0 no saturation if 1 saturation
SatSecond=0;            % if 0 no saturation if 1 saturation
Vsat1=1.85;              % hard saturation of the first integrator
Vsat2=1.0;              % hard saturation of the second integrator

%-------------------------------------------------------------------------%
%                       Open Simulink diagram first                       %
%-------------------------------------------------------------------------%

options=simset('RelTol', 1e-3, 'MaxStep', 1/Fs);
sim('Ex6_4', (N+Ntransient)/Fs, options);	% Starts Simulink simulation

%-------------------------------------------------------------------------%
%   Calculates SNR and PSD of the bit-stream and of the signal            %
%-------------------------------------------------------------------------%

w=hann(N);
f=Fin/Fs                        % Normalized signal frequency
fB=N*(bw/Fs)                    % Base-band frequency bins
yy2=zeros(1,N);
yy2=yout(2+Ntransient:1+N+Ntransient)';
y1_sat1=y1;
y2_sat1=y2;


ptot2=zeros(1,N);
[snr2,ptot2]=calcSNR(yy2(1:N),f,fB,w',N);
Rbit2=(snr2-1.76)/6.02;         % Equivalent resolution in bits


%-------------------------------------------------------------------------%
%                 Switches --> SATURATION AT 2nd INTEGRATOR               %
%-------------------------------------------------------------------------%

SatFirst=0;             % if 0 no saturation if 1 saturation
SatSecond=1;            % if 0 no saturation if 1 saturation
Vsat1=1.0;                % hard saturation of the first integrator
Vsat2=2.5;              % hard saturation of the second integrator


%-------------------------------------------------------------------------%
%                       Open Simulink diagram first                       %
%-------------------------------------------------------------------------%

options=simset('RelTol', 1e-3, 'MaxStep', 1/Fs);
sim('Ex6_4', (N+Ntransient)/Fs, options);	% Starts Simulink simulation

%-------------------------------------------------------------------------%
%   Calculates SNR and PSD of the bit-stream and of the signal            %
%-------------------------------------------------------------------------%

w=hann(N);
f=Fin/Fs                        % Normalized signal frequency
fB=N*(bw/Fs)                    % Base-band frequency bins
yy3=zeros(1,N);
yy3=yout(2+Ntransient:1+N+Ntransient)';
y1_sat2=y1;
y2_sat2=y2;

ptot3=zeros(1,N);
[snr3,ptot3]=calcSNR(yy3(1:N),f,fB,w',N);
Rbit3=(snr3-1.76)/6.02;         % Equivalent resolution in bits

%-------------------------------------------------------------------------%
%                 Switches --> SATURATION IN BOTH INTEGRATORS             %
%-------------------------------------------------------------------------%

SatFirst=1;             % if 0 no saturation if 1 saturation
SatSecond=1;            % if 0 no saturation if 1 saturation
Vsat1=1.85;             % hard saturation of the first integrator
Vsat2=2.5;              % hard saturation of the second integrator

%-------------------------------------------------------------------------%
%                       Open Simulink diagram first                       %
%-------------------------------------------------------------------------%

options=simset('RelTol', 1e-3, 'MaxStep', 1/Fs);
sim('Ex6_4', (N+Ntransient)/Fs, options);	% Starts Simulink simulation

%-------------------------------------------------------------------------%
%   Calculates SNR and PSD of the bit-stream and of the signal            %
%-------------------------------------------------------------------------%

w=hann(N);
f=Fin/Fs                        % Normalized signal frequency
fB=N*(bw/Fs)                    % Base-band frequency bins
yy4=zeros(1,N);
yy4=yout(2+Ntransient:1+N+Ntransient)';
y1_sat=y1;
y2_sat=y2;

ptot4=zeros(1,N);
[snr4,ptot4]=calcSNR(yy4(1:N),f,fB,w',N);
Rbit4=(snr4-1.76)/6.02;         % Equivalent resolution in bits

%-------------------------------------------------------------------------%
%                   Power of the Quantization Error                       %
%-------------------------------------------------------------------------%
%                                                                         %
%        Add to the noise a sine wave whose power is 1                    %
%        Estimate the spectrum and obtain the absolute                    %
%        value of the noise by normalization                              %
%                                                                         %
%-------------------------------------------------------------------------%

yy5=zeros(1,N);
yy5=yout1(2+Ntransient:1+N+Ntransient);
Time=[1:N]*Ts;
sine_ref=sqrt(2)*sin(finrad*Time);
yy5=yy5+sine_ref';
stot=((abs(fft((yy5(1:N)'.*w')))).^2);  	    
signal =sum(stot(nper-4:nper+4));
noise=sum(stot(1:N/2))-signal;
powerQ=noise/signal;


%-------------------------------------------------------------------------%
%                               Plots                                     %
%-------------------------------------------------------------------------%

figure(1)
y1=y1_ideal;
y2=y2_ideal;
subplot(2,1,1), plot(y1,'r')
title('\bfFirst Integrator Output (with Saturation)')
ylabel('Amplitude')
grid
axis([0 8000 min(y1)-1 max(y1)+1]);
text_handle = text(2000, max(y1), sprintf('\\bfpeak value= %1.2fV @ In=%1.0fdB\n',...
    max(abs(y1)), Amp_dB));

subplot(2,1,2), plot(y2,'b')
axis([0 8000 min(y2)-1 max(y2)+1]);
title('\bfSecond Integrator Output (with Saturation)')
ylabel('Amplitude')
grid
text_handle = text(2000, max(y2), sprintf('\\bfpeak value= %1.2fV @ In=%1.0fdB\n',...
    max(abs(y2)), Amp_dB));

figure(2);
clf;
subplot(2,2,1)
semilogx(linspace(0,Fs/2,N/2), ptot1(1:N/2), 'r');
grid on;
title('\bfPSD with ideal integrators')
xlabel('Frequency [Hz]')
ylabel('PSD [dB]')
axis([0 Fs/2 -150 0]);
text_handle = text(floor(Fs/R),-15, sprintf('\\bfSNR = %4.1fdB @ OSR=%d\n',...
    snr1, R));
text_handle = text(floor(Fs/R),-30, sprintf('\\bfRbit = %2.2f bits @ OSR=%d\n',...
    Rbit1, R));

subplot(2,2,2)
semilogx(linspace(0,Fs/2,N/2), ptot2(1:N/2), 'r');
grid on;
title('\bfPSD with saturation at the 1^s^t integrator')
xlabel('Frequency [Hz]')
ylabel('PSD [dB]')
axis([0 Fs/2 -150 0]);
text_handle = text(floor(Fs/R),-15, sprintf('\\bfSNR = %4.1fdB @ OSR=%d\n',...
    snr2, R));
text_handle = text(floor(Fs/R),-30, sprintf('\\bfRbit = %2.2f bits @ OSR=%d\n',...
    Rbit2, R));

subplot(2,2,3)
semilogx(linspace(0,Fs/2,N/2), ptot3(1:N/2), 'r');
grid on;
title('\bfPSD with saturation in 2^n^d integrator')
xlabel('Frequency [Hz]')
ylabel('PSD [dB]')
axis([0 Fs/2 -150 0]);
text_handle = text(floor(Fs/R),-15, sprintf('\\bfSNR = %4.1fdB @ OSR=%d\n',...
    snr3, R));
text_handle = text(floor(Fs/R),-30, sprintf('\\bfRbit = %2.2f bits @ OSR=%d\n',...
    Rbit3, R));

subplot(2,2,4)
semilogx(linspace(0,Fs/2,N/2), ptot4(1:N/2), 'r');
grid on;
title('\bfPSD with saturation in both integrators')
xlabel('Frequency [Hz]')
ylabel('PSD [dB]')
axis([0 Fs/2 -150 0]);
text_handle = text(floor(Fs/R),-15, sprintf('\\bfSNR = %4.1fdB @ OSR=%d\n',...
    snr4, R));
text_handle = text(floor(Fs/R),-30, sprintf('\\bfRbit = %2.2f bits @ OSR=%d\n',...
    Rbit4, R));

s1=sprintf('   SNR(dB)=%1.3f',snr4);
s2=sprintf('   Simulation time =%1.3f min',etime(clock,t0)/60);
disp(s1)
disp(s2)

%-------------------------------------------------------------------------%
%                   Histograms of the integrator outputs                  %
%-------------------------------------------------------------------------%

figure(5)
nbins=200;
[bin1,xx1]=hist(y1, nbins);
[bin2,xx2]=hist(y2, nbins);
clf;
subplot(1,2,1), plot(xx1, bin1)
grid on;
title('\bfFirst Integrator Output')
xlabel('Voltage [V]')
ylabel('Occurrences')
Xlim([-1.5 1.5]);
subplot(1,2,2), plot(xx2, bin2)
grid on;
title('\bfSecond Integrator Output')
xlabel('Voltage [V]')
ylabel('Occurrences')
Xlim([-1.5 1.5]);

Delta=(VrefP-VrefN)/Ncomp
MaxY1=max(abs(y1))
MaxY2=max(abs(y2))
MaxOut=max(abs(yout))
pwnoise=powerQ                  % Noise power
ExcessNoise=powerQ/(Delta^2/12)
ExcessdB=10*log10(ExcessNoise)


