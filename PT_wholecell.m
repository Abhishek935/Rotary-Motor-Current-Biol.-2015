%Use this code to analyze diffusing motor spots in whole cells. Coded -
%12/5/2014 , Pushkar Lele
%NEED TO ADD CROPPING ROUTINE

%% Cell1 - Abhishek, this is a cell indicated b y the two percentage sign. Bring your text pointer anywhere below this line and hit ctrl-enter to run each
% cell at a time
clear all
clc
%-------------------------------------------------------------------
%load movie
%-------------------------------------------------------------------
filename=input('movie name?, type in the entire name e.g. A. avi"')

    xyloObj = VideoReader(filename);             %imput the video
    nFrames = xyloObj.NumberOfFrames;           % No of frames
    fps=xyloObj.FrameRate;
     A=read(xyloObj,4); tempvar =  rgb2gray(A) ;
    [maxrow,maxcol]=size(A);
    cctr=1;bp=7;%You can change this number to 5 if not satisfied, but it has to be an odd number

    for i=1:nFrames
     A=read(xyloObj,i); tempvar =  rgb2gray(A) ;
  %     ---------------------------------------------
            im=flipud(tempvar);
            rettempvar{cctr}=im;tempvar=[];
            cctr=cctr+1;
    end
    
no_frames=50%nFrames;
OriD = cell(1, nFrames);
st=1;
%% Cell2 - Abhishek, this is a cell indicated b y the two percentage sign. Bring your text pointer anywhere below this line and hit ctrl-enter to run each
% cell at a time
im=[];height=[];width=[];colst=[];rowst=[];cropmovtest=[];b=[];
im=rettempvar{3};
imagesc(im);
rect=getrect;
rect=ceil(rect);
height=rect(4);width=rect(3);colst=rect(1);rowst=rect(2);
cropmovtest=im(rowst:rowst+height,colst:colst+width);
im=cropmovtest;
      b=bpass(im,1,bp);%Spatial bandpassing of image
      subplot(1,2,1), imagesc(b)
      axis square
      colormap gray
      title('Band passed image')
      
      subplot(1,2,2), hist(b(:),50)
      xlim([ 15 max(b(:))])
      title('Histogram of pixel intensities, the threshold can be fixed to about 1/3rd the maximum intensity')
      
      hm=input('look at the histogram and input the threshold value')
      dp=9;pk = pkfnd(b,hm,dp);%finds the peaks with loose accuracy
      close 
%       subplot(1,2,1),
imagesc(b)
colormap 'gray'
 hold on
plot(pk(:,1),pk(:,2),'r*')
title('Increase hm if too many artificial spots are found. To increase hm, just press ctrl-enter in Cell2, which will execute the cell again')

  %% Cell 3 -final
      
close all
nn=0;

% ================================================
% Actual peak finding
pkcount=0;ccnt=1;pkit=0;DDp=0;
as=zeros(51,51);
for i=1:no_frames
     
    while(DDp==0 && nn<3)
        
            im= rettempvar{i};
            cropmovtest=im(rowst:rowst+height,colst:colst+width);
            im=cropmovtest;
            b=bpass(im,1,bp);finb{i}=b;
%             as(26-floor(length(b(1,:))/2):26+floor(length(b(1,:))/2),26-floor(length(b(1,:))/2):26+floor(length(b(1,:))/2))=b;
%             BpassCrop{i}=b;
%             hm=Hmi(i);
            if isempty(pk)
                hm=input('the cutoff value needs to be lower. Enter new value(suggested = 1/3rd previous value) ')
            end
            
            pk = pkfnd(b,hm,dp);
            cnt = cntrd(b,pk,dp,0,i);%sub pixel (nm) accurate tracking
            
            if ~isempty(cnt)
        
                Buffsave{ccnt}=[cnt(:,1) cnt(:,2) cnt(:,3) cnt(:,4) i*ones(length(cnt(:,1)),1)]; 
                ccnt=ccnt+1;
               i
                
                    subplot(1,2,1), hist(b(:),100)
                    subplot(1,2,2), imagesc(b)
                    hold on
                    subplot(1,2,2), plot(cnt(:,1),cnt(:,2),'*')
                    colormap gray
                    disp('analyzing frame no')
                    
%                     DDp=input('Ddp, enter 1 if satisfied or 0 if not')'
                    display('Previous cutoff value is')
%                     hm
                    pause(1.5)
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
pos=[xI(2:end) yI(2:end) time(2:end)];
% pos=[TT(realpts,1) TT(realpts,2) TT(realpts,3) TT(realpts,4) TT(realpts,5)];
vari=8;%this is the maximum spatial range over which your center can wobble, if it wobbles too much and goes beyond
%  this vari value, then the program will identify it as a new motor (number 2). For
%  wobbly motors, use vari>3 and <10. If there are more than one motors,
%  then make this value small, so that no other motor is incorrectly
%  identified as number 1.
tr=track(pos,vari,5,{5});%yhr number in the curly is the minimum number of frames in which the motor must be detected, this way 
% you will reduce poor data sets where motors can't be identified over 5
% frames
display('total number of motors found')
part=tr(end,end)
idvec=uint8(tr(:,end));
motn={'p1' 'p2'  'p3'  'p4'  'p5' 'p6' 'p7' 'p8' 'p9' 'p10' 'p11' 'p12'  'p13'  'p14'  'p15' 'p16' 'p17' 'p18' 'p19' 'p20'};
ccctv=1;sipah=[];sprB=[];
for i=1:idvec(end)
    HL=(find(idvec==i));DDJ=tr(HL,:);
    if std(DDJ(:,1))>1 & std(DDJ(:,2))>1
        sipah(ccctv)=i;
        sprB.(motn{ccctv})=tr(HL,:);
        ccctv=ccctv+1;
    end
    DDJ=[];
end
trackerdisp