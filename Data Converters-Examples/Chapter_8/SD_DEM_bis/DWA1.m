function out=DWA1(index,value,Nelements)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%          DWA ALGORITHM                                                %%
%%    index =>starting location of the thermometric code                 %%              
%%    value =>number of 1s to be converted                               %%
%%    Nelements => number of unary elemnts in the circle                 %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

a=index+value;
b=a-Nelements;

    if b>0                          
        x(1:b)=1;
        x(b+1:index)=0;
        x(index+1:Nelements)=1;
        i=b;
    else
        x(1:index)=0;
        x(index+1:a)=1;
        x(a+1:Nelements)=0;
        i=a;
    end

y=[i x];
out=y;