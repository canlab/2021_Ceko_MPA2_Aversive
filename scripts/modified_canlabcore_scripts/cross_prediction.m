function [yh, pearson]=cross_prediction(dat,subject,stimulus,varargin)

% Cross-prediction of data in an fmri_data obj
%
% Usage:
% ::
%
%    [yh, pearson]=cross_prediction(dat,subject,stimulus)
%
% This is a method for an fmri_data object that constructs predictive
% models conditional on a grouping variable (stimulus).
% A variant of leave-one-subject-out cross validation is performed,where
% data from all but one subject are used for training, only different
% models are trained for each stimulus type. These separate models are each
% applied to one subject that is held out for testing on each fold. The
% output is the cross-validated prediction outcome for each model and an
% associated correlation matrix.
%
% ..
%     Author and copyright information:
%
%     Copyright (C) 2018 Phil Kragel
%
%     This program is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
%
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
%
%     You should have received a copy of the GNU General Public License
%     along with this program.  If not, see <http://www.gnu.org/licenses/>.
% ..
%
% :Inputs:
%
%   **dat:**
%        An image object with one or more images loaded and accompanying
%        outcomes specified in dat.Y
%
%   **subject:**
%        an integer valued vector specifying the subject for
%        each row of dat.dat
%
%   **stimulus:**
%        an integer valued vector specifying the stimulus type for
%        each row of dat.dat
%
% :Optional inputs:
%
% :Outputs:
%
%   **yh:**
%        matrix of predicted outcomes: each row corresponds to an
%        observation being predicted and each column the 
%   **pearson:**
%        nstim x stim matrix of correlations. Rows correspond to the type 
%        of stimulus being tested, columns correspond to the stimulus used 
%        for training.
%
% :Examples:
% ::
% :See also:
%

% ..
%    Programmers' notes:
%    2/15/2018 - Written by Phil Kragel
% ..
% ..
% DEFAULTS AND INPUTS
% ..

subjs=unique(subject); %unique subject values
stims=unique(stimulus); %unique stimulus type values (this could be any way of splitting the data)

yh=zeros(length(subject),length(stims)); %initialize outcome
pearson=zeros(length(stims)); %cross correlation matrix

for s=1:length(subjs) % 5-fold or %LOSO

    for st=1:length(stims) %training within each stimulus
          
    train=subject~=subjs(s) & stimulus==stims(st); %train on one modality, test on all for hold-out subject
    test=subject==subjs(s);
        
    tv=dat;
    tv.dat=tv.dat(:,train);
    tv.Y=tv.Y(train);
    
    %[cverr, stats, optout] = predict(tv, 'algorithm_name', 'cv_lassopcr', 'nfolds', 1, 'error_type', 'mse');
    [cverr, stats, optout] = predict(tv, 'algorithm_name', 'cv_lassopcr', 'nfolds', rem(subject(train),5)+1, 'error_type', 'mse');    


    %[~, ~, optout] = predict(tv, 'algorithm_name', 'cv_lassopcr', 'nfolds',1,varargin);
    yh(test,st)=dat.dat(:,test)'*optout{1}+optout{2};
    
    end
    
    
    for st=1:length(stims) %training for each stimulus --setting other modalities to zero--
        
    train=subject~=subjs(s); 
    test=subject==subjs(s);
        
    tv=dat;
    tv.dat=tv.dat(:,train);
    tv.Y(stimulus~=stims(st))=0; %set outcomes for other stimuli to 0
    tv.Y=tv.Y(train);    
    
    %[~, ~, optout] = predict(tv, 'algorithm_name', 'cv_lassopcr', 'nfolds', 1, 'error_type', 'mse');
    [~, ~, optout] = predict(tv, 'algorithm_name', 'cv_lassopcr', 'nfolds', rem(subject(train),5)+1, 'error_type', 'mse');

    %[~, ~, optout] = predict(tv, 'algorithm_name', 'cv_lassopcr', 'nfolds',1,varargin);
    yh(test,length(stims)+st)=dat.dat(:,test)'*optout{1}+optout{2};
    
    end
     
    
    train=subject~=subjs(s); %train on all modalities, test on all for hold-out subject (or splits)
    test=subject==subjs(s);
        
    tv=dat;
    tv.dat=tv.dat(:,train);
    tv.Y=tv.Y(train);
    
    %[cverr, stats, optout] = predict(tv, 'algorithm_name', 'cv_lassopcr', 'nfolds', 1, 'error_type', 'mse');
    [cverr, stats, optout] = predict(tv, 'algorithm_name', 'cv_lassopcr', 'nfolds', rem(subject(train),5)+1, 'error_type', 'mse');

    %[~, ~, optout] = predict(tv, 'algorithm_name', 'cv_lassopcr', 'nfolds',1,varargin);
    yh(test,2*length(stims)+1)=dat.dat(:,test)'*optout{1}+optout{2}; %add another column to yh where stim type is ignored
  
    
end

%% cross-prediction correlation
for j=1:size(yh,2) %train on each stim separately, then on all stims
    for i=1:length(stims)  %test
        pearson(i,j)=corr(yh(stimulus==i,j),dat.Y(stimulus==i));
    end
    
    pearson(i+1,j)=corr(yh(:,j),dat.Y);
end
