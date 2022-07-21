%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% SCRIPT TO RUN %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%% THE AUTOMATED QC CHECK ON THE PHANSST DATABASE %%%%%%%%%%%%%
%%%%%%%%%%%%%%%%% JUDD ET AL., SUBMITTED, SCIENTIFIC DATA %%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Script created: 02/2022 (E. Judd)
% Last updated: 07/2022 (E. Judd)
% Purpose: This is a script to run the automated QC checks on the PhanSST
%          database (submitted to Scientific Data)

% Files needed:
%   (1): PhanSST database (E. Judd et al., 2022) 
%        available via paleo-temperature.org & figshare
%   (2): StageNamesandAges (E. Judd et al., 2022)
%        available via paleo-temperature.org, figshare, & Github

% Checks include:
% 1) LOCATION INFORMATION
%    (a) Confirm all entries have a ContinentOcean values & that they are
%        valid accepted names
%    (b) Confirm that no lats/lons are missing and all values fall within
%        an appropriate (decimal degree) range
% 2) AGE INFORMATION
%    (a) Confirm all entries a numeric age, Period, and Stage information
%    (b) Confirm all entries have accepted GTS2020 Period and Stage names
%    (c) Confirm all age values are consistent with stage & period assignments
% 3) PROXY INFORMATION
%    (a) Confirm all entries are attached to a proxy value
%    (b) Confirm all proxy types are accepted
% 4) TAXON INFORMATION
%    (a) Confirm all entries are attached to a valid Taxon 1 value
%    (b) Confirm all mollusk data are attached to a valid Taxon 2 value
%    (c) Confirm that no non mollusk data are attached to a Taxon 2 value
% 5) REFERENCE INFORMATION
%   (a) Check for missing Lead Author values
%   (b) Check for missing Year values
%   (c) Check for missing PublicationDOI values

% INSTRUCTIONS: Load data, then run the automated QC checks.
%               The results of each test will appear in the command line
%               followed by a summary once all tests are completed.

%% Load in data data
% (1) Define filename (and path)
filename="PhanSST_v001.csv";    

% (2) Indicate which fields are strings vs. numeric values
stringfields = {'SampleID','SiteName','SiteHole','Formation','Country',...
        'ContinentOcean','Period','Stage','StagePosition','Biozone',...
        'ProxyType','ValueType','Taxon1','Taxon2','Taxon3','Environment',...
        'Ecology','CL','LeadAuthor','PublicationDOI','DataDOI'};
doublefields = {'MBSF','MCD','SampleDepth','ModLat','ModLon','Age',...
        'AgeFlag','ProxyValue','DiagenesisFlag','Mn','Fe','Sr','Mg','Ca',...
        'Cawtp','MgCa','SrCa','MnSr','NBS120c','Durango','MaximumCAI',...
        'ModWaterDepth','CleaningMethod','GDGT0','GDGT1','GDGT2','GDGT3',...
        'Cren','Crenisomer','BIT','dRI','MI','Year'};
opts = detectImportOptions(filename);
opts = setvartype(opts,stringfields,'string');
opts = setvartype(opts,doublefields,'double');

opts = setvaropts(opts,stringfields,'FillValue',"");

% (3) Load PhanSST data & GTS2020 information (available in supplemental
%     files)
PhanSST = readtable(filename, opts);
GTS = readtable("StageNamesandAges.xlsx");

%% RUN AUTOMATED CHECKS
FailedTests = [];
% 1) LOCATION INFORMATION
%    (a) Confirm all entries have a ContinentOcean values & that they are
%        valid accepted names
ContinentOcean = ["af";"an";"ar";"as";"at";"au";"eu";"in";"me";"na";"pa";"sa";"so"];
if any(~cellfun(@isempty,PhanSST.ContinentOcean)) & ...
   all(ismember(unique(string(PhanSST.ContinentOcean)), ContinentOcean))
    disp("Check 1a Passed: All entries have valid ContinentOcean values")
elseif any(cellfun(@isempty,PhanSST.ContinentOcean)) & ...
       all(ismember(unique(string(PhanSST.ContinentOcean)), ContinentOcean))
    disp("Check 1a Failed: Entries with missing ContinentOcean value")
    FailedTests = [FailedTests; "Check 1a"];
elseif any(cellfun(@isempty,PhanSST.ContinentOcean)) & ...
       any(~ismember(unique(string(PhanSST.ContinentOcean)), ContinentOcean))
    disp("Check 1a Failed: Entries with invalid ContinentOcean values")
    FailedTests = [FailedTests; "Check 1a"];
else
    disp("Check 1a Failed: Entries with missing and invalid ContinentOcean values")
    FailedTests = [FailedTests; "Check 1a"];
