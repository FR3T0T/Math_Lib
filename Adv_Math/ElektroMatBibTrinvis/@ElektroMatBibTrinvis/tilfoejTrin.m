
        
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