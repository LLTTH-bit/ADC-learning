function y = dist(x,sec,third,fourth,fifth)

% function y = dist(x,sec,third,fourth,fifth)
% x input 
% sec,third,fourth,fifth distortion coefficients with input normalized 
%                        in the -1 +1 interval
% output is in the same interval as input

xspan=max(x)-min(x);
xmin=min(x);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                         normalization                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

xnorm=(x-xmin-xspan/2)*2/xspan;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                           distortion                                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

y=xnorm+sec*xnorm.*xnorm+third*(xnorm.*xnorm).*xnorm;
y=y+fourth*((xnorm.*xnorm).*xnorm).*xnorm+fifth*(((xnorm.*xnorm).*xnorm)...
    .*xnorm).*xnorm;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                         denormalization                                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ymax=max(y);
ymin=min(y);
y=(y-ymin)/(ymax-ymin)*xspan+xmin;
