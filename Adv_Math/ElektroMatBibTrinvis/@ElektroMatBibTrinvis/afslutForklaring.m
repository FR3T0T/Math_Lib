
        
        function forklaringsOutput = afslutForklaring(forklaringsOutput, resultat)
            % AFSLUTFORKLARING Afslutter en forklaring med et resultat
            %
            % Syntax:
            %   forklaringsOutput = ElektroMatBibTrinvis.afslutForklaring(forklaringsOutput, resultat)
            %
            % Input:
            %   forklaringsOutput - Forklaringsoutput-struktur
            %   resultat - Slutresultat (tekst eller symbolsk)
            
            if ischar(resultat)
                forklaringsOutput.resultat = resultat;
            else
                forklaringsOutput.resultat = char(resultat);
            end