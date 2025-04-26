function [F_inv, forklaringsOutput] = fourierAfFourier_med_forklaring(f, t, omega)
    % Import forklaringssystem functions
    import ElektroMat.Forklaringssystem.*

    % FOURIERAFFOURIER_MED_FORKLARING Beregner Fouriertransformationen af F(t)
    %
    % Syntax:
    %   [F_inv, forklaringsOutput] = ElektroMatBibTrinvis.fourierAfFourier_med_forklaring(f, t, omega)
    %
    % Input:
    %   f - funktion af t (symbolsk)
    %   t - tidsvariabel (symbolsk)
    %   omega - frekvensvariabel (symbolsk)
    % 
    % Output:
    %   F_inv - Fouriertransformationen af F(t)
    %   forklaringsOutput - Struktur med forklaringstrin

    % Start forklaring
    forklaringsOutput = ElektroMatBibTrinvis.startForklaring('Fouriertransformation af F(t)');

    % Vis den oprindelige funktion
    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 1, ...
        'Identificer den oprindelige funktion', ...
        'Vi starter med funktionen f(t), hvis Fouriertransformerede vi skal transformere.', ...
        ['f(t) = ' char(f)]);

    % Beregn Fouriertransformationen af f(t)
    [F, F_forklaring] = ElektroMatBibTrinvis.fourier_med_forklaring(f, t, omega);

    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 2, ...
        'Beregn Fouriertransformationen af f(t)', ...
        'Først beregner vi Fouriertransformationen af den oprindelige funktion:', ...
        ['F(ω) = ' char(F)]);

    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 3, ...
        'Anvend egenskaben for Fouriertransformation af Fouriertransformationen', ...
        ['Ifølge egenskaben for Fouriertransformation af Fouriertransformationen:'], ...
        ['F{F(t)} = 2π·f(-ω)']);

    % Beregn resultat - erstat t med -ω i den oprindelige funktion
    f_neg = subs(f, t, -omega);
    F_inv = 2*pi*f_neg;

    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 4, ...
        'Beregn det endelige resultat', ...
        ['Vi indsætter i formlen:'], ...
        ['F{F(t)} = 2π·f(-ω) = 2π·' char(f_neg) ' = ' char(F_inv)]);

    % Afslut forklaring
    forklaringsOutput = ElektroMatBibTrinvis.afslutForklaring(forklaringsOutput, ...
        ['F{F(t)} = ' char(F_inv)]);
end