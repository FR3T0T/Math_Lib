

function [P, forklaringsOutput] = parsevalTeorem_med_forklaring(cn, N)
    % PARSEVALTEOREM_MED_FORKLARING Forklarer Parsevals teorem og beregner signalets effekt
    %
    % Syntax:
    %   [P, forklaringsOutput] = ElektroMatBibTrinvis.parsevalTeorem_med_forklaring(cn, N)
    %
    % Input:
    %   cn - struktur med Fourierkoefficienter
    %   N - maksimalt indekstal for koefficienterne
    % 
    % Output:
    %   P - signalets middeleffekt
    %   forklaringsOutput - Struktur med forklaringstrin
    
    % Starter forklaring
    forklaringsOutput = ElektroMatBibTrinvis.startForklaring('Parsevals Teorem');
    
    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 1, ...
        'Definér Parsevals teorem', ...
        ['Parsevals teorem forbinder effekten beregnet i tidsdomænet med Fourierkoefficienterne:'], ...
        ['(1/T) · ∫ |f(t)|² dt = |c₀|² + ∑ |cₙ|² fra n = -∞ til ∞, n ≠ 0']);
    
    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 2, ...
        'Fortolk Parsevals teorem', ...
        ['Teoremet viser, at middeleffekten af et periodisk signal kan beregnes ved at summere kvadraterne af amplituderne af alle frekvenskomponenter.'], ...
        ['Dette gør det muligt at analysere signalets effektfordeling over forskellige frekvenser.']);
    
    % Beregn effekten
    c0_squared = 0;
    if isfield(cn, 'c0')
        c0_squared = abs(cn.c0)^2;
    end