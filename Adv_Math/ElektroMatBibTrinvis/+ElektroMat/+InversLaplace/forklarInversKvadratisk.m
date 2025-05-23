function [f, forklaringsOutput] = forklarInversKvadratisk(F, s, t, params, forklaringsOutput)
    % Import forklaringssystem functions
    import ElektroMat.Forklaringssystem.*

    % Forklaring for kvadratisk nævner (komplekse rødder)
    a = params.a;
    b = params.b;
    
    forklaringsOutput = ElektroMat.Forklaringssystem.tilfoejTrin(forklaringsOutput, 2, ...
        'Identificer funktionstypen som en brøk med kvadratisk nævner', ...
        'Funktionen har en nævner på formen (s+a)²+b² med komplekse rødder.', ...
        ['F(s) har nævneren (s+' char(a) ')^2+' char(b) '^2']);
    
    % Tjek om tælleren er s+a eller en konstant
    [num, den] = numden(F);
    
    forklaringsOutput = ElektroMat.Forklaringssystem.tilfoejTrin(forklaringsOutput, 3, ...
        'Undersøg tællerens form', ...
        'Afhængigt af tællerens form får vi forskellige typer af inverse transformationer.', ...
        'For kvadratiske nævnere kan vi typisk få sinus- eller cosinusfunktioner.');
    
    % Tjek om det er en dæmpet cosinus eller sinus
    if has(num, s+sym(a)) || has(num, s-sym(a))
        forklaringsOutput = ElektroMat.Forklaringssystem.tilfoejTrin(forklaringsOutput, 4, ...
            'Genkend mønstret for dæmpet cosinus', ...
            ['Hvis F(s) = (s+a)/((s+a)²+b²), så er den inverse transformation en dæmpet cosinus.'], ...
            ['L^(-1){(s+a)/((s+a)^2+b^2)} = e^(-at)cos(bt)']);
        
        % Resultat
        f = exp(-a*t)*cos(b*t);
        forklaringsOutput = ElektroMat.Forklaringssystem.tilfoejTrin(forklaringsOutput, 5, ...
            'Formuler det endelige resultat', ...
            'Den inverse Laplacetransformation er en dæmpet cosinusfunktion.', ...
            ['f(t) = e^(-' char(a) 't)cos(' char(b) 't) for t ≥ 0']);
    else
        forklaringsOutput = ElektroMat.Forklaringssystem.tilfoejTrin(forklaringsOutput, 4, ...
            'Genkend mønstret for dæmpet sinus', ...
            ['Hvis F(s) = b/((s+a)²+b²), så er den inverse transformation en dæmpet sinus.'], ...
            ['L^(-1){b/((s+a)^2+b^2)} = e^(-at)sin(bt)']);
        
        % Resultat
        f = exp(-a*t)*sin(b*t);
        forklaringsOutput = ElektroMat.Forklaringssystem.tilfoejTrin(forklaringsOutput, 5, ...
            'Formuler det endelige resultat', ...
            'Den inverse Laplacetransformation er en dæmpet sinusfunktion.', ...
            ['f(t) = e^(-' char(a) 't)sin(' char(b) 't) for t ≥ 0']);
    end
    
    return;
end