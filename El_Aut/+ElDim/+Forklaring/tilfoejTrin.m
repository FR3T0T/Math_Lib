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