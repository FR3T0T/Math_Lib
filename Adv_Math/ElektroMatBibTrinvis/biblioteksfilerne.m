% Først, check om biblioteksfilerne findes
disp('Undersøger biblioteksfiler...');
dir_info = dir('ElektroMatBibTrinvis');
disp(dir_info);

% Check om +ElektroMat mappen findes
dir_elektromat = dir('+ElektroMat');
disp('+ElektroMat indhold:');
disp(dir_elektromat);

% Prøv at tilføje stierne manuelt
addpath(genpath(pwd));

% Prøv at kalde funktionerne direkte
try
    % Se om vi kan få adgang til klassen direkte
    methods('ElektroMatBibTrinvis')
catch err
    disp('Kunne ikke få adgang til ElektroMatBibTrinvis klassen:');
    disp(err.message);
end

% Prøv at se om vi kan bruge en anden indgangspunkt til biblioteket
try
    % Brug den højniveau-klasse direkte
    syms t s a;
    resultat = ElektroMatBib.laplace(sin(a*t), t, s);
    disp('Resultat fra ElektroMatBib:');
    disp(resultat);
catch err2
    disp('Kunne ikke bruge ElektroMatBib:');
    disp(err2.message);
end