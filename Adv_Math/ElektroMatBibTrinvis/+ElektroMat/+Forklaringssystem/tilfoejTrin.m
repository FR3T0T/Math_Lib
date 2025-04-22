function forklaringsOutput = tilfoejTrin(forklaringsOutput, trinNummer, trinTitel, trinTekst, formel)
    % TILFØJTRIN Tilføjer et forklaringstrin til forklaringsoutputtet
    %
    % Syntax:
    %   forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, trinNummer, trinTitel, trinTekst, formel)
    %
    % Input:
    %   forklaringsOutput - Forklaringsoutput-struktur
    %   trinNummer - Nummer på trinet
    %   trinTitel - Overskrift for trinet
    %   trinTekst - Forklaringstekst for trinet
    %   formel - (valgfri) Matematisk formel
    
    if nargin < 5
        formel = '';
    end
    
    % Sikre at formel er en streng (håndter symbolske udtryk)
    if ~ischar(formel) && ~isempty(formel)
        try
            % Brug den nye hjælpefunktion til at konvertere symbolske udtryk
            formel = symbolToString(formel);
        catch
            formel = char(formel);
        end
        
        % Søg efter eventuelle resterende symbolske udtryk i formlen
        if ischar(formel)
            patternSymbolic = '\${[a-zA-Z0-9_]+}';
            [matches, starts] = regexp(formel, patternSymbolic, 'match', 'start');
            for i = 1:length(matches)
                symbolName = matches{i}(3:end-1);
                try
                    symbolVal = eval(['sym(' symbolName ')']);
                    symbolStr = symbolToString(symbolVal);
                    formel = strrep(formel, matches{i}, symbolStr);
                catch
                    % Ignorer fejl hvis symbolet ikke kan evalueres
                end
            end
        end
    end
    
    % Opret trin-struktur
    nytTrin = struct('nummer', trinNummer, 'titel', trinTitel, 'tekst', trinTekst, 'formel', formel);
    forklaringsOutput.trin{end+1} = nytTrin;
    
    % Vis trin
    disp(['TRIN ' num2str(trinNummer) ': ' trinTitel]);
    disp(trinTekst);
    if ~isempty(formel)
        disp(['   ' formel]);
    end
    disp(' ');
end