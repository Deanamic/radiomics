function calcAllFusedTextures_HN(pathData,pathText,namePT,nameCT,nameROI,featType,CTweight_mat,scale_mat,algo_cell,Ng_mat)
% -------------------------------------------------------------------------
% function calcAllFusedTextures_HN(pathData,pathText,namePT,nameCT,nameROI,featType,CTweight_mat,scale_mat,Ng_mat)
% -------------------------------------------------------------------------
% DESCRIPTION: 
% This function computes FUSED texture features for all patients, for all 
% different combinations of the following texture extraction parameters:
% - CT weight: Weight given to MRI wavelet low-pass sub-bands in the 
%               PET/CT fusion process. 
% - Scale: Resolution at which the ROI is isotropically resampled.
% - Ng: Number of gray-levels in the quantization process. 
%
% Different extraction parameters are passed as arrays or cells in the
% function in order to test all possible combinations. This function is 
% used for FUSED scans specifically. See Ref. [1,2] and 'prepareVolume.m' 
% for more details.
%
% Texture features are computed for all head and neck (HN) DICOM  imaging 
% data downloaded from The Cancer Imaging Archive (TCIA) website at: 
% <http://dx.doi.org/10.7937/K9/xxxxxxxxxxxxxxxxxxx, and first organized 
% in a 'DATA' directory using the function readAllDICOM_HN.m.  Results are 
% then saved in a folder 'TEXTURES' in the HN WORKSPACE.
% -------------------------------------------------------------------------
% REFERENCE:
% [1] Vallieres, M. et al. (2015). FDG-PET/CT radiomics models for the 
%     early prediction of different tumour outcomes in head and neck cancer.
%     The Journal of Nuclear Medicine, aa(bb), xxx-yyy. 
%     doi:
% [2] Vallieres, M. et al. (2015). A radiomics model from joint FDG-PET and 
%     MRI texture features for the prediction of lung metastases in soft-tissue 
%     sarcomas of the extremities. Physics in Medicine and Biology, 60(14), 
%     5471-5496. doi:10.1088/0031-9155/60/14/5471
% -------------------------------------------------------------------------
% INPUTS:
% 1. pathData: Full path to the HN sData files directory.
%              --> Ex: '/myProject/WORKSPACE/DATA'
% 2. pathNonText: Full path to the HN non texture features directory.
%              --> Ex: '/myProject/WORKSPACE/FEATURES/NON_TEXTURES'
% 3. namePT: Cell of strings of all PET sData files to read
%            --> Ex: {'HGJ_001_PT.PTscan.mat';'HGJ_022_PT.PTscan.mat'}
% 4. namePT: Cell of strings of all CT sData files to read
%            --> Ex: {'HGJ_001_CT.CTscan.mat';'HGJ_022_CT.CTscan.mat'}
% 5. nameROI: Cell of strings specifying the ROI names to analyze for the
%             patients defined by "namePT" and "nameCT"
%             --> Ex: {'GTV';'GTV-P'}
% 6. featType: Either 'GTVp' for primary GTV, or 'GTVtot' for primaty GTV +
%              nodal GTVs
% 7. CTweight_mat: Array vector specifying the different CT weights to test
%                  --> Ex: [1/4,1/3,1/2,2/3,3/4]
% 8. scale_mat: Array vector specifying the different 'Scale' values to test.
%               --> Ex: [1,2,3,4,5]
% 9. Ng_mat: Array vector specifying the different 'Ng' values to test.
%            --> Ex: [8,16,32,64]
% -------------------------------------------------------------------------
% AUTHOR(S): Martin Vallieres <mart.vallieres@gmail.com>
% -------------------------------------------------------------------------
% HISTORY:
% - Creation: March 2016
%--------------------------------------------------------------------------
% STATEMENT:
% This file is part of <https://github.com/mvallieres/radiomics/>, 
% a package providing MATLAB programming tools for radiomics analysis.
% --> Copyright (C) 2015  Martin Vallieres
%
%    This package is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    (at your option) any later version.
%
%    This package is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License
%    along with this package.  If not, see <http://www.gnu.org/licenses/>.
% -------------------------------------------------------------------------

startpath=pwd;

% INITIALIZATION
nPatient = numel(namePT);

% COMPUTATION
fprintf('\n')
for i = 1:nPatient
    cd(pathData)
    sDataPT = load(namePT{i}); sDataPT = struct2cell(sDataPT); sDataPT = sDataPT{1};
    sDataCT = load(nameCT{i}); sDataCT = struct2cell(sDataCT); sDataCT = sDataCT{1};
    tStart = tic;
    fprintf(['\n*********************** COMPUTING TEXTURES: FUSED %s and %s ***********************'],namePT{i},nameCT{i})
    [textures] = calcPatientFusText_HN(sDataPT,sDataCT,nameROI{i},CTweight_mat,scale_mat,algo_cell,Ng_mat);
    ind = strfind(namePT{i},'_'); namePatient = namePT{i}(1:ind(2)-1);
    cd(pathText), save([namePatient,'_PTCT_',featType,'_text'],'textures')
    time = toc(tStart);
    fprintf('TOTAL TIME: %.2f seconds\n',time)
end

cd(startpath)
end