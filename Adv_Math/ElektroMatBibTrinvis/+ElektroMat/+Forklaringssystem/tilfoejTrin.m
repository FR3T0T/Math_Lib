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
    
    % Hvis formel findes, brug Symbolic Math Toolbox til formatering
    if ~isempty(formel)
        try
            % For forskellige typer input
            if isa(formel, 'sym')
                % Allerede et symbolsk udtryk
                pretty(formel);
            elseif iscell(formel)
                % Cellearray af symbolske udtryk
                for i = 1:length(formel)
                    if isa(formel{i}, 'sym')
                        if i > 1
                            disp(' ');
                        end
                        pretty(formel{i});
                    else
                        disp(['   ' char(formel{i})]);
                    end
                end
            elseif ischar(formel)
                % Konverter tekst streng til symbolsk udtryk hvis muligt
                try
                    % For matematiske udtryk, prøv str2sym
                    if contains(formel, {'=', '+', '-', '*', '/', '^'})
                        symFormel = str2sym(formel);
                        pretty(symFormel);
                    else
                        % For almindelig tekst
                        disp(['   ' formel]);
                    end
                catch
                    % Hvis konvertering fejler
                    disp(['   ' formel]);
                end
            else
                % Andet format
                disp(['   ' char(formel)]);
            end
        catch
            % Fallback hvis symbolsk formatering fejler
            if iscell(formel)
                for i = 1:length(formel)
                    disp(['   ' char(formel{i})]);
                end
            else
                disp(['   ' char(formel)]);
            end
        end
    end
    
    disp(' ');
end