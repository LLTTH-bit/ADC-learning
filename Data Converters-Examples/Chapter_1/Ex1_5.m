%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                              Example 1.5                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;            

%-------------------------------------------------------------------------%
%                                                                         %
%                           Simulation parameters                         %
%                                                                         %
%-------------------------------------------------------------------------%

points=2^10;            % The number of points used in the simulation 
S=64;                   % sampling period
t=[1:points];           % clock-times used in the simulation
N=2^6;                  % number of points used in the flattop function
w = flattopwin(N);
tw=[0:N-1];
tw=tw*points/(N-1);
y=interp1(tw,w,t)  ;    % interpolation of w

%--------------------------------Graphics---------------------------------%
%                                                                         %
%    figure(1) --> Fig 1.29(a) page 37                                    %
%    figure(2) --> Fig 1.29(b) page 37                                    %
%    figure(3) --> Fig 1.30(a) page 38                                    %
%    figure(4) --> Fig 1.30(b) page 38                                    %
%                                                                         %
%-------------------------------------------------------------------------%

figure(1);
plot(y)
title('Input Signal in the Time-domain')
axis([1 points -0.2 1.2]);
grid on
sp=abs(fft(y));         % spectrum of the input

figure(2);
plot(sp(1:64));
title('Spectrum of the Input')
grid on;
xlim([1 64]);

% SAMPLING
index=1;
b=S;
for i=1:points
    if i<b
        ysamp(i)=0;
    end
    if i==b
        ysamp(i)=y(index)*S;
        b=b+S;
        index=index+S;
    end
end
% SAMPLING AND HOLD
index=1;
b=S;
for i=1:points
    if i<=b
        ys_h(i)=y(index)*S;
    end
    if i==b
        ys_h(i)=y(index)*S;
        b=b+S;
        index=index+S;
    end
end

figure(3);
sp_s=abs(fft(ysamp));     % spectrum of the sampled signal
plot(sp_s(1:64));
title('Spectrum of the Sampled Signal')
grid on;
xlim([1 64]);

figure(4);
spH=abs(fft(ys_h));     % spectrum of the sampled-and-holded signal
plot(spH(1:64));
title('Spectrum of the Sampled-and-Holded Signal')
grid on;
xlim([1 64]);