end
%    (b) Confirm that no lats/lons are missing and all values fall within
%        an appropriate (decimal degree) range
idx1 = isnan(PhanSST.ModLat) | isnan(PhanSST.ModLon); 
idx2 = PhanSST.ModLat<-90 | PhanSST.ModLat>90 | ...
       PhanSST.ModLon<-180 | PhanSST.ModLon>180;
if all(idx1 == 0) & all(idx2 == 0)
    disp("Check 1b Passed: All entries are attached to valid coordinates")
elseif any(idx1 == 1) & all(idx2 == 0)
    disp("Check 1b Failed: Entries with missing coordinates")
    FailedTests = [FailedTests; "Check 1b"];
elseif all(idx1 == 0) & any(idx2 == 1)
    disp("Check 1b Failed: Entries with invalid coordinates")
    FailedTests = [FailedTests; "Check 1b"];
else
    disp("Check 1b Failed: Entries with missing and invalid coordinates")
    FailedTests = [FailedTests; "Check 1b"];
end

% 2) AGE INFORMATION
%    (a) Confirm all entries a numeric age, Period, and Stage information
if all(~isnan(PhanSST.Age)) & all(~cellfun(@isempty,PhanSST.Period)) & ...
   all(~cellfun(@isempty,PhanSST.Stage))
    disp("Check 2a Passed: All entries are attached to age, period, & stage values")
elseif any(isnan(PhanSST.Age)) & all(~cellfun(@isempty,PhanSST.Period)) & ...
       all(~cellfun(@isempty,PhanSST.Stage))
    disp("Check 2a Failed: Entries with missing numeric age information")
    FailedTests = [FailedTests; "Check 2a"];
elseif all(~isnan(PhanSST.Age)) & (any(cellfun(@isempty,PhanSST.Period)) | ...
       any(cellfun(@isempty,PhanSST.Stage)))
    disp("Check 2a Failed: Entries with missing relative age information")
    FailedTests = [FailedTests; "Check 2a"];
else
    disp("Check 2a Failed: Entries with missing numeric and relative age information")
    FailedTests = [FailedTests; "Check 2a"];
end
%    (b) Confirm all entries have accepted GTS2020 Period and Stage names
periods = unique(PhanSST.Period);
stages = unique(PhanSST.Stage);
if all(ismember(periods,GTS.Period)) && all(ismember(stages,GTS.Stage))
    disp("Check 2b Passed: All entries are attached to valid period, & stage names")
elseif any(~ismember(periods,GTS.Period)) && all(ismember(stages,GTS.Stage))
    disp("Check 2b Failed: Entries with invalid period names")
    FailedTests = [FailedTests; "Check 2b"];
elseif all(ismember(periods,GTS.Period)) && any(~ismember(stages,GTS.Stage))
    disp("Check 2b Failed: Entries with invalid stage names")
    FailedTests = [FailedTests; "Check 2b"];
else
    disp("Check 2b Failed: Entries with invalid period and stage names")
    FailedTests = [FailedTests; "Check 2b"];   
end
%    (c) Confirm all age values are consistent with stage & period assignments
s=0;
p = 0;
for ii = 1:numel(stages)
    idx1 = find(string(PhanSST.Stage) == stages(ii));
    idx2 = find(string(GTS.Stage) == stages(ii));
    if unique(string(PhanSST.Period(idx1))) ~= string(GTS.Period(idx2))
        p = p+1;
    end
    if any(PhanSST.Age(idx1) > GTS.LowerBoundary(idx2)) && ...
            any(PhanSST.Age(idx1) < GTS.UpperBoundary(idx2))
        s = s+1;
    end
end
if p == 0 && s == 0
    disp("Check 2c Passed: All entries have consistent numeric and relative age assignments")
else 
    disp("Check 2c Failed: Entries with inconsistent numeric and relative age assignments")
    FailedTests = [FailedTests; "Check 2c"];
end

% 3) PROXY INFORMATION
%    (a) Confirm all entries are attached to a proxy value
if all(~isnan(PhanSST.ProxyValue))
    disp("Check 3a Passed: All entries attached to a proxy value")
else
    disp("Check 3a Failed: Entries missing proxy values")
    FailedTests = [FailedTests; "Check 3a"];
end
%    (b) Confirm all proxy types are accepted
proxynames = ["d18a";"d18c";"d18p";"mg";"tex";"uk"];
if all(~cellfun(@isempty,PhanSST.ProxyType)) && ...
   all(ismember(unique(string(PhanSST.ProxyType)), proxynames))
    disp("Check 3b Passed: All entries attached to valid proxy types")
elseif any(cellfun(@isempty,PhanSST.ProxyType)) && ...
   all(ismember(unique(string(PhanSST.ProxyType)), proxynames))
    disp("Check 3b Failed: Entries with missing proxy types")
    FailedTests = [FailedTests; "Check 3b"];
elseif all(~cellfun(@isempty,PhanSST.ProxyType)) && ...
   any(~ismember(unique(string(PhanSST.ProxyType)), proxynames))
    disp("Check 3b Failed: Entries with invalid proxy types")
    FailedTests = [FailedTests; "Check 3b"];
