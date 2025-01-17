function [in,out,opt] = spm_brick_derivatives(in,out,opt)
% [IN,OUT,OPT] = SPM_BRICK_DERIVATIVES(IN,OUT,OPT)
%
% Extract derivatives (TIV GMA)of an image, gzip final images and clean up all intermediat images
%
% IN (structure, with the followings fields):
%   IMG (string, optional) filename of an image
%   MASK (string, optional) a 3D mask of the brain
%   TEMPLATE (string, optional) a 3D map with the relevant parcels
%   GM  (string, default [rc1 IN]) the grey matter aligned to a common space to use with DARTEL
%   WM (string, default [rc2 IN]) the white matter,aligned to a common space to use with DARTEL
%   CSF (string, default [rc3 IN]) cerebrospinal fluid, aligned to a common space to use with DARTEL
%
% OUT (structure, with the following fields):
%   CSV (output file where to save the derivatives)
%
% OPT (structure, with the following fields):
%   FOLDER_OUT (string, default same as IN) the folder where to generate outputs
%   FLAG_TEST (boolean, default false) flag to run a test without generating outputs
%
% _________________________________________________________________________
% Copyright (c) Christian Dansereau
% Perceiv Research Inc., 2019
% Maintainer : christian@perceiv.ai
% See licensing information in the code.
% Keywords : SPM, interface% Permission is hereby granted, free of charge, to any person obtaining a copy
% of this software and associated documentation files (the "Software"), to deal
% in the Software without restriction, including without limitation the rights
% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
% copies of the Software, and to permit persons to whom the Software is
% furnished to do so, subject to the following conditions:
%
% The above copyright notice and this permission notice shall be included in
% all copies or substantial portions of the Software.
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
% THE SOFTWARE.
global gb_psom_name_job
%% Syntax checks
if ~exist('in','var')||~exist('opt','var')
    error('spm:brick','syntax: [IN,OUT,OPT] = SPM_BRICK_GET_DERIVATIVES(IN,OUT,OPT).\n Type ''help spm_brick_derivatives'' for more info.')
end%% Input
if ~isstruct(in)
  error('IN should be a structure')
end
if opt.flag_test == 1
    return
end%%%%%%%%%%%%%%%
%% Brick starts here


%%%%%%%%%%%% TIV %%%%
% Get header info and read the volume
hdr = spm_vol(fullfile(in.gm));
[vol_gm, ~] = spm_read_vols(hdr);% Get header info and read the volume
hdr = spm_vol(fullfile(in.wm));
[vol_wm, ~] = spm_read_vols(hdr);% Get header info and read the volume
hdr = spm_vol(fullfile(in.csf));
[vol_csf, ~] = spm_read_vols(hdr);
tiv = sum(sum(sum(vol_gm))) + sum(sum(sum(vol_wm))) + sum(sum(sum(vol_csf)));

%%%% GMA %%%%
% Get header info and read the volume
hdr = spm_vol(fullfile(in.mask));
[vol_mask, ~] = spm_read_vols(hdr);
vol_mask = (vol_mask(:,:,:,1) > 0)

hdr = spm_vol(fullfile(in.img));
[vol_img, ~] = spm_read_vols(hdr);
vol_img = vol_img(vol_mask); 

gma =(mean(mean(mean(vol_img))))

mat_tmp = [gma,tiv]% save in csv

opt_tmp.labels_y = {'GMA' 'TIV'};
opt_tmp.labels_x ={opt.subj_id};

niak_write_csv(out,mat_tmp,opt_tmp)

%%%%% gzip and cleanup %%%%%

%Get the directory of the file
[nii_files_dir,_,_] = fileparts(in.img);

%Get output files
out_files  = struct2cell(in);

%gzip the nifti files
for j = 1: numel(out_files)
        gzip(out_files{j},nii_files_dir);
end

%Get remaining nii files
nii_files = glob([nii_files_dir '/*.nii']);

%delete nii files
for j = 1: numel(nii_files)
	delete(nii_files{j});
end
