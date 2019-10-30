% Use this when you want to analyze individual cells but not have to load each movie
Smov = dir ('*.avi.mat')
Sa=numel(Smov)

for i=1:Sa
    filename = getfield (Smov,{i,1},'name')
    load(filename)
    readavi_pushkarRE
    clearvars -except Smov Sa i
end
