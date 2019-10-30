% Angle correction main program: Abhishek Shrivastava
% This code was used in Shrivastava,
% Lele, Berg; Current Biology, Vol 25, Issue 3, 338-341 2015.
clc
disp('counter')
% counter=2000;
close all
stepsize=floor(counter/5); % Modified to work only for short movies
remainder_ana=mod(counter-1,stepsize);%
% Error1
%Reminder. If you get unknown errors, display floor(counter-1)/stepsize
% That value should be an integer and greater than 1
% if it is <1, or very small (2 or 3), then your thresholding or cropping
% is not good. Rerun Tetherecell_analysis
Je=0;
Freq=fps;
ctr=1;centersave=1;

% Error 2
% If you see a blank window when you should be seeing a circle of data, most likely
% the error has to do with the brdr value below. Change it (make it larger, 50, or 70, 100 but no more
% than 200)
brdr=200;%instructs matlab where to plot the circles
correctedtheta=0;cumang=0;
XXc=0;YYc=0;
for i=1:floor(counter-1)/stepsize%edited out by Pushkar , 12/2/2014
    'bol'
    stp= (i-1)*stepsize+1:(i)*stepsize ;
    disp('stp')
    stp(1);
    shaeX=Xcenter(stp);shaeY=Ycenter(stp) ;
    DumshaeX=shaeX;DumshaeY=shaeY;
    DSX=find(abs(DumshaeX)>brdr);DumshaeX(DSX)=[];DumshaeY(DSX)=[];
    DSY=find(abs(DumshaeY)>brdr);DumshaeY(DSY)=[];DumshaeX(DSY)=[];
    shaeX_C=shaeX;shaeY_C=shaeY;
    plot(DumshaeX,DumshaeY,'r.-')
%     pause(1)
%     xlim([-100 60])
%     ylim([-10 88])
%     xlim([min(shaeX) max(shaeX)])
%     ylim([min(shaeY) max(shaeY)])
    axis('equal')
%    =============================================================
% Uncomment this when cell-tracking is suspect
%    =============================================================
    pause(0.35)
    rectC=getrect
    height=rectC(4);width=rectC(3);colst=rectC(1);rowst=rectC(2);
%    =============================================================
% If above is in practice, uncomment below
%    =============================================================
% height=max(shaeY)-min(shaeY);width=max(shaeX)-min(shaeX);colst=min(shaeX);rowst=min(shaeY);
    %    =============================================================
    
    Xid=find(shaeX_C<colst | shaeX_C>colst+width);shaeX_C(Xid)=[];shaeY_C(Xid)=[];
    Yid=find(shaeY_C<rowst | shaeY_C>rowst+height);shaeY_C(Yid)=[];shaeX_C(Yid)=[];
    plot(shaeX_C,shaeY_C,'r.-')
%     [xc,yc,R] = circfit(shaeX_C,shaeY_C);
    [Penum] = CircleFitByPratt([shaeX_C' shaeY_C']);xc=Penum(1);yc=Penum(2);R=Penum(3);
    xcenter(centersave)=xc;ycenter(centersave)=yc;%this is where ellipse center is saved
    Radius(ctr)=R;R=[];
    hold on
    plot(xc,yc,'b*')
    XXc=[XXc shaeX_C];YYc=[YYc shaeY_C];%XXc I believe are just the COM coordinates
    pause(1)
    figure(2)
     fintheta=quadrantcorrection(shaeX,xc,shaeY,yc,thresh_cell,LongAxis_xy,stp(1));shaeX=[];shaeY=[];
     close
     
     correctedtheta=[correctedtheta fintheta];fintheta=[];
     correctedtheta
    xc=[];yc=[];
   close
   ctr=ctr+1;centersave=centersave+1;
end
 CUMX=[XXc' YYc'];
    %CR_x(i)=xc;CR_y(i)=yc;
