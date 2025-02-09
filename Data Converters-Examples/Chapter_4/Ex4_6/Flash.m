function [out,comp]=Flash(xin,x)
ncomp=max(size(x));
for i=1:ncomp
    if x(i)<=xin;
        comp(i)=1;
    else comp(i)=0;
    end
end
out=sum(comp);
    
        

 