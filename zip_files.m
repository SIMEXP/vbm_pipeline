function [in,out,opt] = zip_files(in)
% [IN,OUT,OPT] = SPM_BRICK_DERIVATIVES(IN,OUT,OPT)
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


%% Brick starts here

%Get the directory of the file
[nii_files_dir,_,_] = fileparts(in);

%Get output files 
out_files =vertcat(glob([nii_files_dir '/smwrc1acpc_*']), glob([nii_files_dir '/rc*acpc_*']));

%zip the nifti files
for j = 1: numel(out_files)
        gzip(out_files{j},nii_files_dir);
end

%Get remaining nii files 
nii_files = glob([nii_files_dir '/*.nii']);

%delete nii files
for j = 1: numel(nii_files)
	delete(nii_files{j});
end

