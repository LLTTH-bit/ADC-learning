function out=butterfly(termo,Nelements)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                                       %%
%%                     BUTTERFLY ALGORITHM                               %%
%%          termo ==> # of ones in the termometric code                  %%
%%          Nelements ==> length of the termometric code                 %%
%%          out    ==> termometric code after butterfly algorithm        %%
%%                                                                       %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

term=[ones(1,termo) zeros(1,Nelements-termo)];  % input term representation
Nswitches=log2(Nelements);                      % # of switches 
random=round(rand(1,Nswitches));                % ctrl signals of switches

for j=1:1:Nswitches
    a=ones(Nelements/2^j,Nelements/2^(Nswitches-j));
    k=1;
        for i=1:1:Nelements/2^(Nswitches-j)
            a(:,i)=term(k:k+Nelements/2^j-1);
            k=k+Nelements/2^j;
        end
            if random(j)==1
                z=1;
                for y=2:2:Nelements/2^(Nswitches-j)
                    term(z:z+Nelements/2^(j-1)-1)=[a(:,y)' a(:,y-1)'];
                    z=z+Nelements/2^(j-1);
                end
            end   
end
out=term;