function [P, forklaringsOutput] = effektTaethed_med_forklaring(F, omega)
    % EFFEKTTAETHED_MED_FORKLARING Beregner og forklarer effekttæthedsspektrum
    %
    % Syntax:
    %   [P, forklaringsOutput] = ElektroMatBibTrinvis.effektTaethed_med_forklaring(F, omega)
    %
    % Input:
    %   F - Fouriertransformeret periodisk signal eller amplitudevektor af Fourierkoefficienter
    %   omega - frekvensvariabel eller frekvensvektor for numerisk beregning
    % 
    % Output:
    %   P - effekttæthedsspektrum
    %   forklaringsOutput - Struktur med forklaringstrin
    
    % Starter forklaring
    forklaringsOutput = ElektroMatBibTrinvis.ElektroMat.Forklaringssystem.startForklaring('Effekttæthedsspektrum');
    
    forklaringsOutput = ElektroMatBibTrinvis.ElektroMat.Forklaringssystem.tilfoejTrin(forklaringsOutput, 1, ...
        'Definér effekttæthedsspektrum', ...
        ['Effekttæthedsspektret for et periodisk signal kan defineres på to måder:'], ...
        ['1. Ved hjælp af Fourierkoefficienter: Φ_p(ω) = ∑ |cₙ|² · δ(ω - nω₀)\n' ...
        '2. Ved hjælp af grænsen af energitæthedsspektret: Φ_p(ω) = lim(T→∞) (1/T) · |F_T(ω)|²/π']);
    
    if isnumeric(F) && isnumeric(omega)
        % Numerisk beregning
        forklaringsOutput = ElektroMatBibTrinvis.ElektroMat.Forklaringssystem.tilfoejTrin(forklaringsOutput, 2, ...
            'Numerisk beregning', ...
            ['Vi har amplituder for Fourierkoefficienter givet numerisk.'], ...
            ['Beregner |cₙ|² for alle harmoniske.']);
        
        % Antag at F indeholder amplituder af Fourierkoefficienter
        P = abs(F).^2;
        
        % Total effekt
        P_total = sum(P);
        
        forklaringsOutput = ElektroMatBibTrinvis.ElektroMat.Forklaringssystem.tilfoejTrin(forklaringsOutput, 3, ...
            'Beregn total effekt', ...
            ['Den totale effekt i signalet er summen af effektbidragene fra alle harmoniske:'], ...
            ['P = ∑ |cₙ|² = ' num2str(P_total)]);
    else
        % Symbolsk tilgang
        forklaringsOutput = ElektroMatBibTrinvis.ElektroMat.Forklaringssystem.tilfoejTrin(forklaringsOutput, 2, ...
            'Teoretisk tilgang', ...
            ['For et periodisk signal har effekttæthedsspektret diskrete værdier ved harmoniske frekvenser.'], ...
            ['Spektret består af Dirac-impulser ved frekvenserne nω₀.']);
        
        forklaringsOutput = ElektroMatBibTrinvis.ElektroMat.Forklaringssystem.tilfoejTrin(forklaringsOutput, 3, ...
            'Fourierkoefficienters relation til effekt', ...
            ['Effekten i den n-te harmoniske er givet ved |cₙ|².'], ...
            ['Den totale effekt i signalet er summen P = |c₀|² + 2·∑ |cₙ|² for n > 0']);
        
        % Vi kan ikke beregne symbolsk uden mere information
        P = sym('P_effekt');
    end
    
    forklaringsOutput = ElektroMatBibTrinvis.ElektroMat.Forklaringssystem.tilfoejTrin(forklaringsOutput, 4, ...
        'Fortolk effekttæthedsspektrum', ...
        ['Effekttæthedsspektret viser, hvordan signalets middeleffekt er fordelt over forskellige frekvenser.'], ...
        ['For periodiske signaler er effekten koncentreret ved de harmoniske frekvenser nω₀.']);
    
    forklaringsOutput = ElektroMatBibTrinvis.ElektroMat.Forklaringssystem.tilfoejTrin(forklaringsOutput, 5, ...
        'Forskel mellem energi- og effekttæthedsspektrum', ...
        ['Energispektret bruges til signaler med endelig energi, mens effektspektret bruges til periodiske signaler.'], ...
        ['Et periodisk signal har uendelig energi, men endelig middeleffekt.']);
    
    % Afslut
    forklaringsOutput = ElektroMatBibTrinvis.ElektroMat.Forklaringssystem.afslutForklaring(forklaringsOutput, ...
        'Effekttæthedsspektrum er beregnet.');
    
    % Visualiser hvis data er numerisk
    if isnumeric(F) && isnumeric(omega)
        figure;
        stem(omega, P, 'filled', 'LineWidth', 2);
        grid on;
        title('Effekttæthedsspektrum');
        xlabel('Frekvens (rad/s)');
        ylabel('|cₙ|²');
    end
end