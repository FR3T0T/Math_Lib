function [F_int, forklaringsOutput] = fourierIntegral_med_forklaring(f, t, omega)
    % FOURIERINTEGRAL_MED_FORKLARING Beregner Fouriertransformationen af ∫_{-∞}^{t} f(τ)dτ
    %
    % Syntax:
    %   [F_int, forklaringsOutput] = ElektroMatBibTrinvis.fourierIntegral_med_forklaring(f, t, omega)
    %
    % Input:
    %   f - funktion af t (symbolsk)
    %   t - tidsvariabel (symbolsk)
    %   omega - frekvensvariabel (symbolsk)
    % 
    % Output:
    %   F_int - Fouriertransformationen af ∫_{-∞}^{t} f(τ)dτ
    %   forklaringsOutput - Struktur med forklaringstrin

    % Start forklaring
    forklaringsOutput = ElektroMatBibTrinvis.ElektroMat.Forklaringssystem.startForklaring('Fouriertransformation af integral');

    % Vis den oprindelige funktion
    forklaringsOutput = ElektroMatBibTrinvis.ElektroMat.Forklaringssystem.tilfoejTrin(forklaringsOutput, 1, ...
        'Identificer den oprindelige funktion', ...
        'Vi starter med funktionen, der skal integreres.', ...
        ['f(t) = ' char(f) '\ng(t) = ∫_{-∞}^{t} f(τ)dτ']);

    % Beregn Fouriertransformationen af f(t)
    [F, F_forklaring] = ElektroMatBibTrinvis.fourier_med_forklaring(f, t, omega);

    forklaringsOutput = ElektroMatBibTrinvis.ElektroMat.Forklaringssystem.tilfoejTrin(forklaringsOutput, 2, ...
        'Beregn Fouriertransformationen af f(t)', ...
        'Først beregner vi Fouriertransformationen af den oprindelige funktion:', ...
        ['F(ω) = ' char(F)]);

    forklaringsOutput = ElektroMatBibTrinvis.ElektroMat.Forklaringssystem.tilfoejTrin(forklaringsOutput, 3, ...
        'Anvend integralreglen', ...
        ['Ifølge egenskaben for Fouriertransformation af integralet:'], ...
        ['F{∫_{-∞}^{t} f(τ)dτ} = F(ω)/(jω) + πF(0)δ(ω)']);

    % Beregn værdien ved ω = 0, hvis muligt
    try
        F0 = limit(F, omega, 0);
        forklaringsOutput = ElektroMatBibTrinvis.ElektroMat.Forklaringssystem.tilfoejTrin(forklaringsOutput, 4, ...
            'Beregn F(0)', ...
            ['Vi beregner grænseværdien af F(ω) når ω → 0:'], ...
            ['F(0) = ' char(F0)]);
    catch
        F0 = sym('F(0)');
        forklaringsOutput = ElektroMatBibTrinvis.ElektroMat.Forklaringssystem.tilfoejTrin(forklaringsOutput, 4, ...
            'Beregn F(0)', ...
            ['F(0) kan ikke beregnes symbolsk, men er nødvendig for resultatet.'], ...
            ['Vi betegner det som F(0).']);
    end

    % Beregn resultat
    F_int = F/(1i*omega) + pi*F0*dirac(omega);

    forklaringsOutput = ElektroMatBibTrinvis.ElektroMat.Forklaringssystem.tilfoejTrin(forklaringsOutput, 5, ...
        'Beregn det endelige resultat', ...
        ['Vi indsætter i formlen:'], ...
        ['F{∫_{-∞}^{t} f(τ)dτ} = ' char(F) '/(jω) + π·' char(F0) '·δ(ω) = ' char(F_int)]);

    % Afslut forklaring
    forklaringsOutput = ElektroMatBibTrinvis.ElektroMat.Forklaringssystem.afslutForklaring(forklaringsOutput, ...
        ['F{∫_{-∞}^{t} f(τ)dτ} = ' char(F_int)]);
end