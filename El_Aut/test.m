%% EKSEMPEL 1: Enkelt kabeldimensionering med trinvis forklaring
fprintf('=== EKSEMPEL 1: KABELDIMENSIONERING ===\n');

% Parametre
Ib = 16;        % Driftsstrøm [A]
In = 20;        % Sikringsstrøm [A]
Ca = 0.94;      % Temperaturkorrektion
Cg = 0.8;       % Grupperingsfaktor
Ci = 1.0;       % Isolationsfaktor
kabeltype = 1;  % NYM kabel

% Kald funktionen
[kabel_resultat, kabel_forklaring] = ElDimensioneringCalculator.dimensionerKabel(Ib, In, Ca, Cg, Ci, kabeltype);

% Resultatet er nu tilgængeligt
fprintf('Valgt kabelareal: %s mm²\n', kabel_resultat.areal);
fprintf('Belastningsevne: %.1f A\n', kabel_resultat.Iz);