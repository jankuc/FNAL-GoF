classdef leptonJetVar < uint8
  % LeptonJet variable map 1..25 -> 'Apla','Spher',...
  %   leptonJetVar(1).toString == leptonJetType.Apla == 'Apla'
  
  enumeration
    Apla (1),
    Spher (2),
    HTL (3),
    JetMt (4),
    HT3 (5),
    MEvent (6),
    MT1NL (7),
    M01mall (8),
    M0nl (9),
    M1nl (10)
    Mt0nl (11)
    Met (12),
    Mtt (13),
    Mva_max (14),
    Wmt (15)
    Wpt (16),
    Centr (17),
    DRminejet (18),
    DiJetDrmin (19),
    Ht (20),
    Ht20 (21),
    Ktminp (22),
    Lepdphimet (23), 
    Lepemv (24),
    Jetm (25)
  end
  methods
    function str = toString(obj)
      str = char(obj);
    end
  end
  methods(Static)
    function all = getAll()
      % returns vector of all types without data
      n = leptonJetVar.numTypes;
      all(n,1) = leptonJetVar(n);
      for k = 1:n-1
        all(k) = leptonJetVar(k);
      end
    end
    function n = numTypes()
      n = 25;
    end
  end
end

