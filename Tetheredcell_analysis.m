% Modified by Abhishek Shrivastava 
% This code was used in Shrivastava,
% Lele, Berg; Current Biology, Vol 25, Issue 3, 338-341 2015.
imagesc(rettempvar{20});%plots the first image for inspection. Change the number in the curly brackets to see a different frame
rect=getrect;
rect=ceil(rect);
height=rect(4);width=rect(3);colst=rect(1);rowst=rect(2);
brdr= max([height width]);%this variable will be used in anglecor_main for plotting shaeX,shaeY
nFrames=cctr-1;
tD=ceil(nFrames/10);
testindices=1:tD:tD*10;testindices=testindices+1;

      for i=1:length(testindices)                        %select the area ofe interest
        ind=testindices(i);
        tempvar=rettempvar{ind};
        cropmovtest=tempvar(rowst:rowst+height,colst:colst+width);
        %tempvar(row(j)-windowsizeR(j):row(j)+windowsizeR(j),col(j)-windowsizeC(j):col(j)+windowsizeC(j));%the area size is windowsize*windowsize
        subplot(2,5,i)
        imagesc(cropmovtest)
        axis square   
        tempvar=[];
      end
      
      
   
    rC=input('enter 0 if satisfied and 1 if not');
    if rC > 0
      
           rect=correctionforcrop(j,rettempvar,testindices);
           height=rect(4);width=rect(3);colst=rect(1);rowst=rect(2);
           
    end
      
 
 %Final decision on cropping for all the selected cells.
 
    for i=1:nFrames                         %select the area we interest
        tempvar=rettempvar{i};
        cropmov{i}=tempvar(rowst:rowst+height,colst:colst+width);
        %cropmov{i}=tempvar(row(j)-windowsizeR(j):row(j)+windowsizeR(j),col(j)-windowsizeC(j):col(j)+windowsizeC(j));%the area size is windowsize*windowsize
        tempvar=[];
    end
    rettempvar=[];

 
 %%
%-------------------------------------------------------------------
%  Threshold 
%-------------------------------------------------------------------           
    lev=0.8;             
    for i=1:length(testindices)                        
        ind=testindices(i);
        Thresholded_test=cropmov{ind};
        Thresholded_test=uint8(Thresholded_test);
        BW_test=im2bw(Thresholded_test,lev);
        subplot(2,5,i);
        imagesc(BW_test);
        axis square     
    end
    rD=input('enter 0 if satisfied and 1 if not');
    if rD>0
       lev=correctionforlev(cropmov,testindices);
    end       

close all
%%
counter=1;
    for i=1:nFrames
        Thresholded_image=cropmov{i};
        Thresholded_image=uint8(Thresholded_image);   
        BW=im2bw(Thresholded_image,lev);               %convert the image to binary
        
        
        %-------------------------------------------------------------------
        %  Find biggest closed curve, which is our cell
        %-------------------------------------------------------------------
        %linear fitting
        BaW=edge(BW);BB=bwboundaries(BaW,'noholes');
        lengthbound=length(BB);indBB=1;%the number of elllipses found
        if lengthbound<116 & lengthbound>0
                if lengthbound>1%length bound is number of ellipses found
                    for bound_i=1:lengthbound %Going through each ellipse one at a time
                        Sbound=BB{bound_i};Len_Sbound(bound_i)=length(Sbound);%Len_Sbound is a measure of the length of ellipse
                    end
                    [bak,indBB]=max(Len_Sbound);Len_Sbound=[];
                end
                Position_XY=[];
                Position_XY=BB{indBB};BB=[];%BB is a cell, each entry in the cell contains one ellipse xy values
 %-------------------------------------------------------------------
% %  troubleshooting
%                 figure(1)
%                 imagesc((BaW))
%                 axis equal
%                 %plot((Position_XY(:,2)),(Position_XY(:,1)))
%                 xlim([0 40])
%                 ylim([0 40])
%                 
%                 hold on
 %-------------------------------------------------------------------   
            fitEL=fit_ellipse(Position_XY(:,2),Position_XY(:,1));
%             input('')

 %This is where some points are excluded and others are not
            if length(fitEL)>0 & length(fitEL.phi)==1
%                 theta(counter)= fitEL.phi*180/pi;
                Pxy=fitEL.Pointoncurve1;Pxy2=fitEL.Pointoncurve2;% these are endpoints of ellipse
                Cell_L(counter)=fitEL.long_axis;%this is the whole length of cell (long axis)
                Cell_S(counter)=fitEL.short_axis;%this is the whole short axis length
                LongAxis_xy{counter}=[Pxy Pxy2];% 
                Xcenter(counter)=fitEL.X0_in;Ycenter(counter)=fitEL.Y0_in;     %This is the center of mass
                thresh_cell{counter}=BaW;		%save
                Framesretained(counter)=i;
                BaW=[];BW=[];
%                 xlabel(num2str(theta(counter)))
%                 ylabel(num2str(counter))
                counter=counter+1;
            else 
                
            end
        end
        close
    end
%     dlmwrite([filename '_celllength.txt'],Cell_L,'delimiter','\t')
    sfilename=[filename 'fine' '.mat'];
 save(sfilename)
% Cell_L=[];
% 
% psiwork(1)=theta(1);
% n=0;
% 
% for(i=1:(length(theta)-1))
%     delta=(theta(i+1)-theta(i));
%     
%     if (delta >90)        
%             n=n-1;
%     else if(delta<-90)
%             n=n+1;
%         end
%     end
%     
%     psiwork(i+1)=theta(i+1)+180*n;
%        
% end