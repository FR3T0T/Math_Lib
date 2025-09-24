function forklaringsOutput = startForklaring(titel)
    forklaringsOutput = struct();
    forklaringsOutput.titel = titel;
    forklaringsOutput.trin = {};
    forklaringsOutput.dato = datestr(now);
    forklaringsOutput.resultat = '';
    
    fprintf('\n===== %s =====\n', upper(titel));
    fprintf('Startet: %s\n\n', forklaringsOutput.dato);
end

% +ElDim/+Forklaring/tilfoejTrin.m  
function forklaringsOutput = tilfoejTrin(forklaringsOutput, trinNr, titel, forklaring, beregning)
    if nargin < 5
        beregning = '';
    end
    
    nytTrin = struct('nummer', trinNr, 'titel', titel, 'forklaring', forklaring, 'beregning', beregning);
    forklaringsOutput.trin{end+1} = nytTrin;
    
    fprintf('TRIN %d: %s\n', trinNr, titel);
    fprintf('%s\n', forklaring);
    if ~isempty(beregning)
        fprintf('Beregning: %s\n', beregning);
    end
    fprintf('\n');
end