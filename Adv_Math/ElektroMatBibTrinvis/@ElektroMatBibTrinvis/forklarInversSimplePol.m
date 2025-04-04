
        
        function [f, forklaringsOutput] = forklarInversSimplePol(F, s, t, params, forklaringsOutput)
            % Forklaring for simpel pol
            pol = params.pol;
            
            forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 2, ...
                'Identificer funktionstypen som en brøk med en simpel pol', ...
                'Funktionen har en simpel pol i s-planen.', ...
                ['F(s) = 1/(s-(' char(pol) '))']);
            
            forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 3, ...
                'Brug standardformlen for simple poler', ...
                'Vi kan anvend