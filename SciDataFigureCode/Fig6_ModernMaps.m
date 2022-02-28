%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%% SCRIPT TO PLOT FIGURE 6 %%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%% JUDD ET AL., SUBMITTED, SCIENTIFIC DATA %%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Script created: 02/2022 (E. Judd)
% Last updated: 02/2022 (E. Judd)
% Purpose: This is a script to replicate Figure 6 of Judd et al. (submitted
% to Scientific Data)

% Files needed:
%   (1): PhanSST database (E. Judd,2022) available via figshare
% Auxillary functions needed
%   (1): hex2rgb - (C. Greene, 2022) available on MATLAB file exchange:
%        https://www.mathworks.com/matlabcentral/fileexchange/46289-rgb2hex-and-hex2rgb
%   (2): geologictimescale - (E. Judd, 2022) available via github
%   (3): export_fig - (Y. Altman, 2022) available on github:
%        https://github.com/altmany/export_fig/releases/tag/v3.21
%   (4): MATLAB mapping toolbox
%   (5): legendScatter - (M. Bagagli, 2022) available on MATLAB file exchange:
%        https://www.mathworks.com/matlabcentral/fileexchange/59425-legend-scatter


% PART (1) LOAD DATA
% (a) Direct filepath 
% (*MODIFY TO REFLECT END USER'S FILEPATHS AND PREFERRED FIGURE NAME)
datafilename = 'PhanSST_v001.csv';
figname = 'Fig6_ModernMaps.png';

% (b) differentiate between character and numeric fields
charfields = {'Sample','SiteName','SiteHole','Formation','Country',...
        'ContinentOcean','Stage','StagePosition','Biozone','ProxyType','ValueType',...
        'Taxon1','Taxon2','Taxon3','Environment','Ecology','CL','LeadAuthor','DOI'};
doublefields = {'MBSF','MCD','SampleDepth','ModLat','ModLon','Age',...
        'ProxyValue','DiagenesisFlag','ModWaterDepth','CleaningMethod',...
        'Mn','Fe','Sr','Mg','Ca','Cawtp','MgCa','SrCa','NBS120c','MaximumCAI'...
        'GDGT0','GDGT1','GDGT2','GDGT3','Cren','Crenisomer','BIT','dRI',...
        'MI','Year'};
opts = detectImportOptions(datafilename);
opts = setvartype(opts,charfields,'char');
opts = setvartype(opts,doublefields,'double');
% (c) Read in PhanSST Database
data = readtable(datafilename,opts);

%% PART (2) Create figure, specify proxy names and colors & suplot ax pos
    fig=figure('Name','Fig6_ModernMaps','NumberTitle','off');
    set(fig,'color','w');
    fig.Units='inches';
    fig.Position=[20.5,2,15,10];
    PlotSpecs.Color = flipud(hex2rgb(['#9B2226';'#FFB703';'#B4BE65';'#0A9396';'#005F73'],1));
    PlotSpecs.ProxyType = ["d18c";"d18p";"mg";"tex";"uk"];

    PlotSpecs.EraLab = ["A                         Cenozoic";...
        "B                         Mesozoic";...
        "C                         Paleozoic"];
    PlotSpecs.ProxyLab = ["D                          δ^{18}O\fontsize{10}carbonate";...
           "E                          δ^{18}O\fontsize{10}phosphate";...
           "F                          Mg/Ca";...
           "G                          TEX\fontsize{10}86";...
           "H                          U^{K'}_{37}"];
    w=.32; h=.3; 
    c1=.0125; c2=.3438; c3=.6751; 
    r1=.66; r2=.33; r3=.01;
    axPos = [c1,r1,w,h;c2,r1,w,h;c3,r1,w,h;...
             c1,r2,w,h;c2,r2,w,h;c3,r2,w,h;...
             c1,r3,w,h;c2,r3,w,h;c3,r3,w,h];
         
%% PART (3) Maps by Eras
% (a) Parse entries by era (ce, me, pe) and sites (cs, ms, ps)
ce = data(data.Age<66,:);
me = data(data.Age>=66 & data.Age<251.9,:);
pe = data(data.Age>=251.9,:);
cs = unique([ce.ModLat,ce.ModLon],'rows');
ms = unique([me.ModLat,me.ModLon],'rows');
ps = unique([pe.ModLat,pe.ModLon],'rows');
% (b) Get a count of the number of entries at each unique sampling site
cc = NaN(length(cs),1); mc = NaN(length(ms),1); pc = NaN(length(ps),1);
for ii = 1:length(cs)
    idx = find(ce.ModLat == cs(ii,1) & ce.ModLon == cs(ii,2));
    cc(ii) = numel(idx);
end
for ii = 1:length(ms)
    idx = find(me.ModLat == ms(ii,1) & me.ModLon == ms(ii,2));
    mc(ii) = numel(idx);
end
for ii = 1:length(ps)
    idx = find(pe.ModLat == ps(ii,1) & pe.ModLon == ps(ii,2));
    pc(ii) = numel(idx);
end
% (c) Plot scatter maps
for ii = 1:3
   if ii == 1
   S = cs; E = cc;
   elseif ii == 2 
   S = ms; E = mc;
   else
   S = ps; E = pc;
   end
   ax = axes('Position',axPos(ii,:));
   t = title(PlotSpecs.EraLab(ii),'FontName','Arial','color','k', ...
        'FontWeight','bold', 'FontSize', 15, 'Units', 'normalized');
   t.Position(1) = 0.35; 
   ax = worldmap('World');setm(ax,'meridianlabel','off','parallellabel','off');gridm off
   geoshow(shaperead('landareas', 'UseGeoCoords', true),'EdgeColor','none','FaceColor',[.8,.8,.8],'LineWidth',.25)
   s = scatterm(S(:,1),S(:,2),E,'filled','markerfacecolor','k');
   s.Children.MarkerFaceAlpha=.25;
end

% PART (4) Maps by proxies
for ii = 1:numel(PlotSpecs.ProxyType)
   d = data(strcmpi(string(data.ProxyType),PlotSpecs.ProxyType(ii)),:);
   Nsites = unique([d.ModLat,d.ModLon],'rows');
   Nentries = NaN(numel(Nsites)/2,1);
   for jj = 1:numel(Nsites)/2
        Nentries(jj) = numel(find(d.ModLat == Nsites(jj,1) & d.ModLon == Nsites(jj,2)));
   end
   ax = axes('Position',axPos(ii+3,:));
   t = title(PlotSpecs.ProxyLab(ii),'FontName','Arial','color','k', ...
        'FontWeight','bold', 'FontSize', 15, 'Units', 'normalized');
   t.Position(1) = 0.35; 
   ax = worldmap('World');setm(ax,'meridianlabel','off','parallellabel','off');gridm off
   geoshow(shaperead('landareas', 'UseGeoCoords', true),'EdgeColor','none','FaceColor',[.8,.8,.8],'LineWidth',.25)
   s = scatterm(Nsites(:,1),Nsites(:,2), Nentries,'filled','markerfacecolor',PlotSpecs.Color(1,:));
   s.Children.MarkerFaceAlpha=.35; s.Children.MarkerFaceColor = PlotSpecs.Color(ii,:);
end
 
% PART (5) Add legend
ax = axes('Position',axPos(end,:));
ax = worldmap('World');setm(ax,'meridianlabel','off','parallellabel','off');
gridm off,framem('off')
legTitle = ['Number of' newline 'entries'];
TextCell={legTitle,'1000','100','10','1'};
SizeDim=[sqrt(1000),sqrt(100),sqrt(10),1];
Factor=1;
LineSpec = 'ko';
leg=legendScatter(TextCell,SizeDim,Factor,LineSpec);
leg.Units = 'normalized';leg.Position=[.775,.0175,.125,.3];
leg.FontName = 'Arial'; leg.FontSize = 12;

export_fig(fig,figname,'-transparent','-p0.01','-m5')

 
