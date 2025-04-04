
        
        function [F, forklaringsOutput] = forklarExpCos(f, t, s, params, forklaringsOutput)
            % Forklaring for dæmpet cosinusfunktion
            a = params.a;
            b = params.b;
            
            forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 2, ...
                'Identificer funktionstypen som en dæmpet cosinusfunktion', ...
                'Funktionen er på formen e^(at)·cos(bt) for konstanter a og b.', ...
                ['f(t) = e^(' char(a) 't) · cos(' char(b) 't)']);
            
            forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 3, ...
                'Brug skiftesætningen (e-reglen)', ...
                ['Hvis vi kend