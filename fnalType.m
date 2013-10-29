classdef fnalType < uint8
	% SIGNALTYPE map 1..13 -> 'diboson','tb',...
	%   fnalType(5).toString == fnalType.ttbar_lepjets == 'ttbar-lepjets'
	
	enumeration 
		diboson (1),
		QCD (2),
		tb (3),
		tqb (4),
		ttbar_dilepton (5),
		ttbar_lepjets (6),
		wbb (7), 
		wcc (8),
		wlp (9),
		zbb (10),
		zcc (11),
		zlp (12),
		DATA (13),
	end
	methods
		function str = toString(obj)
			if ~(obj == fnalType(5) || obj == fnalType(6))
				str = char(obj);
			elseif obj == fnalType(5)
				str = 'ttbar-dilepton';
			else
				str = 'ttbar-lepjets';
			end
		end
	end
	methods(Static)
		function all = getAll()
% returns vector of all types without data
			n = 12;
			all(n,1) = fnalType(n);
			for k = 1:n-1
				all(k) = fnalType(k);
			end
			
		end
	end
end

