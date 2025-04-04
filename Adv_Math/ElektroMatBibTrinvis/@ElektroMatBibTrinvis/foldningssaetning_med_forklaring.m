

function [H, forklaringsOutput] = foldningssaetning_med_forklaring(F, G, s, t)
    % FOLDNINGSSAETNING_MED_FORKLARING Demonstrerer foldningssætningen med trinvis forklaring
    %
    % Syntax:
    %   [H, forklaringsOutput] = ElektroMatBibTrinvis.foldningssaetning_med_forklaring(F, G, s, t)
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
    forklaringsOutput = ElektroMatBibTrinvis.startForklaring('Foldningssætningen for Laplacetransformation');
    
    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 1, ...
        'Identificer Laplacetransformationerne', ...
        'Vi starter med de to Laplace-transformerede funktioner.', ...
        ['F(s) = ' char(F) '\nG(s) = ' char(G)]);
    
    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 2, ...
        'Forklar foldningssætningen', ...
        'Foldningssætningen siger, at produktet af to Laplacetransformationer svarer til Laplacetransformationen af foldningen af de oprindelige funktioner.', ...
        'L{(f * g)(t)} = F(s) · G(s)');
    
    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 3, ...
        'Beregn produktet af Laplacetransformationerne', ...
        'Vi beregner produktet F(s) · G(s).', ...
        ['H(s) = F(s) · G(s) = ' char(F) ' · ' char(G)]);
    
    % Beregn produktet
    H = F * G;
    H_simplified = simplify(H);
    
    forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 4, ...
        'Simplifiser resultatet', ...
        'Vi forenkler udtrykket om muligt.', ...
        ['H(s) = ' char(H_simplified)]);
    
    % Find den inverse Laplacetransformation
    try
        h = ElektroMatBib.inversLaplace(H_simplified, s, t);
        h_str = char(h);
        
        forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 5, ...
            'Find den tilsvarend