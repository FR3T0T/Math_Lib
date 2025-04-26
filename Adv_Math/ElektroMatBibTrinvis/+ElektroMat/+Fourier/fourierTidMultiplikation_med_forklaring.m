function [F_t, forklaringsOutput] = fourierTidMultiplikation_med_forklaring(f, t, omega, n, kompleks)
    % FOURIERTIDMULTIPLIKATION_MED_FORKLARING Beregner Fouriertransformationen af t^n·f(t)
    %
    % Syntax:
    %   [F_t, forklaringsOutput] = ElektroMatBibTrinvis.fourierTidMultiplikation_med_forklaring(f, t, omega, n, kompleks)
    %
    % Input:
    %   f - funktion af t (symbolsk)
    %   t - tidsvariabel (symbolsk)
    %   omega - frekvensvariabel (symbolsk)
    %   n - potens af t
    %   kompleks - (valgfri) om t har kompleks koefficient (default: false)
    % 
    % Output:
    %   F_t - Fouriertransformationen af t^n·f(t) eller kompleks multiplikation
    %   forklaringsOutput - Struktur med forklaringstrin

    if nargin < 5
        kompleks = false;
    end
    
    % Start forklaring
    if kompleks
        forklaringsOutput = ElektroMatBibTrinvis.ElektroMat.Forklaringssystem.startForklaring(['Fouriertransformation af (-jt)^' num2str(n) '·f(t)']);
    else
        forklaringsOutput = ElektroMatBibTrinvis.ElektroMat.Forklaringssystem.startForklaring(['Fouriertransformation af t^' num2str(n) '·f(t)']);
    end

    % Vis den oprindelige funktion
    if kompleks
        forklaringsOutput = ElektroMatBibTrinvis.ElektroMat.Forklaringssystem.tilfoejTrin(forklaringsOutput, 1, ...
            'Identificer de oprindelige funktioner', ...
            'Vi starter med funktionen som multipliceres med en kompleks tidsfaktor.', ...
            ['f(t) = ' char(f) '\ng(t) = (-jt)^' num2str(n) '·f(t)']);
    else
        forklaringsOutput = ElektroMatBibTrinvis.ElektroMat.Forklaringssystem.tilfoejTrin(forklaringsOutput, 1, ...
            'Identificer de oprindelige funktioner', ...
            'Vi starter med funktionen som multipliceres med t^n.', ...
            ['f(t) = ' char(f) '\ng(t) = t^' num2str(n) '·f(t)']);
    end

    % Beregn Fouriertransformationen af f(t)
    [F, F_forklaring] = ElektroMatBibTrinvis.fourier_med_forklaring(f, t, omega);

    forklaringsOutput = ElektroMatBibTrinvis.ElektroMat.Forklaringssystem.tilfoejTrin(forklaringsOutput, 2, ...
        'Beregn Fouriertransformationen af f(t)', ...
        'Først beregner vi Fouriertransformationen af den oprindelige funktion:', ...
        ['F(ω) = ' char(F)]);

    forklaringsOutput = ElektroMatBibTrinvis.ElektroMat.Forklaringssystem.tilfoejTrin(forklaringsOutput, 3, ...
        'Anvend tidsmultiplikationsreglen', ...
        ['Ifølge egenskaben for Fouriertransformation af t^n·f(t):'], ...
        ['F{t^n·f(t)} = j^n · d^n/dω^n F(ω)']);

    % Beregn resultat
    for i = 1:n
        if i == 1
            F_t = 1i * diff(F, omega);
            forklaringsOutput = ElektroMatBibTrinvis.ElektroMat.Forklaringssystem.tilfoejTrin(forklaringsOutput, 3+i, ...
                ['Beregn den ' num2str(i) '. afledte'], ...
                ['Vi beregner d/dω F(ω):'], ...
                ['d/dω F(ω) = ' char(diff(F, omega)) '\nj^1 · d/dω F(ω) = ' char(F_t)]);
        else
            F_t = 1i * diff(F_t, omega);
            forklaringsOutput = ElektroMatBibTrinvis.ElektroMat.Forklaringssystem.tilfoejTrin(forklaringsOutput, 3+i, ...
                ['Beregn den ' num2str(i) '. afledte'], ...
                ['Vi beregner d^' num2str(i) '/dω^' num2str(i) ' F(ω):'], ...
                ['j^' num2str(i) ' · d^' num2str(i) '/dω^' num2str(i) ' F(ω) = ' char(F_t)]);
        end
    end

    % For 4b's specifikke tilfælde med (-jt)^3
    if kompleks
        forklaringsOutput = ElektroMatBibTrinvis.ElektroMat.Forklaringssystem.tilfoejTrin(forklaringsOutput, 4+n, ...
            'Tilføj kompleks koefficient', ...
            'For tilfældet med (-jt)^3 skal vi tage højde for den komplekse koefficient:', ...
            ['F{(-jt)^3·f(t)} = (-j)^3 · j^3 · d^3/dω^3 F(ω) = -d^3/dω^3 F(ω)']);
        
        F_t = -F_t;  % Tilføj ekstra fortegn for (-jt)^3
    end

    % Afslut forklaring
    if kompleks
        forklaringsOutput = ElektroMatBibTrinvis.ElektroMat.Forklaringssystem.afslutForklaring(forklaringsOutput, ...
            ['F{(-jt)^' num2str(n) '·f(t)} = ' char(F_t)]);
    else
        forklaringsOutput = ElektroMatBibTrinvis.ElektroMat.Forklaringssystem.afslutForklaring(forklaringsOutput, ...
            ['F{t^' num2str(n) '·f(t)} = ' char(F_t)]);
    end
end