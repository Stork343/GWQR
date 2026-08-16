# GWQR

Code and materials for the geographically weighted (spatio-temporal) quantile
regression project, including the published housing-price study and the
accompanying R package.

Published paper:

> 侯健, 王芝皓, 田茂再, 窦燕. 基于异窗宽GTWR模型的商品住宅价格影响因素研究.
> 数理统计与管理, 2022, 41(06): 1003-1014.
>
> Hou, J., Wang, Z., Tian, M., & Dou, Y. Influencing Factors of Commercial
> Housing Prices Based on GTWR with Heterogeneous Bandwidths. Journal of
> Applied Statistics and Management, 2022, 41(6): 1003-1014.

## Repository structure

```text
README.md
RUNNING.md
empirical_analysis.R     # empirical data inspection
run_simulation.R         # simulation entry point
algorithm/               # GTWR estimation workflow
  main.R
  data_generation.R
  function_basic.R
  function_bandwidths.R
  function_estimation.R
  simulation_pre.R
  calibration_n_times.R
article_data/            # housing-price data and derived tables
  data.xlsx
  plotdata.csv
  pcaBeta.csv
  pcaData.xlsx
package/LLQR/            # R package: local linear quantile regression (GWQR building blocks)
  DESCRIPTION
  NAMESPACE
  R/  man/  data/  data-raw/
```

## Notes

- `algorithm/` scripts locate inputs dynamically relative to the script
  directory; results are written to `algorithm/generated_data/` and
  `algorithm/results/`.
- The `package/LLQR` R package implements local linear quantile regression
  components used by the GWQR workflow.

## License

See the license file of the R package (`package/LLQR`) for package code.