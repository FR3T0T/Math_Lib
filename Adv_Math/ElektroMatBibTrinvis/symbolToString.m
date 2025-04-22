function str = symbolToString(sym_var)
    % SYMBOLTOSTRING Konverterer en symbolsk variabel til en streng på en robust måde
    % Denne funktion sikrer konsistent konvertering gennem hele biblioteket
    
    if isempty(sym_var)
        str = '';
        return;
    end
    
    if isa(sym_var, 'sym')
        try
            % Forsøg at konvertere til numerisk værdi med 4 decimaler hvis muligt
            numeric_val = double(sym_var);
            if ~isnan(numeric_val)
                if numeric_val == round(numeric_val)
                    % Heltal
                    str = num2str(numeric_val);
                else
                    % Decimaltal
                    str = num2str(numeric_val, '%.4f');
                    % Fjern efterstillede nuller
                    str = regexprep(str, '0+$', '');
                    str = regexprep(str, '\.$', '');
                end
            else
                % Hvis ikke numerisk, så brug normal char konvertering
                str = char(sym_var);
            end
        catch
            % Fallback til standard konvertering
            str = char(sym_var);
        end
    elseif isnumeric(sym_var)
        if sym_var == round(sym_var)
            % Heltal
            str = num2str(sym_var);
        else
            % Decimaltal
            str = num2str(sym_var, '%.4f');
            % Fjern efterstillede nuller
            str = regexprep(str, '0+$', '');
            str = regexprep(str, '\.$', '');
        end
    else
        % For alle andre typer
        str = char(sym_var);
    end
end