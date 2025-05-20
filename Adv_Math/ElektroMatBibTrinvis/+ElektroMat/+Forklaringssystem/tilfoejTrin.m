% +ElektroMat/+Forklaringssystem/tilfoejTrin.m
function forklaringsOutput = tilfoejTrin(forklaringsOutput, trinNummer, trinTitel, trinTekst, formel)
    % Import forklaringssystem functions
    import ElektroMat.Forklaringssystem.*

    % TILFØJTRIN Tilføjer et forklaringstrin til forklaringsoutputtet
    %
    % Syntax:
    %   forklaringsOutput = ElektroMat.Forklaringssystem.tilfoejTrin(forklaringsOutput, trinNummer, trinTitel, trinTekst, formel)
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
    
    % Opret trin-struktur
    nytTrin = struct('nummer', trinNummer, 'titel', trinTitel, 'tekst', trinTekst, 'formel', formel);
    forklaringsOutput.trin{end+1} = nytTrin;
    
    % Vis trin
    disp(['TRIN ' num2str(trinNummer) ': ' trinTitel]);
    disp(trinTekst);
    
    % Vis formlen direkte
    if ~isempty(formel)
        % Del formelen op i linjer hvis den indeholder newlines
        formel_linjer = strsplit(formel, '\n');
        
        for i = 1:length(formel_linjer)
            % Hvis linjen er tom, spring over
            if isempty(formel_linjer{i})
                continue;
            end
            
            % Ren matematikvisning - brug disp
            disp(['   ' formel_linjer{i}]);
        end
    end
    
    disp(' ');
end