%     xc=[];yc=[];
% end
%% if you don't want to track the remaining few points , deactivate the following:
% stp= i*stepsize+1:i*stepsize+remainder_ana;
% shaeX=Xcenter(stp );shaeY=Ycenter(stp ) ;
% DumshaeX=shaeX;DumshaeY=shaeY;
%     DSX=find(abs(DumshaeX)>brdr);DumshaeX(DSX)=[];DumshaeY(DSX)=[];
%     DSY=find(abs(DumshaeY)>brdr);DumshaeY(DSY)=[];DumshaeX(DSY)=[];
%     if length(DumshaeX) > 5
%     plot(DumshaeX,DumshaeY,'r.-')
% shaeX_C=shaeX;shaeY_C=shaeY;
% %     xlim([min(shaeX) max(shaeX)])
% %     ylim([min(shaeY) max(shaeY)])
% %  xlim([ 0 75])
% %     ylim([0 75])
% %     axis('equal')
%     %    =============================================================
% % Uncomment this when cell-tracking is suspect
% %    =============================================================
%     pause(1)
%     rectC=getrect % added ; at the end
%     height=rectC(2);width=rectC(2);colst=rectC(1);rowst=rectC(2); % old rectC4 old width 3
% %    =============================================================
% % If above is in practice, uncomment below
% %    =============================================================
% % height=max(shaeY)-min(shaeY);width=max(shaeX)-min(shaeX);colst=min(shaeX);rowst=min(shaeY);
%     %    =============================================================
%     DumshaeX=[];DumshaeY=[];
%     
%     Xid=find(shaeX_C<colst | shaeX_C>colst+width);shaeX_C(Xid)=[];shaeY_C(Xid)=[];
%     Yid=find(shaeY_C<rowst | shaeY_C>rowst+height);shaeY_C(Yid)=[];shaeX_C(Yid)=[];
%     plot(shaeX_C,shaeY_C,'r.-')
% %     [xc,yc,R] = circfit(shaeX_C,shaeY_C)
%     [Penum] = CircleFitByPratt([shaeX_C' shaeY_C']);xc=Penum(1);yc=Penum(2);R=Penum(3);
%     Radius(ctr)=R;R=[];
%     hold on
%     plot(xc,yc,'b*')
%     
%         figure
% 
%     fintheta=quadrantcorrection(shaeX,xc,shaeY,yc,thresh_cell,LongAxis_xy,stp(1));shaeX=[];shaeY=[];
%     
%     correctedtheta=[correctedtheta fintheta];
%     end
% ========================Till here (for last remaiing points)
    display('length of angles')
    correctedtheta(1)=[];
    rem360=find(correctedtheta==360);correctedtheta(rem360)=[];Framesretained(rem360)=[];
    %%
    cumang=B1analysis(correctedtheta);
    length(cumang)
    close
    w=(cumang(2:end)-cumang(1:end-1));
    Sw=find(abs(w)>250);w(Sw)=[];Framesretained(Sw)=[];
    w=w/360*Freq;
    i=i+1;
    Dc=[xcenter' ycenter'];
%    dlmwrite([filename '.txt'],w','delimiter','\t')
   dlmwrite([filename '_0angle.txt'],cumang','delimiter','\t')
    dlmwrite([filename '_0XY.txt'],CUMX,'delimiter','\t')
   dlmwrite([filename '_longaxis.txt'],Cell_L','delimiter','\t')
   dlmwrite([filename '_shortaxis.txt'],Cell_S','delimiter','\t')
   dlmwrite([filename '_center.txt'],Dc,'delimiter','\t')
   dlmwrite([filename '_speed.txt'],w,'delimiter','\t')

   dlmwrite([filename '_radii.txt'],Radius,'delimiter','\t')
   finale=[filename 'finalsave.mat']
   save(finale)

Je=[];remainder_ana=[];thresh_cell=[];LongAxis_xy=[];rettempvar=[];Radius=[];fintheta=[];
Xcenter=[];Ycenter=[];Xid=[];Yid=[];
shaeX=[];shaeY=[];Framesretained=[];cumang=[];correctedtheta=[];
close all