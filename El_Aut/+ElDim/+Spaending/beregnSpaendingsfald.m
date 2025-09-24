function [resultat, forklaringsOutput] = beregnSpaendingsfald(U_nom, I, L, cos_phi, A, theta_drift, faser)
    import ElDim.Forklaring.*
    
    forklaringsOutput = startForklaring('Spændingsfald Beregning');
    
    forklaringsOutput = tilfoejTrin(forklaringsOutput, 1, ...
        'Systemparametre', ...
        sprintf('Nominel spænding: %.0f V, Strøm: %.2f A, Kabellængde: %.0f m', U_nom, I, L), ...
        sprintf('cos φ = %.2f, Lederareal: %.1f mm², Driftstemperatur: %.0f°C', cos_phi, A, theta_drift));
    
    % Beregn modstand med temperaturkorrektion
    rho_20 = 0.0178; % Ω⋅mm²/m for kobber
    alpha = 0.00393; % Temperaturkoefficient
    R_theta = (rho_20 / A) * (1 + alpha * (theta_drift - 20));
    
    forklaringsOutput = tilfoejTrin(forklaringsOutput, 2, ...
        'Temperaturkorrektion af modstand', ...
        'Ledermodstanden stiger med temperaturen', ...
        sprintf('R(%.0f°C) = (ρ/A) × (1 + α × ΔT) = %.4f Ω/m', theta_drift, R_theta));
    
    % Reaktans (forenklet)
    sin_phi = sqrt(1 - cos_phi^2);
    X_per_m = 0.1e-3; % Typisk værdi
    
    forklaringsOutput = tilfoejTrin(forklaringsOutput, 3, ...
        'Reaktans og fasevinkelfaktorer', ...
        'Vekselstrøm har både resistive og reaktive komponenter', ...
        sprintf('X ≈ %.4f Ω/m, sin φ = %.3f', X_per_m, sin_phi));
    
    % Beregn spændingsfald
    if faser == 1
        delta_U = 2 * I * L * (R_theta * cos_phi + X_per_m * sin_phi);
        formel = '2 × I × L × (R × cos φ + X × sin φ)';
    else
        delta_U = sqrt(3) * I * L * (R_theta * cos_phi + X_per_m * sin_phi);
        formel = '√3 × I × L × (R × cos φ + X × sin φ)';
    end
    
    delta_U_procent = (delta_U / U_nom) * 100;
    
    forklaringsOutput = tilfoejTrin(forklaringsOutput, 4, ...
        sprintf('Beregn spændingsfald (%d-faset)', faser), ...
        'Spændingsfaldet afhænger af både resistive og reaktive komponenter', ...
        sprintf('ΔU = %s = %.2f V (%.2f%%)', formel, delta_U, delta_U_procent));
    
    % Vurder mod grænseværdier
    grense_belysning = 3;
    grense_kraft = 5;
    
    if delta_U_procent <= grense_belysning
        vurdering = sprintf('OK for belysning (≤%.0f%%) ✓', grense_belysning);
    elseif delta_U_procent <= grense_kraft
        vurdering = sprintf('OK for kraft (≤%.0f%%), IKKE for belysning ⚠', grense_kraft);
    else
        vurdering = 'Overstiger grænseværdier ✗';
    end
    
    forklaringsOutput = tilfoejTrin(forklaringsOutput, 5, ...
        'Sammenlign med standarder', ...
        'DS/HD 60364-5-52 sætter grænser for spændingsfald', ...
        vurdering);
    
    resultat = struct('delta_U_volt', delta_U, 'delta_U_procent', delta_U_procent, 'vurdering', vurdering);
    
    forklaringsOutput = afslutForklaring(forklaringsOutput, ...
        sprintf('Spændingsfald: %.2f V (%.2f%%)', delta_U, delta_U_procent));
end