%function cropmov=correctionforcrop(j,nFrames,sampimage,rettempvar,testindices,oldrow,oldcol,windowsize)
function rect=correctionforcrop(j,rettempvar,testindices)
decis=1; 
cen=testindices(5);
close all
while(decis>0)
    imagesc(rettempvar{cen})
     rect=getrect;
     rect=ceil(rect);
     height=rect(4);width=rect(3);colst=rect(1);rowst=rect(2);
     
        for i=1:length(testindices)                         %select the area we interest
            ind=testindices(i);
            tempvar=rettempvar{ind};
            cropmov=tempvar(rowst:rowst+height,colst:colst+width);
            
            
            subplot(2,5,i)
            imagesc(cropmov)
            axis square
        end
        colormap gray
                    
        decis=input('enter 0 if satisfied');
        close
end
disp('end of while loop')
    
end

 