function [out] = loadLocalConfig( confFile )
%LOADLOCALCONFIG Summary of this function goes here
%   Detailed explanation goes here

	out.dir.muo = -1;
	out.dir.ele = -1;
	
	str = xml2struct(confFile);
	
	K = size(str.Children,2);
	names = cell(K,1);
	for k = 1:K
		names{k} = str.Children(k);
	end
	
	for k = 1:K
		if strcmp(names{k}.Name,'muo')
			out.dir.muo = names{k}.Children.Data;
		end
		if strcmp(names{k}.Name,'ele')
			out.dir.ele = names{k}.Children.Data;
		end
	end
end

