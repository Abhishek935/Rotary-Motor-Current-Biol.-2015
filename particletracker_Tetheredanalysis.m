%Analysis of motor spots using spatial bandpassing and particle tracking
%algorithm (brightness weighted centroid)- Pushkar Lele

% Relevant variables are Bri (motor brightness) and frame number fr
% clc
% clear all
% close all
function fd=particletracker_Tetheredanalysis(Ia,iL);

% Read files in
% name=input('Name you would like to give the saved work (e.g. files, use single quotations )');

% files = dir('*.tif'); 
no_frames = iL
OriD = cell(1, no_frames);
st=1;
%Select the approximate center of motor spot to crop your images 
for i = st:no_frames
    disp(['reading file ' num2str(i) '/' num2str(no_frames)])
    a = Ia{i};
    
    OriD{i}=a;
%     imagesc(a)
%     colormap('gray')
%     pause(0.4)
%     
end



% save FRAPdiff.mat
%%
%Confirmation module, only to verify parameter values
    figure(2)
    dispim=a;
    imagesc(dispim)
    colormap 'gray'
    pk=[];
    %  frameno=1;     % a=Inicrop{frameno};
      bp=7;%You can change this number to 5 if not satisfied, but it has to be an odd number
      b=bpass(a,1,bp);%Spatial bandpassing of image
      subplot(1,2,1), imagesc(b)
      axis square
      colormap gray
      title('Band passed image')
      
      subplot(1,2,2), hist(b(:),50)
      title('Histogram of pixel intensities, the threshold can be fixed to about 1/3rd the maximum intensity')
      
      while(length(pk)==0)
          hm=input('look at the histogram and input the threshold value')
          dp=9;pk = pkfnd(b,hm,dp);%finds the peaks with loose accuracy
      

          if length(pk)>0

              subplot(1,2,1),
              hold on
              plot(pk(:,1),pk(:,2),'r*')
              title('the red spot should be approximately near the center')
          end
      end
      
close all
nn=0;

% ================================================
% Actual peak finding, this applies to the whole data
pkcount=0;ccnt=1;pkit=0;DDp=0;
as=zeros(51,51);
for i=st:no_frames
   
    while(DDp==0 && nn<3)
            imm=OriD{i};
            b=bpass(imm,1,bp);
%             as(26-floor(length(b(1,:))/2):26+floor(length(b(1,:))/2),26-floor(length(b(1,:))/2):26+floor(length(b(1,:))/2))=b;
            BpassCrop{i}=b;%as;
%             hm=Hmi(i);
            if isempty(pk)
                hm=input('the cutoff value needs to be lower. Enter new value(suggested = 1/3rd previous value) ')
            end
            as=b;
            pk = pkfnd(as,hm,dp);
            cnt = cntrd(as,pk,dp,0,i);%sub pixel (nm) accurate tracking
            
            if ~isempty(cnt)
        
                Buffsave{ccnt}=[cnt(:,1) cnt(:,2) cnt(:,3) cnt(:,4) i]; 
                ccnt=ccnt+1;
               

%                     subplot(1,2,1), hist(b(:),100)
%                     subplot(1,2,2), imagesc(as)
%                     hold on
%                     subplot(1,2,2), plot(cnt(:,1),cnt(:,2),'*')
%                     colormap gray
%                     disp('analyzing frame no')
                    i
%                     DDp=input('Ddp, enter 1 if satisfied or 0 if not')'
%                     display('Previous cutoff value is')
%                     hm
%                     pause(0.5)
                    Ddp=1;nn=4;b=[];
            end        
            
            close all
          nn=nn+1;
    end
     DDp=0;nn=0;
end

%% ====================================================================
%Tracking
xI=0;yI=0;A=0;time=0;rad=0;
for i=1:ccnt-1
    rwv=Buffsave{i};xI=[xI;rwv(:,1)];yI=[yI;rwv(:,2)];
    A=[A;rwv(:,3)];rad=[rad;rwv(:,4)];time=[time;rwv(:,5)];
end
pos=[xI(2:end) yI(2:end) A(2:end) rad(2:end) time(2:end)];
fd=pos;
% pos=[TT(realpts,1) TT(realpts,2) TT(realpts,3) TT(realpts,4) TT(realpts,5)];
% vari=15;%this is the maximum spatial range over which your center can wobble, if it wobbles too much and goes beyond
%  this vari value, then the program will identify it as a new motor (number 2). For
%  wobbly motors, use vari>3 and <10. If there are more than one motors,
%  then make this value small, so that no other motor is incorrectly
%  identified as number 1.
% tr=track(pos,vari,1,{2});%40 is the minimum number of frames in which the motor must be detected, this way 
% you will reduce poor data sets where motors can't be identified over even
% 40 frames.
% display('total number of motors found')
% part=tr(end,end)
% idvec=tr(:,end);
% for i=1:part
%     H_L(i)=length(find(idvec==i));
% end
% [Jab,Maxid]=sort(H_L,'descend');
% ccc=1;
% for i=1:1
%     
%     ind=find(tr(:,end)==Maxid(i));ind=int32(ind);
%     
%     rad=tr(ind,4);Bri=tr(ind,3);fr=tr(ind,5);%Bri is the motor brightness, fr is frame numbers
%         
%     x1=tr(:,1);y1=tr(:,2);
%     
% end
% Bri=Bri;
% save([name '_work.mat'])
% close all
% fd=tr;
% end
% 
% 
% % [col row] = ginput(1);%This is where you select the center of motor
% % close all
% % 
% % % Crop dimensions
% % crop_dim=30; %You can make this bigger or smaller but 25-27 works quite well.
% % xo=round(crop_dim/2);yo=round(crop_dim/2);
% % Inicrop=cell(no_frames);
% % inic=1;
% % scrsz = get(0,'ScreenSize');
% % figure('OuterPosition',[1 scrsz(2) scrsz(3) scrsz(4)]);
% % 
% %  while(inic==1)
% %     if length(crop_dim)==0
% %         crop_dim=input('enter value for new crop dimension')
% %     end
% %     for i=st:no_frames
% %     %     i
% %         data=OriD{i};
% % 
% %         Inicrop{i}=double(data(round(row)-floor(crop_dim/2):round(row)+...
% %             floor(crop_dim/2),round(col)-floor(crop_dim/2):round(col)+...
% %             floor(crop_dim/2)));
% %         figure(1)
% %         subplot(round(no_frames/2),2,i), imagesc(Inicrop{i})
% %     colormap(gray); axis image; set(gca,'YTickLabel',[]);  
% %     set(gca,'XTick',floor(crop_dim/2):crop_dim:crop_dim*25);
% %     set(gca,'XTickLabel',{(i-1)*2+1:i*2}); 
% %     set(gca,'TickLength',[0 0]); 
% %         title(num2str(i))
% %     end
% %     inic=input('is the crop alright? (yes==0, no ==1 )')
% %     if inic==1
% %         crop_dim=[];
% %     end
% %     
% % end