% ElektroMatBibTrinvis.m - MATLAB Matematisk Bibliotek med Trinvise Forklaringer
% Dette bibliotek er en udvidelse af ElektroMatBib og tilføjer detaljerede
% trinvise forklaringer til matematiske operationer.
%
% Forfatter: Udvidelse af Frederik Tots' bibliotek
% Version: 1.0
% Dato: 4/4/2025

classdef ElektroMatBibTrinvis
    methods(Static)
        %% FORKLARINGSSYSTEM %%
        forklaringsOutput = startForklaring(titel)
        forklaringsOutput = tilfoejTrin(forklaringsOutput, trinNummer, trinTitel, trinTekst, formel)
        forklaringsOutput = afslutForklaring(forklaringsOutput, resultat)
        
        %% LAPLACE TRANSFORMATIONER MED TRINVISE FORKLARINGER %%
        [F, forklaringsOutput] = laplace_med_forklaring(f, t, s)
        [f, forklaringsOutput] = inversLaplace_med_forklaring(F, s, t)
        
        %% FUNKTIONSANALYSEFUNKTIONER %%
        [ftype, params] = analyserFunktion(f, t)
        [Ftype, params] = analyserLaplaceFunktion(F, s)
        
        %% TRIN-FOR-TRIN FORKLARINGER FOR LAPLACE TRANSFORMATIONER %%
        [F, forklaringsOutput] = forklarKonstant(f, t, s, params, forklaringsOutput)
        [F, forklaringsOutput] = forklarPolynom(f, t, s, params, forklaringsOutput)
        [F, forklaringsOutput] = forklarExp(f, t, s, params, forklaringsOutput)
        [F, forklaringsOutput] = forklarSin(f, t, s, params, forklaringsOutput)
        [F, forklaringsOutput] = forklarCos(f, t, s, params, forklaringsOutput)
        [F, forklaringsOutput] = forklarExpSin(f, t, s, params, forklaringsOutput)
        [F, forklaringsOutput] = forklarExpCos(f, t, s, params, forklaringsOutput)
        forklaringsOutput = forklarGenerel(f, t, s, forklaringsOutput)
        
        %% TRIN-FOR-TRIN FORKLARINGER FOR INVERS LAPLACE TRANSFORMATIONER %%
        [f, forklaringsOutput] = forklarInversKonstant(F, s, t, params, forklaringsOutput)
        [f, forklaringsOutput] = forklarInversSimplePol(F, s, t, params, forklaringsOutput)
        [f, forklaringsOutput] = forklarInversDoublePol(F, s, t, params, forklaringsOutput)
        [f, forklaringsOutput] = forklarInversKvadratisk(F, s, t, params, forklaringsOutput)
        [f, forklaringsOutput] = forklarInversPartielBrok(F, s, t, params, forklaringsOutput)
        forklaringsOutput = forklarInversGenerel(F, s, t, forklaringsOutput)
        
        %% LTI SYSTEM FUNKTIONER MED TRINVISE FORKLARINGER %%
        [num, den, forklaringsOutput] = diffLigningTilOverfoeringsfunktion_med_forklaring(b, a)
        forklaringsOutput = analyserDifferentialligning_med_forklaring(a)
        [t, y, forklaringsOutput] = beregnSteprespons_med_forklaring(num, den, t_range)
        forklaringsOutput = visBodeDiagram_med_forklaring(num, den, omega_range)
        
        %% KOMPLETTE ANALYSERAPPORTER MED TRINVISE FORKLARINGER %%
        kompletSystemAanalyse(num, den, system_navn)
        RLCKredsloebsAnalyse(R, L, C)
        FourierAnalyse(f, t_range, f_navn)
        
        %% FOLDNING OG FOLDNINGSSÆTNING FUNKTIONER %%
        [h, forklaringsOutput] = foldning_med_forklaring(f, g, t, t_range)
        [H, forklaringsOutput] = foldningssaetning_med_forklaring(F, G, s, t)
        
        %% SPECIELLE FUNKTIONER %%
        [F, forklaringsOutput] = deltaFunktion_med_forklaring(t0, t, s)
        [F, forklaringsOutput] = enhedsTrin_med_forklaring(t0, t, s)
        [F, forklaringsOutput] = forsinkelsesRegel_med_forklaring(f_expr, t0, t, s)
        
        %% FOURIERRÆKKE FUNKTIONER %%
        [cn, forklaringsOutput] = fourierKoefficienter_med_forklaring(f, t, T)
        [f_approx, forklaringsOutput] = fourierRaekke_med_forklaring(cn, t, T, N)
        [P, forklaringsOutput] = parsevalTeorem_med_forklaring(cn, N)
        
        %% ENERGI- OG EFFEKTTÆTHEDSFUNKTIONER %%
        [E, forklaringsOutput] = energiTaethed_med_forklaring(F, omega)
        [P, forklaringsOutput] = effektTaethed_med_forklaring(F, omega)
    end
end