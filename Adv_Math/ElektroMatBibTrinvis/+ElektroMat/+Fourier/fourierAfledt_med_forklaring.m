function [F_d, forklaringsOutput] = fourierAfledt_med_forklaring(f, t, omega, n)
    % FOURIERAFLEDT_MED_FORKLARING Beregner Fouriertransformationen af n'te afledte
    %
    % Syntax:
    %   [F_d, forklaringsOutput] = ElektroMatBibTrinvis.fourierAfledt_med_forklaring(f, t, omega, n)
    %
    % Input:
    %   f - funktion af t (symbolsk)
    %   t - tidsvariabel (symbolsk)
    %   omega - frekvensvariabel (symbolsk)
    %   n - orden af differentiation
    % 
    % Output:
    %   F_d - Fouriertransformationen af d^n/dt^n f(t)
    %   forklaringsOutput - Struktur med forklaringstrin

    % Start forklaring
    forklaringsOutput = ElektroMatBibTrinvis.startForklaring(['Fouriertransformation af ' num2str(n) '. afledte']);

    % Vis den oprindelige funktion
    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 1, ...
        'Identificer den oprindelige funktion', ...
        'Vi starter med funktionen, hvis afledte vi skal transformere.', ...
        ['f(t) = ' char(f)]);

    % Beregn Fouriertransformationen af f(t)
    [F, F_forklaring] = ElektroMatBibTrinvis.fourier_med_forklaring(f, t, omega);

    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 2, ...
        'Beregn Fouriertransformationen af f(t)', ...
        'Først beregner vi Fouriertransformationen af den oprindelige funktion:', ...
        ['F(ω) = ' char(F)]);

    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 3, ...
        'Anvend differentieringsreglen', ...
        ['Ifølge egenskaben for Fouriertransformation af afledte:'], ...
        ['F{d^n/dt^n f(t)} = (jω)^n · F{f(t)}']);

    % Beregn resultat
    F_d = (1j*omega)^n * F;
    F_d_simpel = simplify(F_d);

    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 4, ...
        'Beregn det endelige resultat', ...
        ['Vi indsætter i formlen:'], ...
        ['F{d^' num2str(n) '/dt^' num2str(n) ' f(t)} = (jω)^' num2str(n) ' · ' char(F) ' = ' char(F_d_simpel)]);

    % Afslut forklaring
    forklaringsOutput = ElektroMatBibTrinvis.afslutForklaring(forklaringsOutput, ...
        ['F{d^' num2str(n) '/dt^' num2str(n) ' f(t)} = ' char(F_d_simpel)]);
end