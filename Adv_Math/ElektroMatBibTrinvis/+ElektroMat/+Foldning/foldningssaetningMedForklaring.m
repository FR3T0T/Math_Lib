function [H, forklaringsOutput] = foldningssaetningMedForklaring(F, G, s, t)
    % Import forklaringssystem functions
    import ElektroMat.Forklaringssystem.*

    % FOLDNINGSSAETNING_MED_FORKLARING Demonstrerer foldningssætningen med trinvis forklaring
    %
    % Syntax:
    %   [H, forklaringsOutput] = ElektroMatBibTrinvis.foldningssaetningMedForklaring(F, G, s, t)
    %
    % Input:
    %   F - første Laplacetransformation som symbolsk udtryk
    %   G - anden Laplacetransformation som symbolsk udtryk
    %   s - Laplace-variabel (symbolsk)
    %   t - tidsvariabel (symbolsk)
    % 
    % Output:
    %   H - produktet F(s)·G(s)
    %   forklaringsOutput - Struktur med forklaringstrin
    
    % Starter forklaring
    forklaringsOutput = ElektroMat.Forklaringssystem.startForklaring('Foldningssætningen for Laplacetransformation');
    
    forklaringsOutput = ElektroMat.Forklaringssystem.tilfoejTrin(forklaringsOutput, 1, ...
        'Identificer Laplacetransformationerne', ...
        'Vi starter med de to Laplace-transformerede funktioner.', ...
        ['F(s) = ' char(F) '\nG(s) = ' char(G)]);
    
    forklaringsOutput = ElektroMat.Forklaringssystem.tilfoejTrin(forklaringsOutput, 2, ...
        'Forklar foldningssætningen', ...
        'Foldningssætningen siger, at produktet af to Laplacetransformationer svarer til Laplacetransformationen af foldningen af de oprindelige funktioner.', ...
        'L{(f * g)(t)} = F(s) · G(s)');
    
    forklaringsOutput = ElektroMat.Forklaringssystem.tilfoejTrin(forklaringsOutput, 3, ...
        'Beregn produktet af Laplacetransformationerne', ...
        'Vi beregner produktet F(s) · G(s).', ...
        ['H(s) = F(s) · G(s) = ' char(F) ' · ' char(G)]);
    
    % Beregn produktet
    H = F * G;
    H_simplified = simplify(H);
    
    forklaringsOutput = ElektroMat.Forklaringssystem.tilfoejTrin(forklaringsOutput, 4, ...
        'Simplifiser resultatet', ...
        'Vi forenkler udtrykket om muligt.', ...
        ['H(s) = ' char(H_simplified)]);
    
    % Find den inverse Laplacetransformation
    try
        h = ElektroMatBib.inversLaplace(H_simplified, s, t);
        h_str = char(h);
        
        forklaringsOutput = ElektroMat.Forklaringssystem.tilfoejTrin(forklaringsOutput, 5, ...
            'Find den tilsvarende foldning i tidsdomænet', ...
            'Ved at anvende invers Laplacetransformation på H(s) finder vi den tilsvarende foldning i tidsdomænet.', ...
            ['h(t) = L^(-1){H(s)} = (f * g)(t) = ' h_str]);
    catch
        forklaringsOutput = ElektroMat.Forklaringssystem.tilfoejTrin(forklaringsOutput, 5, ...
            'Find den tilsvarende foldning i tidsdomænet', ...
            'Den inverse Laplacetransformation kan være kompleks og kræve yderligere algebraiske manipulationer.', ...
            'h(t) = L^(-1){H(s)} = (f * g)(t)');
    end
    
    % Afslut
    forklaringsOutput = ElektroMat.Forklaringssystem.afslutForklaring(forklaringsOutput, ...
        ['H(s) = ' char(H_simplified)]);
end