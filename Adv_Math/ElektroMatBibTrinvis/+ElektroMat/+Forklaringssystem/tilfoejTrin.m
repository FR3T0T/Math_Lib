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
    if ~isempty(formel)
        % Konverter almindelig notation til LaTeX
        latex_formel = formel;
        latex_formel = strrep(latex_formel, 'sum_', '\sum_');
        latex_formel = strrep(latex_formel, 'int_', '\int_');
        latex_formel = strrep(latex_formel, 'omega_0', '\omega_0');
        latex_formel = strrep(latex_formel, 'pi', '\pi');
        latex_formel = strrep(latex_formel, 'delta', '\delta');
        latex_formel = strrep(latex_formel, '{-oo}', '{-\infty}');
        latex_formel = strrep(latex_formel, '{oo}', '{\infty}');
        latex_formel = strrep(latex_formel, 'e^(j', 'e^{j');
        latex_formel = strrep(latex_formel, 'e^(-j', 'e^{-j');
        latex_formel = strrep(latex_formel, ' t)', ' t}');
        latex_formel = strrep(latex_formel, '^n', '^{n}');
        latex_formel = strrep(latex_formel, '_n', '_{n}');
        
        % Del formelen op i linjer hvis den indeholder newlines
        formel_linjer = strsplit(latex_formel, '\n');
        for i = 1:length(formel_linjer)
            % ÆNDRET: Brug displayFormula i stedet for disp
            try
                displayFormula(formel_linjer{i});
            catch
                % Fallback til disp hvis displayFormula ikke er tilgængelig
                disp(['   ' formel_linjer{i}]);
            end
        end
    end
    disp(' ');
end