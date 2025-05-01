function [G, forklaringsOutput] = diffLaplaceMedForklaring(F_s, s, n)
    % Import forklaringssystem functions
    import ElektroMat.Forklaringssystem.*

    % DIFFLAPLACE_MED_FORKLARING Beregner den n'te afledte af en Laplacetransformation med trinvis forklaring
    %
    % Syntax:
    %   [G, forklaringsOutput] = ElektroMatBibTrinvis.diffLaplaceMedForklaring(F_s, s, n)
    %
    % Input:
    %   F_s - Laplacetransformation F(s) (symbolsk udtryk)
    %   s - kompleks variabel (symbolsk)
    %   n - orden af differentiationen
    % 
    % Output:
    %   G - Resulterende funktion G(s) = (-1)^n * d^n/ds^n F(s)
    %   forklaringsOutput - Struktur med forklaringstrin

    % Start forklaring
    forklaringsOutput = ElektroMat.Forklaringssystem.startForklaring(['Differentiering af Laplacetransformation (t^' num2str(n) 'f(t))']);

    % Vis den oprindelige funktion
    forklaringsOutput = ElektroMat.Forklaringssystem.tilfoejTrin(forklaringsOutput, 1, ...
        'Identificer Laplacetransformationen', ...
        'Vi starter med Laplacetransformationen F(s), som vi skal differentiere.', ...
        ['F(s) = ' char(F_s)]);

    forklaringsOutput = ElektroMat.Forklaringssystem.tilfoejTrin(forklaringsOutput, 2, ...
        'Anvend differentieringsreglen', ...
        ['Ifølge differentieringsreglen for Laplacetransformation:'], ...
        ['L{t^' num2str(n) 'f(t)} = (-1)^' num2str(n) ' · d^' num2str(n) '/ds^' num2str(n) ' F(s)']);

    % Beregn den n'te afledte
    for i = 1:n
        if i == 1
            G = -diff(F_s, s);
            forklaringsOutput = ElektroMat.Forklaringssystem.tilfoejTrin(forklaringsOutput, 2+i, ...
                ['Beregn den ' num2str(i) '. afledte'], ...
                ['Vi beregner d/ds F(s):'], ...
                ['d/ds F(s) = ' char(diff(F_s, s)) '\n(-1)^1 · d/ds F(s) = ' char(G)]);
        else
            G = (-1) * diff(G, s);
            forklaringsOutput = ElektroMat.Forklaringssystem.tilfoejTrin(forklaringsOutput, 2+i, ...
                ['Beregn den ' num2str(i) '. afledte'], ...
                ['Vi beregner d^' num2str(i) '/ds^' num2str(i) ' F(s):'], ...
                ['(-1)^' num2str(i) ' · d^' num2str(i) '/ds^' num2str(i) ' F(s) = ' char(G)]);
        end
    end

    % Afslut forklaring
    forklaringsOutput = ElektroMat.Forklaringssystem.afslutForklaring(forklaringsOutput, ...
        ['L{t^' num2str(n) 'f(t)} = ' char(G)]);
end