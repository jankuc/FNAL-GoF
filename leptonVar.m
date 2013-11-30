classdef leptonVar < uint8
  % SIGNALTYPE map 1..13 -> 'diboson','tb',...
  %   leptonJetType(5).toString == leptonJetType.QCD == 'QCD'
  
  enumeration
    Apia (1),
    Spher (2),
    HTL (3),
    JetMt (4),
    HT3 (5),
    MEvent (6),
    MT1NL (7),
    Wcc (8),
    Wlp (9),
    WW (10)
    WZ (11)
    MeT (12),
    Mtt (13),
    ZccEE (14),
    ZccTauTau (15)
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
      all(n,1) = leptonVar(n);
      for k = 1:n-1
        all(k) = leptonVar(k);
      end
    end
    function n = numTypes()
      n = 18;
    end
  end
end

