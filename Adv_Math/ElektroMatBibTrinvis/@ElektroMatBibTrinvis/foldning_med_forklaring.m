

function [h, forklaringsOutput] = foldning_med_forklaring(f, g, t, t_range)
    % FOLDNING_MED_FORKLARING Beregner foldningen af to funktioner med trinvis forklaring
    %
    % Syntax:
    %   [h, forklaringsOutput] = ElektroMatBibTrinvis.foldning_med_forklaring(f, g, t, t_range)
    %
    % Input:
    %   f - første funktion som symbolsk udtryk eller function handle
    %   g - anden funktion som symbolsk udtryk eller function handle
    %   t - tidsvariabel (symbolsk)
    %   t_range - [t_min, t_max] interval for numerisk beregning
    % 
    % Output:
    %   h - resultatet af foldningen
    %   forklaringsOutput - Struktur med forklaringstrin
    
    % Starter forklaring
    forklaringsOutput = ElektroMatBibTrinvis.startForklaring('Foldning af Funktioner');
    
    % Vis de oprindelige funktioner
    if isa(f, 'function_handle')
        f_str = func2str(f);
    else
        f_str = char(f);
    end