%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                              Example 3.1                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
%                            Kelvin Divider                               %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;

N=2^12;                         % The input sequence is made by 2^12 points
Nbit=8;                         % 8-bit DAC
Ntransient=11;         
Ntot=N+Ntransient;
nper=311;                       % prime integer number of sine waveforms
Fs=1;
bw=0.5;
Fin=nper*Fs/N;                  % Input signal frequency (Fin=nper*Fs/N)
Vref=0.5;                       % Full scale for an input sinewave
Amp_dB=-0;                      % Amplitude in dB
Ampl=10^(Amp_dB/20)*Vref;       % Input signal amplitude

finrad=Fin*2*pi;
alphadx=0.0001;                 % gradient in the resistivity
den=2^Nbit-1+alphadx*2^Nbit*(2^Nbit-1)/2;

for i=1:Ntot,
    x=Vref*sin(finrad*(i-1))+Vref;      % Unipolar range
    k=round(x*2^Nbit);
    vout=(k+alphadx*k*(k+1)/2)/den;
    y(i)=vout;
end

y=y-mean(y);                            % Output with zero average

%--------------------------------Graphics---------------------------------%
%                                                                         %
%     figure(1) --> Sine wave with distortion                             %
%     figure(2) --> Figure 3.12 page 93                                   %
%                                                                         %
%-------------------------------------------------------------------------%


figure(1);
clf;
plot(y,'r');
grid;
xlim([1600 1900]);
title('Sinewave with distortion');

w=ones(1,N);
f=Fin/Fs;                               % Normalized signal frequency
fB=N*(bw/Fs);                           % Base-band frequency bins
[snr,ptot]=calcSNR(y(1:N),f,fB,w,N);
ptot=ptot-max(ptot);                    % Normalize total spectrum

figure(2);
clf;
plot(linspace(0,Fs/2,N/2), ptot(1:N/2), 'r');
grid on;
title('PSD of the Output')
xlabel('Frequency [Hz]')
ylabel('PSD [dB]')
axis([0 Fs/4 -120 0]);
text(Fs/10,-20,sprintf('\\bfSNR = %3.1fdB  @  \\alpha\\DeltaX = %1.0e\n'...
    ,snr,alphadx),'Fontsize',12);
text(f*2,ptot((f*N+1)*2-1)+3,sprintf('\\bf%2.1fdB',ptot((f*N+1)*2-1)),...
    'Fontsize',8,'HorizontalAlignment','center');

