classdef ElDimensioneringCalculator
    methods(Static)
        %% KABELDIMENSIONERING
        function [resultat, forklaring] = dimensionerKabel(Ib, In, Ca, Cg, Ci, kabeltype)
            [resultat, forklaring] = ElDim.Kabel.dimensionerKabel(Ib, In, Ca, Cg, Ci, kabeltype);
        end
        
        %% SIKRINGSBEREGNING
        function [resultat, forklaring] = beregnSikring(Ib, In, Iz, sikringstype)
            [resultat, forklaring] = ElDim.Sikring.beregnSikring(Ib, In, Iz, sikringstype);
        end
        
        %% SPÆNDINGSFALD
        function [resultat, forklaring] = beregnSpaendingsfald(U_nom, I, L, cos_phi, A, theta_drift, faser)
            [resultat, forklaring] = ElDim.Spaending.beregnSpaendingsfald(U_nom, I, L, cos_phi, A, theta_drift, faser);
        end
        
        %% KOMPLET ANALYSE
        function kompletAnalyse(Ib, In, kabeltype, L, cos_phi, theta_drift, U_nom, faser)
            fprintf('=== KOMPLET EL-DIMENSIONERING ANALYSE ===\n\n');
            
            % Standard værdier
            Ca = 1.0; Cg = 1.0; Ci = 1.0;
            
            % 1. Kabeldimensionering
            [kabel_resultat, kabel_forklaring] = ElDimensioneringCalculator.dimensionerKabel(Ib, In, Ca, Cg, Ci, kabeltype);
            
            if strcmp(kabel_resultat.areal, 'FEJL')
                fprintf('ANALYSE STOPPET: Ingen kabel kan klare belastningen!\n');
                return;
            end
            
            A = str2double(kabel_resultat.areal);
            Iz = kabel_resultat.Iz;
            
            % 2. Sikringsberegning
            [sikring_resultat, sikring_forklaring] = ElDimensioneringCalculator.beregnSikring(Ib, In, Iz, 1);
            
            % 3. Spændingsfald
            [spaending_resultat, spaending_forklaring] = ElDimensioneringCalculator.beregnSpaendingsfald(U_nom, Ib, L, cos_phi, A, theta_drift, faser);
            
            % Sammenfatning
            fprintf('=== SAMMENFATNING ===\n');
            fprintf('Kabelareal: %s mm² (Iz = %.1f A)\n', kabel_resultat.areal, Iz);
            fprintf('Sikring: %.0f A - %s\n', In, kabel_resultat.status);
            fprintf('Spændingsfald: %.2f%% - %s\n', spaending_resultat.delta_U_procent, spaending_resultat.vurdering);
            
            if sikring_resultat.resultat && contains(spaending_resultat.vurdering, '✓')
                fprintf('\n✓ INSTALLATION OK - Alle krav opfyldt\n');
            else
                fprintf('\n✗ INSTALLATION KRÆVER JUSTERING\n');
            end
        end
    end
end

% Hjælpefunktion
function str = tf2str(tf_val)
    if tf_val
        str = '✓ OK';
    else
        str = '✗ IKKE OK';
    end
end