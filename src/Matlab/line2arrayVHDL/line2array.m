busWidth=8;
patchWH=3;

conversion=zeros(2,9);

for i=0:patchWH-1
    for j=0:patchWH-1
        %Ust Sinir
        conversion(1,1+i*patchWH+j)=j*(busWidth)+i*(busWidth*patchWH)+(busWidth-1);
        %Alt Sinir
        conversion(2,1+i*patchWH+j)=j*(busWidth)+i*(busWidth*patchWH);
    end
end