
        
        function [F, forklaringsOutput] = forklarSin(f, t, s, params, forklaringsOutput)
            % Forklaring for sinusfunktion
            a = params.a;
            
            forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 2, ...
                'Identificer funktionstypen som en sinusfunktion', ...
                'Funktionen er på formen sin(at) for en konstant a.', ...
                ['f(t) = sin(' char(a) 't)']);
            
            forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 3, ...
                'Brug Eulers formel for at omskrive sinus', ...
                'Vi kan udtrykke sinus ved hjælp af komplekse eksponentialfunktioner.', ...
                ['sin(' char(a) 't) = (e^(i·' char(a) 't) - e^(-i·' char(a) 't))/(2i)']);
            
            forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 4, ...
                'Anvend