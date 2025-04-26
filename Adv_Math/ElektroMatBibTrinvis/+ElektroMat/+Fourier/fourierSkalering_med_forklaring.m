function [F_scaled, forklaringsOutput] = fourierSkaleringMedForklaring(f, t, omega, a, b)
    % Import forklaringssystem functions
    import ElektroMat.Forklaringssystem.*

    % FOURIERSKALERING_MED_FORKLARING Beregner Fouriertransformationen af f(at-b)
    %
    % Syntax:
    %   [F_scaled, forklaringsOutput] = ElektroMatBibTrinvis.fourierSkaleringMedForklaring(f, t, omega, a, b)
    %
    % Input:
    %   f - funktion af t (symbolsk)
    %   t - tidsvariabel (symbolsk)
    %   omega - frekvensvariabel (symbolsk)
    %   a - skaleringsfaktor
    %   b - forskydning
    % 
    % Output:
    %   F_scaled - Fouriertransformationen af f(at-b)
    %   forklaringsOutput - Struktur med forklaringstrin

    % Start forklaring
    forklaringsOutput = ElektroMatBibTrinvis.startForklaring(['Fouriertransformation af f(' num2str(a) 't-' num2str(b) ')']);

    % Vis den oprindelige funktion
    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 1, ...
        'Identificer den oprindelige funktion', ...
        'Vi starter med funktionen, der skal skaleres og forskydes.', ...
        ['f(t) = ' char(f) '\ng(t) = f(' num2str(a) 't-' num2str(b) ')']);

    % Beregn Fouriertransformationen af f(t)
    [F, F_forklaring] = ElektroMatBibTrinvis.fourierMedForklaring(f, t, omega);

    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 2, ...
        'Beregn Fouriertransformationen af f(t)', ...
        'Først beregner vi Fouriertransformationen af den oprindelige funktion:', ...
        ['F(ω) = ' char(F)]);

    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 3, ...
        'Anvend skaleringsegenskaben', ...
        ['Ifølge skaleringsegenskaben for Fouriertransformation:'], ...
        ['F{f(at)} = (1/|a|) · F(ω/a)']);

    % Anvend skalering
    F_scaled = (1/abs(a)) * subs(F, omega, omega/a);

    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 4, ...
        'Beregn Fouriertransformationen af skalerede funktion', ...
        ['Vi anvender skaleringsegenskaben:'], ...
        ['F{f(' num2str(a) 't)} = (1/' num2str(abs(a)) ') · F(ω/' num2str(a) ') = ' char(F_scaled)]);

    if b ~= 0
        forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 5, ...
            'Anvend forskydningsegenskaben', ...
            ['Ifølge forskydningsegenskaben for Fouriertransformation:'], ...
            ['F{f(t-t_0)} = e^(-jωt_0) · F(ω)']);
        
        % Anvend forskydning
        t0 = b/a;  % Transformation til standard forskydningsform
        F_scaled = F_scaled * exp(-1i*omega*t0);
        
        forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 6, ...
            'Beregn Fouriertransformationen af forskudt funktion', ...
            ['Vi anvender forskydningsegenskaben med t_0 = ' num2str(b) '/' num2str(a) ':'], ...
            ['F{f(' num2str(a) 't-' num2str(b) ')} = e^(-jω·' num2str(t0) ') · ' char(F_scaled) ' = ' char(F_scaled)]);
    end

    % Afslut forklaring
    forklaringsOutput = ElektroMatBibTrinvis.afslutForklaring(forklaringsOutput, ...
        ['F{f(' num2str(a) 't-' num2str(b) ')} = ' char(F_scaled)]);
end