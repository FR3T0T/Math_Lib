% +ElektroMat/+Forklaringssystem/tilfoejTrin.m
function forklaringsOutput = tilfoejTrin(forklaringsOutput, trinNummer, trinTitel, trinTekst, formel)
    % Tilføjer et forklaringstrin med forbedret symbolsk formatering
    
    if nargin < 5
        formel = '';
    end
    
    % Opret trin-struktur
    nytTrin = struct('nummer', trinNummer, 'titel', trinTitel, 'tekst', trinTekst, 'formel', formel);
    
    % Gem den symbolske version hvis relevant
    if isa(formel, 'sym')
        nytTrin.symbolsk = true;
        nytTrin.symbolsk_formel = formel;
    else
        nytTrin.symbolsk = false;
    end
    
    forklaringsOutput.trin{end+1} = nytTrin;
    
    % Vis trin
    disp(['<strong>TRIN ' num2str(trinNummer) ': ' trinTitel '</strong>']);
    disp(trinTekst);
    
    % Hvis formel findes, brug Symbolic Math Toolbox til formatering
    if ~isempty(formel)
        try
            % For forskellige typer input
            if isa(formel, 'sym')
                % Gem i vores liste over symbolske elementer
                forklaringsOutput.symbolske_elementer{end+1} = formel;
                
                % Vis med symbolsk formatering
                disp('Formel:');
                formatSymbolsk(formel);
            elseif iscell(formel)
                % Cellearray af symbolske udtryk
                for i = 1:length(formel)
                    if isa(formel{i}, 'sym')
                        if i > 1
                            disp(' ');
                        end
                        formatSymbolsk(formel{i});
                        forklaringsOutput.symbolske_elementer{end+1} = formel{i};
                    else
                        % Prøv at konvertere streng til symbolsk hvis muligt
                        try
                            symFormel = str2sym(formel{i});
                            formatSymbolsk(symFormel);
                            forklaringsOutput.symbolske_elementer{end+1} = symFormel;
                        catch
                            disp(['   ' char(formel{i})]);
                        end
                    end
                end
            elseif ischar(formel)
                % Konverter tekst streng til symbolsk udtryk hvis muligt
                try
                    % For matematiske udtryk, prøv str2sym
                    if contains(formel, {'=', '+', '-', '*', '/', '^', 'int', 'sum', 'sqrt'})
                        symFormel = str2sym(formel);
                        formatSymbolsk(symFormel);
                        forklaringsOutput.symbolske_elementer{end+1} = symFormel;
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
        catch e
            % Fallback hvis symbolsk formatering fejler
            warning(['Fejl i symbolsk formatering: ' e.message]);
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

function formatSymbolsk(expr)
    % Helper funktion til at formatere symbolske udtryk
    try
        % For komplekse udtryk, brug latex og pæn udskrift
        latexStr = latex(expr);
        
        % Check om dette kører i Live Script miljø hvor vi kan bruge TeX
        if usejava('desktop') && ~isempty(which('matlab.internal.display.isHot')) && matlab.internal.display.isHot
            disp(['$' latexStr '$']);
        else
            % Ellers brug pretty print
            pretty(expr);
        end
    catch
        % Fallback hvis latex fejler
        pretty(expr);
    end
end