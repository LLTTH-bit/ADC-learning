%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                              Example 3.7                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
%                         Binary Weighted Architecture                    %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all

%-------------------------------------------------------------------------%
%                                                                         %
%                                Input data                               %
%                                                                         %
%-------------------------------------------------------------------------%

n=12;
errandom=0.006;
points=2^n;
in=[1:1:points];

for k=1:points-2;
    bin=dec2bin(in(k),n);
    nextbin=dec2bin(in(k+1),n);
    switched=abs(bin-nextbin);
    swit=num2str(switched);
    sw=bin2dec(swit);
DNL(k+1)=errandom*(sqrt((sw-1)/2)+sqrt((sw-1)/2));
end

%--------------------------------Graphic----------------------------------%
%                                                                         %
%     figure(1) --> Figure 3.40 page 126                                  %
%                                                                         %
%-------------------------------------------------------------------------%

figure(1);
DNL(1)=0;
plot(DNL)
title('Integral Nonlinearity')
xlabel('bin')
ylabel('INL')
grid
xlim([0 2^n])

j=1;
a=(DNL>0.15);
b=zeros(1,sum(a));
for i=1:1:length(a)
    if a(i)==1
        b(j)=i;
        j=j+1;
    end
end

for i=1:1:length(b)
text(b(i),DNL(b(i)), sprintf('\\bf%3d',(b(i))),...
    'Fontsize',8,'HorizontalAlignment','center');
end
