# Variance Estimators Monte Carlo

R code for AEM 6850 (Empirical Methods, Cornell, Fall 2025). A Monte Carlo simulation that compares two estimators of a population variance: dividing by n (biased) and dividing by n - 1 (Bessel-corrected, unbiased).

script_files:
- variance_monte_carlo.R : generates a normal population (N = 100,000, true variance 1), draws B = 10,000 samples without replacement at each sample size from 2 to 50, computes both variance estimators, stores the mean and 5th/95th percentiles of each in a data frame (49 rows, one per n), and saves the figure
- Variance-Estimators-Monte-Carlo.Rproj : RStudio project, open this first so the script finds output_figure/

output_figure:
- Monte_Carlo_Sim.png : two panels (divided by n, divided by n - 1) showing the mean estimate, the 5th to 95th percentile band (shaded) and the true variance (red dashed line) against sample size

Other files:
- readme.rtf : full readme with general, methodological and data-specific information
