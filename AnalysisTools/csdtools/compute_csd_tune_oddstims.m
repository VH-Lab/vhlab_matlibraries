function thedata = compute_csd_tune2(csd,stiminds,name1, name2)

% COMPUTER_CSD_TUNE2 - Computes mean/stderr/stddev and comparisons for csd structs
%
%  DATA = COMPUTE_CSD_TUNE2(CSD,STIMINDS,NAME1,NAME2)
%
%   Computes mean, standard error, standard deviation, and statistical comparisons
%   for each channel in a CSD structure.  CSD structure is assumed to be an array
%   [NUMSTIMS]x[NUMCHANNELS] of structures, and each structure must have numeric
%   entries named NAME1{i} and NAME2{i}.  STIMINDS is a cell list of stimuli to average over.
%   Each cell of STIMINDS contains a vector of stimuli numbers to to average together.
%   NAME1 and NAME2 are cell lists of numeric names.
%
%   DATA is a [LENGTH NAME1 x 1]  structure with the following entries:
%
%   mn      - mean of NAME1 for each channel and stimulus (NUM_CHANSxNUM_UNIQUE_STIMS)
%   stderr  - standard error of same
%   stdev   - standard deviation of same
%   mn2     - mean of NAME2 in same format
%   stderr2 - standard error of mn2
%   stdev2  - standard deviation of mn2
%   kw      - kruskal-wallis p value of comparison between mn1 and mn2 using individual trials
%   tt      - t-test2 p value of comparison between mn1 and mn2 using individual trials

data.mn = zeros(size(csd,2),length(stiminds));
data.stderr = zeros(size(csd,2),length(stiminds));
data.stdev = zeros(size(csd,2),length(stiminds));

data.mn2 = zeros(size(csd,2),length(stiminds));
data.stderr2 = zeros(size(csd,2),length(stiminds));
data.stdev2 = zeros(size(csd,2),length(stiminds));

for n = 1:length(name1),
  resps = {};
  resps2 = {};
  for k=1:size(csd,2),
	for i=1:length(stiminds),
		resps{k,i} = [];
		resps2{k,i} = [];
		for j=1:length(stiminds{i}),
            %name1{n},
            %getfield(csd(stiminds{i}(j),k),name1{n}),
			resps{k,i} = cat(2,resps{k,i},getfield(csd(stiminds{i}(j),k),name1{n}));
			resps2{k,i} = cat(2,resps2{k,i},getfield(csd(stiminds{i}(j),k),name2{n}));
		end;
		data.mn(k,i) = mean(resps{k,i});
		data.stderr(k,i) = stderr(resps{k,i}');
		data.stdev(k,i) = std(resps{k,i});
		data.mn2(k,i) = mean(resps2{k,i});
		data.stderr2(k,i) = stderr(resps2{k,i}');
		data.stdev2(k,i) = std(resps2{k,i});

		data.kw(k,i) = kruskal_wallis_test(resps{k,i},resps2{k,i});
		[dummy,data.tt(k,i)] = ttest2(resps{k,i},resps2{k,i},0.05,'both');
		thedata(n) = data;
	end;
  end;
end;


