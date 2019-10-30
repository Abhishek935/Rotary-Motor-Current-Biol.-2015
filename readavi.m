%-------------------------------------------------------------------
% This code was used in Shrivastava,
% Lele, Berg; Current Biology, Vol 25, Issue 3, 338-341 2015.
%-------------------------------------------------------------------
clear all
clc
%-------------------------------------------------------------------
%  select the cell
%-------------------------------------------------------------------
Amov = dir ('*.avi');
a=numel(Amov);
% GG=input('movie?, input number')
for i=1:a
    close all
    filename = getfield (Amov,{i,1},'name')
    xyloObj = VideoReader(filename);             %imput the video
    nFrames = xyloObj.NumberOfFrames;           % No of frames
    fps=xyloObj.FrameRate;
%     ---------------------------------------------
%     if video is cropped and saved in imageJ
%     A1=read(xyloObj,10); A=A1;
%     if not:
    A1=read(xyloObj,10); A = rgb2gray(A1) ;
%     ---------------------------------------------
    [maxrow,maxcol]=size(A);
    cctr=1;
    for i=1:nFrames                         %select the area we interest.
%         If video is cropped and saved in ImageJ
%         A1=read(xyloObj,i); tempvar = (A1) ;    
%         if not:
        A=read(xyloObj,i); tempvar =  rgb2gray(A) ;
  %     ---------------------------------------------
            rettempvar{cctr}=flipud(tempvar);tempvar=[];
            cctr=cctr+1;
    end
    savfil=[filename '.mat'];
    save(savfil)%Saves cells
%     Tetheredcell_analysis
%     anglecor_main%edited by Pushkar. Remove the B from anglecor_mainBto go back to original Dec 2/2014
    
end