else
    disp("Check 3b Failed: Entries with missing and invalid proxy types")
    FailedTests = [FailedTests; "Check 3b"];
end
    
% 4) TAXON INFORMATION
%    (a) Confirm all entries are attached to a valid Taxon 1 value
Taxon1 = ["br";"m";"co";"ha";"pf";"th"];
if all(~cellfun(@isempty,PhanSST.Taxon1)) && ...
   all(ismember(unique(string(PhanSST.Taxon1)), Taxon1))
    disp("Check 4a Passed: All entries attached to valid Taxon1 value")
elseif any(cellfun(@isempty,PhanSST.Taxon1)) && ...
   all(ismember(unique(string(PhanSST.Taxon1)), Taxon1))
    disp("Check 4a Failed: Entries with missing Taxon1 values")
    FailedTests = [FailedTests; "Check 4a"];
elseif all(~cellfun(@isempty,PhanSST.Taxon1)) && ...
   any(~ismember(unique(string(PhanSST.Taxon1)), Taxon1))
    disp("Check 4a Failed: Entries with invalid Taxon1 values")
    FailedTests = [FailedTests; "Check 4a"];
else
    disp("Check 4a Failed: Entries with missing and invalid Taxon1 values")
    FailedTests = [FailedTests; "Check 4a"];
end
%    (b) Confirm all mollusk data are attached to a valid Taxon 2 value
Taxon2 = ["bi";"ce";"ga";"ot"];
idx1 = find(PhanSST.Taxon1=="m");
if all(~cellfun(@isempty,PhanSST.Taxon2(idx1))) && ...
   all(ismember(unique(string(PhanSST.Taxon2(idx1))), Taxon2))
    disp("Check 4b Passed: All mollusk entries attached to valid Taxon2 value")
elseif any(cellfun(@isempty,PhanSST.Taxon2(idx1))) && ...
       all(ismember(unique(string(PhanSST.Taxon2(idx1))), Taxon2))
    disp("Check 4b Failed: Mollusk entries with missing Taxon2 values")
    FailedTests = [FailedTests; "Check 4b"];
elseif all(~cellfun(@isempty,PhanSST.Taxon2(idx1))) && ...
       any(~ismember(unique(string(PhanSST.Taxon2(idx1))), Taxon2)) 
    disp("Check 4b Failed: Mollusk entries with invalid Taxon2 values")
    FailedTests = [FailedTests; "Check 4b"];
else
    disp("Check 4b Failed: Mollusk entries with missing and invalid Taxon2 values")
    FailedTests = [FailedTests; "Check 4b"];
end
%    (c) Confirm that no non mollusk data are attached to a Taxon 2 value
idx2 = find(PhanSST.Taxon1~="m");
if all(cellfun(@isempty,PhanSST.Taxon2(idx2)))
    disp("Check 4c Passed: No non mollusk entries have a Taxon2 value")
else
    disp("Check 4c Failed: Non mollusk entries with Taxon2 values")
    FailedTests = [FailedTests; "Check 4c"];
end

% 5) REFERENCE INFORMATION
%   (a) Check for missing Lead Author values
if all(~cellfun(@isempty,PhanSST.LeadAuthor))
    disp("Check 5a Passed: All entries associated with LeadAuthor")
else
    disp("Check 5a Failed: Entries with missing LeadAuthor")
    FailedTests = [FailedTests; "Check 5a"];
end
%   (b) Check for missing Year values
if all(~isnan(PhanSST.Year))
    disp("Check 5b Passed: All entries associated with publication year")
else
    disp("Check 5b Failed: Entries with missing publication year")
    FailedTests = [FailedTests; "Check 5b"];
end
%   (c) Check for missing PublicationDOI values
if all(~cellfun(@isempty,PhanSST.PublicationDOI))
    disp("Check 5c Passed: All entries associated with a publication DOI")
else
    disp("Check 5c Failed: Entries with missing publication DOIs")
    FailedTests = [FailedTests; "Check 5c"];
end

clearvars -except PhanSST GTS FailedTests
fprintf("AUTOMATED QC CHECKS COMPLETE. \n %d/13 Passed.\n",13-numel(FailedTests))
if numel(FailedTests) > 0
    disp("Failed tests:")
    disp(FailedTests)
end



%% MANUAL CHECKS
% In addition to the automated checks, it may be useful to print lists of
% certain variables and manually inspect them for inconsistencies or errors
% These include:

% 1) Site names
    sitenames = unique(PhanSST.SiteName);
% 2) Site hole identifiers
    sitholes = unique(PhanSST.SiteHole);
% 3) Formation names
    foramtions = unique(PhanSST.Formation);
% 4) Countries
    countries = unique(PhanSST.Country);
% 5) Species names
    species = unique(PhanSST.Taxon3);
