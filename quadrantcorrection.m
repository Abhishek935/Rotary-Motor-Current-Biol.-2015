%This function corrects for quadrant errors in angles
function fintheta=quadrantcorrection(x,xc,y,yc,~,PointsEllip,stp)
no_rot=0;
    for i=1:length(x)
                   LP=PointsEllip{stp};
%     =======================================
% Troubleshooting
%                     figure(2)
%                     BaW=thresh_cell{stp};
%                     imagesc((BaW))
%                     colormap gray
%                     hold on
%                     plot(xc,yc,'y*')
%                     plot(x(i),y(i),'g*')
%                     plot(LP(1,1),LP(2,1),'m*')
%                     
%                     BaW=[];
%     ======================================

          if (x(i)-xc > 0 & y(i)-yc >=0)  
              Xp=max(LP(1,1),LP(1,2));Yp=max(LP(2,1),LP(2,2));
              thetagen(i)=atan( (Yp-y(i))/ (Xp-x(i)) )*180/pi;
              thetawork(i)=thetagen(i);
          end
             
          if (x(i)-xc < 0 & y(i)-yc >=0)  
              Xp=min(LP(1,1),LP(1,2));Yp=max(LP(2,1),LP(2,2));
               thetagen(i)=atan( (Yp-y(i))/ (Xp-x(i)) )*180/pi;
               thetawork(i)=thetagen(i)+180;
          end 
              
          if (x(i)-xc < 0 & y(i)-yc <0)  
              Xp=min(LP(1,1),LP(1,2));Yp=min(LP(2,1),LP(2,2));
               thetagen(i)=atan( (Yp-y(i))/ (Xp-x(i)) )*180/pi;
               thetawork(i)=thetagen(i)+180;
          end 
          
          if (x(i)-xc > 0 & y(i)-yc <0)  
              Xp=max(LP(1,1),LP(1,2));Yp=min(LP(2,1),LP(2,2));
               thetagen(i)=atan( (Yp-y(i))/ (Xp-x(i)) )*180/pi;
               thetawork(i)=thetagen(i)+360;
          end 

%           
% %               thetawork(i)=180/pi*atan();%First quandrant
%     =======================================
% Troubleshooting
%           plot(Xp,Yp,'m*')
%     
%           xlabel(num2str(thetawork(i)))
%           ylabel(num2str(thetagen(i)))
%           
%          input('')
%     =======================================
            stp=stp+1;
    end
    fintheta=thetawork;
%     
% fintheta(1)=thetawork(1);
% for i=1:length(thetagen)-1
%     
%       delta=thetawork(i+1)-fintheta(i);
%       if (delta)>90
%           fintheta(i+1)=thetawork(i+1)-180;
%       end
%       if delta <-90
%           fintheta(i+1)=thetawork(i+1)+360;
%       end
%       if abs(delta) < 90
%           fintheta(i+1)=thetawork(i+1);
%       end
%       ylabel(num2str(fintheta(i)))
%       input('')
% end    
% end
