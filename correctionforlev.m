function lev=correctionforlev(D,testindices)
decis=0; 
close all
while(decis<1)
     lev=input('Please enter threshold level'); 
     cnt=1;figct=1;
     for i=1:length(testindices) 
         if i==6
             figct=2;
             cnt=1;
         end
         ind=testindices(i);
         Thresholded_test=D{ind};
         Thresholded_test=uint8(Thresholded_test);
         BW_test=im2bw(Thresholded_test,lev);
         figure(figct)
         subplot(2,5,cnt)
         imagesc(BW_test)
         axis square
         subplot(2,5,cnt+5)
         imagesc(Thresholded_test)
         axis square        
         cnt=cnt+1
     end
     
     decis=input('enter 1 if satisfied');
     close
     
end
disp('end of while loop')
    
end

 