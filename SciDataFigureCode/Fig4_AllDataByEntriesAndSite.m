%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%% SCRIPT TO PLOT FIGURE 4 %%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%% JUDD ET AL., SUBMITTED, SCIENTIFIC DATA %%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Script created: 02/2022 (E. Judd)
% Last updated: 07/2022 (E. Judd)
% Purpose: This is a script to replicate Figure 4 of Judd et al. (submitted
%          to Scientific Data)

% Files needed:
%   (1): PhanSST database (E. Judd et al., 2022) 
%        available via paleo-temperature.org & figshare
%   (2): StageNamesandAges (E. Judd et al., 2022)
%        available via paleo-temperature.org, figshare, & Github
% Auxillary functions needed
%   (1): hex2rgb - (C. Greene, 2022) available on MATLAB file exchange:
%        https://www.mathworks.com/matlabcentral/fileexchange/46289-rgb2hex-and-hex2rgb
%   (2): geologictimescale (E. Judd, 2022) available via github
%   (3): export_fig - (Y. Altman, 2022) available on github:
%        https://github.com/altmany/export_fig/releases/tag/v3.21

%% PART (1) LOAD DATA
% (a) Direct filepath 
% (*MODIFY TO REFLECT END USER'S FILEPATHS AND PREFERRED FIGURE NAME)
datafilename = 'PhanSST_v001.csv';
stagefilename = 'StageNamesandAges.csv';
figname = 'Fig4_AllDataByEntriesAndSite.png';

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

% (c) Load PhanSST data & GTS2020 information (available in supplemental
%     files)
PhanSST = readtable(datafilename, opts);   
GTS = readtable(stagefilename);

%% PART (2) PRE-TREAT DATA
%  (a) Assign bin range and means
    binrng = [GTS.UpperBoundary;GTS.LowerBoundary(end)];
    binmn = GTS.Average;
%  (b) Create list of unique proxy types
    fn = unique(PhanSST.ProxyType);

%  (c) For each time bin and proxy type, find the number of entries and
%      unique sampling sites
    for ii = 1:numel(fn)
    d = PhanSST(strcmpi(PhanSST.ProxyType,fn(ii)),:);
    counts.entries.(fn{ii}) = zeros(length(binrng)-1,1);
    counts.sites.(fn{ii}) = zeros(length(binrng)-1,1);
    for jj = 1:numel(binrng)-1
        % total entries:
        coors = [d.ModLat(d.Age>=binrng(jj)&d.Age<binrng(jj+1)), ...
            d.ModLon(d.Age>=binrng(jj)&d.Age<binrng(jj+1))];
        counts.entries.(fn{ii})(jj)=length(coors);
        % unique sampling sites
        coors = unique(coors,'rows');
        counts.sites.(fn{ii})(jj)=length(coors);
    end
    end

%  (d) Combine arargonite and calcite isotope PhanSST into same proxy field
    counts.entries.d18c = counts.entries.d18a+counts.entries.d18c;
    counts.sites.d18c = counts.sites.d18a+counts.sites.d18c;
    counts.entries = rmfield(counts.entries,'d18a');
    counts.sites = rmfield(counts.sites,'d18a');
    fn = fieldnames(counts.sites);
    
%  (e) Convert counts to proportion 
    proportion = counts;
    for ii = 1:numel(binrng)-1
    % total entries
        te = sum([counts.entries.d18c(ii),counts.entries.mg(ii), ...
            counts.entries.d18p(ii),counts.entries.tex(ii), counts.entries.uk(ii)]);    
    % total sites
        ts = sum([counts.sites.d18c(ii), counts.sites.mg(ii), ...
            counts.sites.d18p(ii),counts.sites.tex(ii), counts.sites.uk(ii)]);
    % calculate proportions
        for jj = 1:numel(fn)
            proportion.entries.(fn{jj})(ii) = counts.entries.(fn{jj})(ii)/te;
            proportion.sites.(fn{jj})(ii) = counts.sites.(fn{jj})(ii)/ts;
        end
    end
    
    

%% PART(3) PLOT FIGURE
% (a) Create figure & specify proxy name labels and colors and proxy order
    fig=figure('Name','Figure4_AllDataByEntriesAndSite','NumberTitle','off');
    set(fig,'color','w');
    fig.Units='inches';
    fig.Position = [24.8,2,15,8];
    PlotSpecs.Proxy = ["U^{k'}_{37}","\fontsize{12}TEX\fontsize{8}86",...
        "Mg/Ca","\fontsize{12}δ^{18}O\fontsize{8}phosphate",...
        "\fontsize{12}δ^{18}O\fontsize{8}carbonate"];
    PlotSpecs.Color = hex2rgb(['#9B2226';'#FFB703';'#B4BE65';'#0A9396';'#005F73'],1);
    fn = flipud(fieldnames(counts.entries));
  
% (b) PANEL 1: Violin histograms
    ax = subplot('Position',[.075 .075 .4 .9]);
    % assign center point (
    centerY = NaN(numel(fn),1);
    for ii = 1:numel(fn)
        % assign mid point
        if ii == 1
        centerY(ii) = max(counts.sites.d18c)/2+5;
        else
        centerY(ii) = centerY(1)*ii*1.25;
        end
        % for each stage, plot rectangle
        for jj = 1:numel(binrng)-1
            w = binrng(jj+1)-binrng(jj);
            h = counts.sites.(fn{ii})(jj);
            posX = binrng(jj);
            posY=centerY(ii) - h/2;
            rectangle('Position', [posX, posY, w, h], ...
                'EdgeColor', 'k', 'FaceColor', PlotSpecs.Color(ii,:));
        end
    end
    % tidy up plot
    ylim([-(range(centerY)/35) centerY(end)+centerY(1)+(range(centerY)/35)])
    ax.YTick = centerY;
    ax.YTickLabels=PlotSpecs.Proxy;
    ax.FontSize=11;ax.FontName='Arial';
    geologictimescale(0,GTS.LowerBoundary(end),'normal','reverse',ax,'standard','stages','off',15)    
    xlabel('Age (Ma)','FontName','Arial','FontWeight','bold','FontSize',15)
 
    % add legend (placement quasi manual)
    r = rectangle('Position',[325, 10, 190, 45]); r.FaceColor = 'w';
    txtstring = "Unique sampling sites";
    text(418,47.5,txtstring,'fontname','arial','fontweight','bold','fontsize',11,'HorizontalAlignment','center')
    rectangle('Position',[375, 15, 5, 25],'edgecolor','none','facecolor','k')
        text(368,37.5,'25','fontname','arial','fontsize',11)
    rectangle('Position',[425, 30, 5, 10],'edgecolor','none','facecolor','k')
        text(422,37.5,'10','fontname','arial','fontsize',11)
    rectangle('Position',[475, 35, 5, 5],'edgecolor','none','facecolor','k')
        text(468,37.5,'5','fontname','arial','fontsize',11)

%  (c) PANEL 2: Proportion of entires
    ax = subplot('Position',[.55 .55 .4 .425]);
    fn = fieldnames(counts.entries);
    y = zeros(numel(GTS.Stage),1);
    x = GTS.UpperBoundary;
    w = GTS.LowerBoundary - GTS.UpperBoundary;
    for jj = 1:numel(fn)
    for ii = 1:numel(GTS.Average)
        if isnan(proportion.entries.(fn{jj})(ii))
            proportion.entries.(fn{jj})(ii) = 0;
        end
        r = rectangle('Position',[x(ii),y(ii),w(ii),proportion.entries.(fn{jj})(ii)]);
        r.FaceColor = PlotSpecs.Color(end-jj+1,:); r.EdgeColor = 'none';
        y(ii) = y(ii)+proportion.entries.(fn{jj})(ii);
    end
    end
    % tidy plot
    ax.YTick = [0,.25,.50,.75,1.00];
    ax.YTickLabel = ax.YTick*100; 
    ax.FontName = 'Arial'; ax.FontSize = 11;
    ylabel({'Proportion of entries'; 'per proxy (%)'},'fontname','Arial','fontweight','bold','FontSize',15')
    geologictimescale(0,GTS.LowerBoundary(end),'normal','reverse',ax,'standard','stages','off',7.75)    

%  (d) PANEL 3: Proportion of sites
    ax = subplot('Position',[.55 .075 .4 .425]);hold on
    y = zeros(numel(GTS.Stage),1);
    for jj = 1:numel(fn)
    for ii = 1:numel(GTS.Average)
        if isnan(proportion.sites.(fn{jj})(ii))
            proportion.sites.(fn{jj})(ii) = 0;
        end
        r = rectangle('Position',[x(ii),y(ii),w(ii),proportion.sites.(fn{jj})(ii)]);
        r.FaceColor = PlotSpecs.Color(end-jj+1,:); r.EdgeColor = 'none';
        y(ii) = y(ii)+proportion.sites.(fn{jj})(ii);
    end
    end
    % tidy plot
    ax.YTick = [0,.25,.50,.75,1.00];
    ax.YTickLabel = ax.YTick*100;
    ax.FontName = 'Arial'; ax.FontSize = 11;
    ylabel({'Proportion of sampling sites';'per proxy (%)'},'fontname','Arial','fontweight','bold','FontSize',15')
    xlabel('Age (Ma)','FontName','Arial','FontWeight','bold','FontSize',15)
    geologictimescale(0,GTS.LowerBoundary(end),'normal','reverse',ax,'standard','stages','off',7.75)    
    
% (e) Add panel labels (quasi manual)
    annotation('textbox',[.01,.99,0,0],'string','A','fontsize',15,'fontname','Arial','fontweight','bold')
    annotation('textbox',[.485,.99,0,0],'string','B','fontsize',15,'fontname','Arial','fontweight','bold')
    annotation('textbox',[.485,.515,0,0],'string','C','fontsize',15,'fontname','Arial','fontweight','bold')
    
% (f) Save figure
    export_fig(fig,figname,'-p0.01','-m5')  
