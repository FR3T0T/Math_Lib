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
    
    % Formatér matematiske formler med LaTeX 
    % Relevante dele for visning af formler:
    if ~isempty(formel)
        % Del formelen op i linjer hvis den indeholder newlines
        formel_linjer = strsplit(formel, '\n');
        for i = 1:length(formel_linjer)
            % Konverter til LaTeX
            latex_formel = formatUtils.konverterTilLatex(formel_linjer{i});
            
            % Brug displayFormula - indbygget i Live Script (INGEN popup-vinduer!)
            try
                displayFormula(latex_formel);
            catch
                % Fallback til almindelig tekst hvis displayFormula ikke findes
                disp(['   ' formel_linjer{i}]);
            end
        end
    end
    disp(' ');
end