classdef leptonJetType < uint8
  % SIGNALTYPE map 1..13 -> 'diboson','tb',...
  %   leptonJetType(5).toString == leptonJetType.QCD == 'QCD'
  
  enumeration
    data (1),
    QCD (2),
    tb (3),
    tqb (4),
    ttA_172 (5),
    ttAll_172 (6),
    Wbb (7),
    Wcc (8),
    Wlp (9),
    WW (10),
    WZ (11),
    ZbbEE (12),
    ZbbTauTau (13),
    ZccEE (14),
    ZccTauTau (15),
    ZlpEE (16),
    ZlpTauTau (17),
    ZZ (18)
  end
  methods
    function str = toString(obj)
      str = char(obj);
    end
  end
  methods(Static)
    function all = getAll()
      % returns vector of all types without data
      n = 18;
      all(n,1) = leptonJetType(n);
      for k = 1:n-1
        all(k) = leptonJetType(k);
      end
    end
    function n = numTypes()
      n = 18;
    end
  end
end

