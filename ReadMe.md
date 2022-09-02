# PhanSST Read Me

Created: February 2022 (E. Judd)
<br /> Last updated: September 2022 (E. Judd)
<br /> Website: paleo-temperature.org
<br /> Contact: ejjudd@syr.edu or phansst@outlook.com
<br /> Current release: PhanSST v 0.0.1

This repository contains the PhanSST Database of paleo-sea surface temperature (SST) proxy data spanning the Phanerozoic Eon and is associated with the 
manuscript: 

*The PhanSST global database of Phanerozoic sea surface temperature proxy data* (Judd et al., submitted, Scientific Data).

Please refer to this manuscript for additional information and cite it when using data from the PhanSST database.


To view the quality control spreadsheets, please visit paleo-temperature.org or use the following links:
* **Drill core data**: https://docs.google.com/spreadsheets/d/e/2PACX-1vTs8zmQyOINP7TqLaI2emuplMQaYMcM24z6tbsV1pnNZ5N5zXVkj-3SweGxlZyu6WCDhLQGPdzAg6zX/pubhtml
* **Outcrop data**: https://docs.google.com/spreadsheets/d/e/2PACX-1vRi32Mp-KtyCzt43nQ_ljpGM85fN-A7mnnFJ1o5Q-bF8dKTEZpDvDA5J5W_McoTK7RohSpPV4mMxZnI/pubhtml
* **Foraminiferal taxonomy**: https://docs.google.com/spreadsheets/d/e/2PACX-1vRWpolW-OSNhZMd3_8-sQ26yipR1FR2KsxYSHlIIavZfF2wCmrRKM3aVwRArtE9J1gy0j2tJlmoUIPM/pubhtml

## PhanSST_v001.csv
This file presents a database of paleo sea surface temperature (SST) proxy data and their associated metadata. For a full description of the database, the user is referred to the original publication in Scientific Data (see above). 
Briefly, the field descriptions and units are as follows:
* **SampleID**: The unique identifier of each sample
* **SiteName**: The name of the drill core site or section
* **SiteHole**: The alphabetic hole specifier
* **MBSF**: Depth below the sea floor (m)
* **MCD**: The mean composite depth (m)
* **SampleDepth**: Stratigraphic height or depth of data not collected from an ocean drill core (m)
* **Formation**: The geologic formation name
* **Country**: The country of the data collection site
* **ContinentOcean**: The continent or ocean basin of the data collection site
  * *af*: Africa
  * *an*: Antarctica
  * *ar*: Arctic Ocean
  * *as*: Asia
  * *at*: Atlantic Ocean
  * *au*: Australasia
  * *eu*: Europe
  * *in*: Indian Ocean
  * *me*: Mediterranean Sea
  * *na*: North America
  * *pa*: Pacific Ocean
  * *sa*: South America
  * *so*: Southern Ocean
* **ModLat**: Modern latitude of collection site rounded to two decimals; negative values indicate the Southern Hemisphere (decimal degrees)
* **ModLon**: Modern longitude of the collection site rounded to two decimals; negative values indicate the Western Hemisphere (decimal degrees)
* **Age**: Age, in reference to GTS2020 (Ma)
* **Period**: The geologic period
* **Stage**: The geologic stage
* **StagePosition**: Further specification of relative age (early, middle, or late)
* **Biozone**: The conodont, graptolite, and/or ammonite biozone
* **AgeFlag**: Binary flag indicating if the Age field reflects a precise numeric assignment (0) or an estimate based on relative age information (1)
* **ProxyValue**: The reported proxy value (native proxy units)
* **ProxyType**: Reference to the proxy type
  * *d18c*: oxygen isotopes of calcite (per mille, VPDB)
  * *d18a*: oxygen isotopes of aragonite (per mille, VPDB)
  * *d18p*: oxygen isotopes of conodont phosphate (per mille, VSMOW)
  * *mg*: magnesium to calcium ratios of planktonic foraminifera (mmol/mol)
  * *tex*: TEX86
  * *uk*: UK’37
* **ValueType**: Reference to the averaging of the data
  * *im*: individual measurement from an individual specimen (e.g., single foram, single sample from brachiopod)
  * *ia*: average of measurements from an individual specimen (e.g., average of multiple different spot samples from a brachiopod)
  * *pa*: population average (e.g., bulk foram measurement, average of measurements from a single stratigraphic horizon)
* **DiagenesisFlag**: Binary expert-assigned flag indicating good (0) or questionable (1) preservation
* **Taxon1**: First-order taxonomic classification
  * *br*: Brachiopod
  * *m*: Mollusk
  * *co*: Conodont
  * *ha*: Haptophyte
  * *pf*: Planktonic foraminifera
  * *th*: Thaumarchaeota
* **Taxon2**: Second-order (class) classification of mollusks
  * *bi*: Bivalve
  * *ce*: Cephalopod
  * *ga*: Gastropod
  * *ot*: Other
* **Taxon3**: Third-order (genus or species) classification
* **Environment**: Depositional environment (e.g., mid-shelf, epeiric)
* **Ecology**: Ecological preference of the sampled taxon (e.g., surface, benthic)
* **AnalyticalTechnique**: The analytical technique used to obtain the data (IRMS vs SIMS)
* **CL**: cathodoluminescence assessment (L = luminescent; SL = slightly luminescent; NL = not luminescent)
* **Elemental Suite**: All reported elemental concentrations and ratios
  * *Fe*: Iron (ppm)
  * *Mn*: Manganese (ppm)
  * *Mg*: Magnesium (ppm)
  * *Sr*: Strontium (ppm)
  * *Ca*: Calcium (ppm)
  * *Cawtp*: Calcium (weight percent)
  * *Mg/Ca*: Magnesium to calcium (mmol/mol)
  * *Sr/Ca*: Strontium to calcium (mmol/mol)
  * *Mn/Sr*: Manganese to strontium (ppm/ppm)
* **NBS120c**: The NBS120c value used to correct phosphate data (‰, VMSOW)
* **Durango**: The Durango value used SIMS phosphate data (‰, VMSOW)
* **MaximumCAI**: The maximum reported conodont color alteration index value for that sample or horizon
* **ModWaterDepth**: The modern water depth of the sampling site (m)
* **CleaningMethod**: A binary flag to indicate either oxidative-only cleaning (0) or inclusion of a reductive cleaning step (1) of Mg/Ca data
* **Fractional abundances**: Fields to indicate the fractional abundances of the GDGTs
* **Index values**: Branched and isoprenoid tetraether (BIT), methane (MI), and delta ring (dRI) index values
* **LeadAuthor**: The last name of the first author of the original publication
* **Year**: The year of the original publication
* **PublicationDOI**: The DOI or other identifying hyperlink of the original publication
* **DataDOI**: The DOI or other identifying hyperlink to the online repository hosting the data


## PhanSST_v001_RefList.xlsx
This file contains an excel spreadsheet with the full reference metadata for each paper cited in PhanSST.


## PhanSST_BlankEntryTemplate.csv
This file provides a blank template with which to enter new paleo-SST data. 
Completed data entry templates can be submitted via the PhanSST website (paleo-temperature.org) or by email (PhanSST@outlook.com).
For detailed information regarding contributing data via the data entry template, please visit paleo-temperature.org.

