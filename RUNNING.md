# Running Notes

## Current State

This bundle is archive-recovery oriented. It is organized for publication and inspection,
but it is not yet a verified reproducible runtime.

## Immediate Issues To Fix Before Running

1. The recovered scripts look oriented toward simulation workflow first, while the paper
data in `article_data/` appears to correspond to the empirical section.

2. Use the repository root entry points instead of sourcing files manually:

```r
Rscript empirical_analysis.R
Rscript run_simulation.R
```

## Suggested Next Cleanup

1. Add package dependency notes for the R environment.
2. Add a lighter default simulation configuration for quick smoke tests.
3. Add one empirical modeling script beyond data inspection.
