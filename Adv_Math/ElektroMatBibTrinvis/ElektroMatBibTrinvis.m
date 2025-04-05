% ElektroMatBibTrinvis.m - MATLAB Matematisk Bibliotek med Trinvise Forklaringer
% Dette bibliotek er en udvidelse af ElektroMatBib og tilføjer detaljerede
% trinvise forklaringer til matematiske operationer.
%
% Udvikler: Frederik Tots
% Version: 2.0
% Dato: 4/4/2025

classdef ElektroMatBibTrinvis
    methods(Static)
        %% FORKLARINGSSYSTEM %%
        function forklaringsOutput = startForklaring(titel)
            forklaringsOutput = ElektroMat.Forklaringssystem.startForklaring(titel);
        end
        
        function forklaringsOutput = tilfoejTrin(forklaringsOutput, trinNummer, trinTitel, trinTekst, formel)
            if nargin < 5
                forklaringsOutput = ElektroMat.Forklaringssystem.tilfoejTrin(forklaringsOutput, trinNummer, trinTitel, trinTekst);
            else
                forklaringsOutput = ElektroMat.Forklaringssystem.tilfoejTrin(forklaringsOutput, trinNummer, trinTitel, trinTekst, formel);
            end
        end
        
        function forklaringsOutput = afslutForklaring(forklaringsOutput, resultat)
            forklaringsOutput = ElektroMat.Forklaringssystem.afslutForklaring(forklaringsOutput, resultat);
        end
        
        %% LAPLACE TRANSFORMATIONER MED TRINVISE FORKLARINGER %%
        function [F, forklaringsOutput] = laplace_med_forklaring(f, t, s)
            [F, forklaringsOutput] = ElektroMat.Laplace.laplace_med_forklaring(f, t, s);
        end
        
        function [f, forklaringsOutput] = inversLaplace_med_forklaring(F, s, t)
            [f, forklaringsOutput] = ElektroMat.InversLaplace.inversLaplace_med_forklaring(F, s, t);
        end
        
        %% NYE LAPLACE FUNKTIONER (UDVIDELSE) %%
        function [y, forklaringsOutput] = beregnUdgangssignal_med_forklaring(H_s, X_s, s, t)
            [y, forklaringsOutput] = ElektroMat.LTI_Systemer.beregnUdgangssignal_med_forklaring(H_s, X_s, s, t);
        end
        
        function [G, forklaringsOutput] = diffLaplace_med_forklaring(F_s, s, n)
            [G, forklaringsOutput] = ElektroMat.Laplace.diffLaplace_med_forklaring(F_s, s, n);
        end
        
        %% FOURIER TRANSFORMATIONER MED TRINVISE FORKLARINGER (NYE) %%
        function [F, forklaringsOutput] = fourier_med_forklaring(f, t, omega)
            [F, forklaringsOutput] = ElektroMat.Fourier.fourier_med_forklaring(f, t, omega);
        end
        
        function [F_d, forklaringsOutput] = fourierAfledt_med_forklaring(f, t, omega, n)
            [F_d, forklaringsOutput] = ElektroMat.Fourier.fourierAfledt_med_forklaring(f, t, omega, n);
        end
        
        function [F_t, forklaringsOutput] = fourierTidMultiplikation_med_forklaring(f, t, omega, n, kompleks)
            if nargin < 5
                [F_t, forklaringsOutput] = ElektroMat.Fourier.fourierTidMultiplikation_med_forklaring(f, t, omega, n);
            else
                [F_t, forklaringsOutput] = ElektroMat.Fourier.fourierTidMultiplikation_med_forklaring(f, t, omega, n, kompleks);
            end
        end
        
        function [F_scaled, forklaringsOutput] = fourierSkalering_med_forklaring(f, t, omega, a, b)
            [F_scaled, forklaringsOutput] = ElektroMat.Fourier.fourierSkalering_med_forklaring(f, t, omega, a, b);
        end
        
        function [F_int, forklaringsOutput] = fourierIntegral_med_forklaring(f, t, omega)
            [F_int, forklaringsOutput] = ElektroMat.Fourier.fourierIntegral_med_forklaring(f, t, omega);
        end
        
        function [F_inv, forklaringsOutput] = fourierAfFourier_med_forklaring(f, t, omega)
            [F_inv, forklaringsOutput] = ElektroMat.Fourier.fourierAfFourier_med_forklaring(f, t, omega);
        end
        
        %% FUNKTIONSANALYSEFUNKTIONER %%
        function [ftype, params] = analyserFunktion(f, t)
            [ftype, params] = ElektroMat.Funktionsanalyse.analyserFunktion(f, t);
        end
        
        function [Ftype, params] = analyserLaplaceFunktion(F, s)
            [Ftype, params] = ElektroMat.Funktionsanalyse.analyserLaplaceFunktion(F, s);
        end
        
        %% TRIN-FOR-TRIN FORKLARINGER FOR LAPLACE TRANSFORMATIONER %%
        function [F, forklaringsOutput] = forklarKonstant(f, t, s, params, forklaringsOutput)
            [F, forklaringsOutput] = ElektroMat.Laplace.forklarKonstant(f, t, s, params, forklaringsOutput);
        end
        
        function [F, forklaringsOutput] = forklarPolynom(f, t, s, params, forklaringsOutput)
            [F, forklaringsOutput] = ElektroMat.Laplace.forklarPolynom(f, t, s, params, forklaringsOutput);
        end
        
        function [F, forklaringsOutput] = forklarExp(f, t, s, params, forklaringsOutput)
            [F, forklaringsOutput] = ElektroMat.Laplace.forklarExp(f, t, s, params, forklaringsOutput);
        end
        
        function [F, forklaringsOutput] = forklarSin(f, t, s, params, forklaringsOutput)
            [F, forklaringsOutput] = ElektroMat.Laplace.forklarSin(f, t, s, params, forklaringsOutput);
        end
        
        function [F, forklaringsOutput] = forklarCos(f, t, s, params, forklaringsOutput)
            [F, forklaringsOutput] = ElektroMat.Laplace.forklarCos(f, t, s, params, forklaringsOutput);
        end
        
        function [F, forklaringsOutput] = forklarExpSin(f, t, s, params, forklaringsOutput)
            [F, forklaringsOutput] = ElektroMat.Laplace.forklarExpSin(f, t, s, params, forklaringsOutput);
        end
        
        function [F, forklaringsOutput] = forklarExpCos(f, t, s, params, forklaringsOutput)
            [F, forklaringsOutput] = ElektroMat.Laplace.forklarExpCos(f, t, s, params, forklaringsOutput);
        end
        
        function forklaringsOutput = forklarGenerel(f, t, s, forklaringsOutput)
            forklaringsOutput = ElektroMat.Laplace.forklarGenerel(f, t, s, forklaringsOutput);
        end
        
        %% TRIN-FOR-TRIN FORKLARINGER FOR INVERS LAPLACE TRANSFORMATIONER %%
        function [f, forklaringsOutput] = forklarInversKonstant(F, s, t, params, forklaringsOutput)
            [f, forklaringsOutput] = ElektroMat.InversLaplace.forklarInversKonstant(F, s, t, params, forklaringsOutput);
        end
        
        function [f, forklaringsOutput] = forklarInversSimplePol(F, s, t, params, forklaringsOutput)
            [f, forklaringsOutput] = ElektroMat.InversLaplace.forklarInversSimplePol(F, s, t, params, forklaringsOutput);
        end
        
        function [f, forklaringsOutput] = forklarInversDoublePol(F, s, t, params, forklaringsOutput)
            [f, forklaringsOutput] = ElektroMat.InversLaplace.forklarInversDoublePol(F, s, t, params, forklaringsOutput);
        end
        
        function [f, forklaringsOutput] = forklarInversKvadratisk(F, s, t, params, forklaringsOutput)
            [f, forklaringsOutput] = ElektroMat.InversLaplace.forklarInversKvadratisk(F, s, t, params, forklaringsOutput);
        end
        
        function [f, forklaringsOutput] = forklarInversPartielBrok(F, s, t, params, forklaringsOutput)
            [f, forklaringsOutput] = ElektroMat.InversLaplace.forklarInversPartielBrok(F, s, t, params, forklaringsOutput);
        end
        
        function forklaringsOutput = forklarInversGenerel(F, s, t, forklaringsOutput)
            forklaringsOutput = ElektroMat.InversLaplace.forklarInversGenerel(F, s, t, forklaringsOutput);
        end
        
        %% LTI SYSTEM FUNKTIONER MED TRINVISE FORKLARINGER %%
        function [num, den, forklaringsOutput] = diffLigningTilOverfoeringsfunktion_med_forklaring(b, a)
            [num, den, forklaringsOutput] = ElektroMat.LTI_Systemer.diffLigningTilOverfoeringsfunktion_med_forklaring(b, a);
        end
        
        function forklaringsOutput = analyserDifferentialligning_med_forklaring(a)
            forklaringsOutput = ElektroMat.LTI_Systemer.analyserDifferentialligning_med_forklaring(a);
        end
        
        function [t, y, forklaringsOutput] = beregnSteprespons_med_forklaring(num, den, t_range)
            [t, y, forklaringsOutput] = ElektroMat.LTI_Systemer.beregnSteprespons_med_forklaring(num, den, t_range);
        end
        
        function forklaringsOutput = visBodeDiagram_med_forklaring(num, den, omega_range)
            forklaringsOutput = ElektroMat.LTI_Systemer.visBodeDiagram_med_forklaring(num, den, omega_range);
        end
        
        %% KOMPLETTE ANALYSERAPPORTER MED TRINVISE FORKLARINGER %%
        function kompletSystemAanalyse(num, den, system_navn)
            if nargin < 3
                ElektroMat.KompletteAnalyser.kompletSystemAanalyse(num, den);
            else
                ElektroMat.KompletteAnalyser.kompletSystemAanalyse(num, den, system_navn);
            end
        end
        
        function RLCKredsloebsAnalyse(R, L, C)
            ElektroMat.KompletteAnalyser.RLCKredsloebsAnalyse(R, L, C);
        end
        
        function FourierAnalyse(f, t_range, f_navn)
            if nargin < 3
                ElektroMat.KompletteAnalyser.FourierAnalyse(f, t_range);
            else
                ElektroMat.KompletteAnalyser.FourierAnalyse(f, t_range, f_navn);
            end
        end
        
        %% FOLDNING OG FOLDNINGSSÆTNING FUNKTIONER %%
        function [h, forklaringsOutput] = foldning_med_forklaring(f, g, t, t_range)
            [h, forklaringsOutput] = ElektroMat.Foldning.foldning_med_forklaring(f, g, t, t_range);
        end
        
        function [H, forklaringsOutput] = foldningssaetning_med_forklaring(F, G, s, t)
            [H, forklaringsOutput] = ElektroMat.Foldning.foldningssaetning_med_forklaring(F, G, s, t);
        end
        
        %% SPECIELLE FUNKTIONER %%
        function [F, forklaringsOutput] = deltaFunktion_med_forklaring(t0, t, s)
            [F, forklaringsOutput] = ElektroMat.SpecielleFunktioner.deltaFunktion_med_forklaring(t0, t, s);
        end
        
        function [F, forklaringsOutput] = enhedsTrin_med_forklaring(t0, t, s)
            [F, forklaringsOutput] = ElektroMat.SpecielleFunktioner.enhedsTrin_med_forklaring(t0, t, s);
        end
        
        function [F, forklaringsOutput] = forsinkelsesRegel_med_forklaring(f_expr, t0, t, s)
            [F, forklaringsOutput] = ElektroMat.SpecielleFunktioner.forsinkelsesRegel_med_forklaring(f_expr, t0, t, s);
        end
        
        %% FOURIERRÆKKE FUNKTIONER %%
        function [cn, forklaringsOutput] = fourierKoefficienter_med_forklaring(f, t, T)
            [cn, forklaringsOutput] = ElektroMat.Fourier.fourierKoefficienter_med_forklaring(f, t, T);
        end
        
        function [f_approx, forklaringsOutput] = fourierRaekke_med_forklaring(cn, t, T, N)
            [f_approx, forklaringsOutput] = ElektroMat.Fourier.fourierRaekke_med_forklaring(cn, t, T, N);
        end
        
        function [P, forklaringsOutput] = parsevalTeorem_med_forklaring(cn, N)
            [P, forklaringsOutput] = ElektroMat.Fourier.parsevalTeorem_med_forklaring(cn, N);
        end
        
        %% ENERGI- OG EFFEKTTÆTHEDSFUNKTIONER %%
        function [E, forklaringsOutput] = energiTaethed_med_forklaring(F, omega)
            [E, forklaringsOutput] = ElektroMat.Energi_og_Effekt.energiTaethed_med_forklaring(F, omega);
        end
        
        function [P, forklaringsOutput] = effektTaethed_med_forklaring(F, omega)
            [P, forklaringsOutput] = ElektroMat.Energi_og_Effekt.effektTaethed_med_forklaring(F, omega);
        end
    end
end