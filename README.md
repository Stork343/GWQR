# GTWR Housing Price Paper Code Bundle

This folder is a cleaned repository-style bundle for the paper:

`基于异窗宽GTWR模型的商品住宅价格影响因素研究`

It consolidates the strongest local candidates for:

- the GTWR algorithm scripts
- the article-level empirical data and derived tables

## Layout

```text
README.md
.gitignore
empirical_analysis.R
RUNNING.md
run_simulation.R
algorithm/
  main.R
  data_generation.R
  function_basic.R
  function_bandwidths.R
  function_estimation.R
  simulation_pre.R
  calibration_n_times.R
article_data/
  data.xlsx
  plotdata.csv
  pcaBeta.csv
  pcaData.xlsx
```

## What Is Included

`algorithm/` contains the best local candidate R implementation for the GTWR workflow.
These files were recovered from an older `GWQR model` project in your local archive.

`article_data/` contains the strongest local candidate data files associated with this
paper's accepted and revision materials.

## Important Limitations

- The original paper folder did not contain a clearly named, self-contained final code repository.
- The current bundle is a reconstruction from local materials.
- `main.R` still contains an old absolute Windows path and may require manual path cleanup before execution.
- The empirical paper data and the recovered algorithm scripts were stored separately in your archive, so this bundle should be treated as the best recovered local package, not a guaranteed final release snapshot.
- The notebook `GTWR/code/Untitled.ipynb` was inspected and excluded because it does not appear to be the real analysis code.

## Most Relevant Files

- Main recovered driver:
  - [algorithm/main.R](./algorithm/main.R)
- Simulation entry:
  - [run_simulation.R](./run_simulation.R)
- Empirical data inspection entry:
  - [empirical_analysis.R](./empirical_analysis.R)
- Main empirical inputs:
  - [article_data/data.xlsx](./article_data/data.xlsx)
  - [article_data/plotdata.csv](./article_data/plotdata.csv)
  - [article_data/pcaBeta.csv](./article_data/pcaBeta.csv)

## Original Source Locations

- Recovered algorithm scripts:
  - `/Users/houjian/Library/CloudStorage/OneDrive-个人/paper/GWQR model/扩展工作/Partial Linear GWQR model/投稿工作/系统科学与数学(reject)/部分线性地理加权分位回归模型研究/data/houseprice/HP in beijing/codes/`
- Recovered article data:
  - `/Users/houjian/Library/CloudStorage/OneDrive-个人/paper/GWQR model/投稿工作/基于异窗宽GTWR模型的商品住宅价格影响因素研究/数理统计与管理(accept)/GTWR/`
  - `/Users/houjian/Library/CloudStorage/OneDrive-个人/paper/GWQR model/投稿工作/基于异窗宽GTWR模型的商品住宅价格影响因素研究/数理统计与管理(accept)/数理统计投稿预修改/data/`
