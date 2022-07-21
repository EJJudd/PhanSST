%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%% SCRIPT TO PLOT FIGURE 5 %%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%% JUDD ET AL., SUBMITTED, SCIENTIFIC DATA %%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Script created: 02/2022 (E. Judd)
% Last updated: 07/2022 (E. Judd)
% Purpose: This is a script to replicate Figure 5 of Judd et al. (submitted
% to Scientific Data)

% Files needed:
%   (1): PhanSST database (E. Judd et al., 2022) 
%        available via paleo-temperature.org & figshare
%   (2): StageNamesandAges (E. Judd et al., 2022)
%        available via paleo-temperature.org, figshare, & Github
% Auxillary functions needed
%   (1): hex2rgb - (C. Greene, 2022) available on MATLAB file exchange:
%        https://www.mathworks.com/matlabcentral/fileexchange/46289-rgb2hex-and-hex2rgb
%   (2): geologictimescale - (E. Judd, 2022) available via github
%   (3): export_fig - (Y. Altman, 2022) available on github:
%        https://github.com/altmany/export_fig/releases/tag/v3.21

%% PART (1) LOAD DATA
% (a) Direct filepath 
% (*MODIFY TO REFLECT END USER'S FILEPATHS AND PREFERRED FIGURE NAME)
datafilename = 'PhanSST_v001.csv';
stagefilename = 'StageNamesandAges.csv';
figname = 'Fig5_EntriesByProxy.png';

% (b) Indicate which fields are strings vs. numeric values
stringfields = {'SampleID','SiteName','SiteHole','Formation','Country',...
        'ContinentOcean','Period','Stage','StagePosition','Biozone',...
        'ProxyType','ValueType','Taxon1','Taxon2','Taxon3','Environment',...
        'Ecology','CL','LeadAuthor','PublicationDOI','DataDOI'};
doublefields = {'MBSF','MCD','SampleDepth','ModLat','ModLon','Age',...
        'AgeFlag','ProxyValue','DiagenesisFlag','Mn','Fe','Sr','Mg','Ca',...
        'Cawtp','MgCa','SrCa','MnSr','NBS120c','Durango','MaximumCAI',...
        'ModWaterDepth','CleaningMethod','GDGT0','GDGT1','GDGT2','GDGT3',...
        'Cren','Crenisomer','BIT','dRI','MI','Year'};
opts = detectImportOptions(datafilename);
opts = setvartype(opts,stringfields,'string');
opts = setvartype(opts,doublefields,'double');
opts = setvaropts(opts,stringfields,'FillValue',"");

% (c) Read in PhanSST Database
PhanSST = readtable(datafilename,opts);    
GTS = readtable(stagefilename);


%% PART(2) PLOT FIGURE
% (a) Create figure & specify proxy name labels and colors and proxy order
    fig=figure('Name','Figure4_EntriesByProxy','NumberTitle','off');
    set(fig,'color','w');
    fig.Units='inches';fig.Position=[20.5,2,15,8.5];
    PlotSpecs.ProxyType = ["d18c";"d18p";"mg";"tex";"uk"];
    PlotSpecs.Color = hex2rgb(['#9B2226';'#FFB703';'#B4BE65';'#0A9396';'#005F73'],1);
% (b) Specify positions of subplots
    h=.41; w1 = .57; w2 = .3375; w3 = .25; w4 = .445; w5 = .185;
    c1t = .05; c2t=c1t+0.035+w1; 
    c1b = .05; c2b = c1b+0.03+w3; c3b = c2b+0.035+w4;
    r1= .56; r2=.075;
    axPos = [c1t,r1,w1,h; c2t,r1,w2,h; c1b,r2,w3,h; c2b,r2,w4,h; c3b,r2,w5,h];
% (c) Cycly through each proxy and plot
maxage = NaN(numel(PlotSpecs.ProxyType),1);
minage = NaN(numel(PlotSpecs.ProxyType),1);
for pp = 1:numel(PlotSpecs.ProxyType)
    % subset data (combine aragonite data with other carbonate data)
    if strcmpi(PlotSpecs.ProxyType(pp), 'd18c')
    d = PhanSST(strcmpi(string(PhanSST.ProxyType),PlotSpecs.ProxyType(pp)) | ...
        strcmpi(string(PhanSST.ProxyType),'d18a'),:);
    else 
    d = PhanSST(strcmpi(string(PhanSST.ProxyType),PlotSpecs.ProxyType(pp)),:);
    end
    % remove diagenetic data (du = data unaltered)
    du = d;
    du(du.DiagenesisFlag == 1,:) = [];
    if strcmpi(PlotSpecs.ProxyType(pp), 'tex')
    du(du.MI>0.5,:) = []; du(du.dRI>0.5,:) = []; du(du.BIT>0.5,:) = [];
    end
    maxstage = unique(string(d.Stage(d.Age == max(d.Age))));
    minstage = unique(string(d.Stage(d.Age == min(d.Age))));
    maxage(pp,1) = GTS.LowerBoundary(strcmpi(GTS.Stage,maxstage));
    minage(pp,1) = GTS.UpperBoundary(strcmpi(GTS.Stage,minstage));

    Nentry = NaN(find(strcmpi(string(GTS.Stage), maxstage)),1);
    Nentry_unaltered = NaN(find(strcmpi(string(GTS.Stage), maxstage)),1);
    ax = axes('Position',axPos(pp,:));
    for ii = 1:find(strcmpi(string(GTS.Stage), maxstage))
        Nentry_unaltered(ii) = numel(find(strcmpi(string(du.Stage), string(GTS.Stage(ii)))));
        Nentry(ii,1) = numel(find(strcmpi(string(d.Stage), string(GTS.Stage(ii)))));
        r1 = rectangle('Position',[GTS.UpperBoundary(ii),0,GTS.LowerBoundary(ii)-...
            GTS.UpperBoundary(ii),Nentry(ii)],'FaceColor',...
            [PlotSpecs.Color(end-pp+1,:),.25],'EdgeColor','k');
        r2 = rectangle('Position',[GTS.UpperBoundary(ii),0,GTS.LowerBoundary(ii)-...
            GTS.UpperBoundary(ii),Nentry_unaltered(ii)],'FaceColor',...
            PlotSpecs.Color(end-pp+1,:),'EdgeColor','k');
    end
    % tidy plot & add panel labels
    ax.FontSize = 12; ax.FontName = 'Arial';
    if pp == 1
    ylim([0 5000]), yl = range(ylim);
    ylabel('Number of entries (by stage)','fontname','Arial','fontweight','bold','FontSize',15)
    text(525,.99*yl,["A   δ^{18}O\fontsize{10}carbonate"],'fontname','Arial','fontweight','bold','FontSize',15, 'VerticalAlignment', 'top')
    elseif pp == 2
    ylim([0 750]), yl = range(ylim);
    text(488,.99*yl,["B   δ^{18}O\fontsize{10}phosphate"],'fontname','Arial','fontweight','bold','FontSize',15, 'VerticalAlignment', 'top')
    elseif pp == 3
    yl = range(ylim);
    ylabel('Number of entries (by stage)','fontname','Arial','fontweight','bold','FontSize',15)
    xlabel('','fontname','Arial','fontweight','bold','FontSize',15)
    text(112,.99*yl,'C   Mg/Ca','FontName','Arial','fontweight','bold','FontSize',15, 'VerticalAlignment', 'top')
    elseif pp == 4
    ylim([0 800]),yl = range(ylim);
    xlabel('Age (Ma)','fontname','Arial','fontweight','bold','FontSize',15)
    text(197.5,.99*yl,'D   TEX\fontsize{10}86','fontname','Arial','fontweight','bold','FontSize',15, 'VerticalAlignment', 'top')
    elseif pp == 5
    yl = range(ylim);
    xlabel('','fontname','Arial','fontweight','bold','FontSize',15)
    text(47,.99*yl,"E   U^{K'}_{37}",'fontname','Arial','fontweight','bold','FontSize',15, 'VerticalAlignment', 'top')
    end
    geologictimescale(minage(pp),maxage(pp),'normal','reverse',gca,'standard','stages','off',7.5)
end

export_fig(fig,figname,'-transparent','-p0.01','-m5')
