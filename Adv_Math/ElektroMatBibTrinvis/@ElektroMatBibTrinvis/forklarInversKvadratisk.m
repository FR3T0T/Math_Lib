
        
        function [f, forklaringsOutput] = forklarInversKvadratisk(F, s, t, params, forklaringsOutput)
            % Forklaring for kvadratisk nævner (komplekse rødder)
            a = params.a;
            b = params.b;
            
            forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 2, ...
                'Identificer funktionstypen som en brøk med kvadratisk nævner', ...
                'Funktionen har en nævner på formen (s+a)²+b² med komplekse rødder.', ...
                ['F(s) har nævneren (s+' char(a) ')^2+' char(b) '^2']);
            
            % Tjek om tælleren er s+a eller en konstant
            [num, den] = numden(F);
            
            forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 3, ...
                'Undersøg tællerens form', ...
                'Afhængigt af tællerens form får vi forskellige typer af inverse transformationer.', ...
                'For kvadratiske nævnere kan vi typisk få sinus- eller cosinusfunktioner.');
            
            % Tjek om det er en dæmpet cosinus eller sinus
            if has(num, s+sym(a)) || has(num, s-sym(a))
                forklaringsOutput = ElektroMatBibTrinvis.tilfoejTrin(forklaringsOutput, 4, ...
                    'Genkend