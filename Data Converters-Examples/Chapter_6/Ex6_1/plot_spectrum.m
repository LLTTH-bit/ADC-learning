function plot_spectrum(points,freq,out)

%-------------------------------------------------------------------------%
%                               Spectrum                                  %
%-------------------------------------------------------------------------%

w=hann(points);
%w=[1:points];
f=freq;			            % Normalized signal frequency
fB=points/2;     		    % Base-band frequency bins
N=points;
vout=zeros(1,N);
vout=out;                    %-mean(out);
Vref=1;
xx=vout(1:N);
fB=ceil(fB);
stot=((abs(fft((xx.*w)')')).^2);        % Bit-stream PSD
pwtot=sum(stot(1:fB));                  % Signal power

%-------------------------------------------------------------------------%
%                           Reference Sine Wave                           %
%-------------------------------------------------------------------------%

time=[1:points];
xref=1/2^0.5*sin(2*pi*7/points*time);
sref=((abs(fft((xref.*w')'))).^2);	   % Bit-stream reference
norm=sum(sref(1:fB));                  % Signal power

	ptot=stot/norm;
	ptotdB=dbp(ptot);

    power=pwtot/norm;
    voltspect=sqrt(power)/fB;

%-------------------------------------------------------------------------%
%                                 Plot                                    %
%-------------------------------------------------------------------------%

plot(ptotdB(1:N/2), 'r');
grid on

%text(N/4, -30, sprintf('P_{tot} = %5.2e W',power));
text(N/16, -30, sprintf('\\bfaverage white noise floor = %5.2e  V/sqrt(Hz)',...
    voltspect));