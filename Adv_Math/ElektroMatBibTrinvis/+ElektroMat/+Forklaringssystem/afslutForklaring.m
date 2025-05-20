% +ElektroMat/+Forklaringssystem/afslutForklaring.m
function forklaringsOutput = afslutForklaring(forklaringsOutput, resultat)
    % Import forklaringssystem functions
    import ElektroMat.Forklaringssystem.*

    % AFSLUTFORKLARING Afslutter en forklaring med et resultat
    %
    % Syntax:
    %   forklaringsOutput = ElektroMat.Forklaringssystem.afslutForklaring(forklaringsOutput, resultat)
    %
    % Input:
    %   forklaringsOutput - Forklaringsoutput-struktur
    %   resultat - Slutresultat (tekst eller symbolsk)
    
    if ischar(resultat)
        forklaringsOutput.resultat = resultat;
    else
        forklaringsOutput.resultat = char(resultat);
    end
    
    % Formatér resultat med LaTeX for pænere display i Live Scripts
    latex_resultat = forklaringsOutput.resultat;
    latex_resultat = strrep(latex_resultat, 'sum_', '\sum_');
    latex_resultat = strrep(latex_resultat, 'int_', '\int_');
    latex_resultat = strrep(latex_resultat, 'omega_0', '\omega_0');
    latex_resultat = strrep(latex_resultat, 'pi', '\pi');
    latex_resultat = strrep(latex_resultat, 'delta', '\delta');
    latex_resultat = strrep(latex_resultat, '{-oo}', '{-\infty}');
    latex_resultat = strrep(latex_resultat, '{oo}', '{\infty}');
    latex_resultat = strrep(latex_resultat, 'e^(j', 'e^{j');
    latex_resultat = strrep(latex_resultat, 'e^(-j', 'e^{-j');
    latex_resultat = strrep(latex_resultat, ' t)', ' t}');
    latex_resultat = strrep(latex_resultat, '^n', '^{n}');
    latex_resultat = strrep(latex_resultat, '_n', '_{n}');
    
    % Del på linjer hvis der er \n
    resultat_linjer = strsplit(latex_resultat, '\n');
    
    % Vis resultat
    disp('RESULTAT:');
    for i = 1:length(resultat_linjer)
        disp(['   $' resultat_linjer{i} '$']);
    end
    disp(' ');
    disp(['===== AFSLUTTET: ' upper(forklaringsOutput.titel) ' =====']);
    disp(' ');
end