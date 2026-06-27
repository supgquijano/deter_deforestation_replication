---
title: "Replication and Extension: DETERring Deforestation in the Amazon"
author: "Gustavo Quijano"
date: "2026"
---


Overview
----------------------------

This repository contains a replication and extension of:

> **Assunção, Juliano, Clarissa Gandour, and Romero Rocha**. 2023. "DETERring Deforestation in the Amazon: Environmental Monitoring and Law Enforcement." *American Economic Journal: Applied Economics*, 15(2): 125–156.

The paper estimates the causal effect of satellite-based environmental monitoring (Brazil's DETER system) and law enforcement on deforestation in the Brazilian Amazon, using DETER cloud coverage as an instrumental variable (IV/2SLS) to address the endogeneity between enforcement and deforestation.

The original replication package was published by the authors on the AEA Data and Code Repository (openicpsr-132281). This repository reproduces their full pipeline and adds an econometric extension described below.

The replication was part of an assignment of the course **Intermediate Microeconometrics** (1ECO25)   taught  by Professor José María Rentería at PUCP, during the 2026-1 semester.

Extension: tF Inference Correction (Lee et al. 2022)
----------------------------

The main extension applies the tF inference procedure from:

> **Lee, David S., Justin McCrary, Marcelo J. Moreira, and Jack Porter**. 2022. "Valid t-Ratio Inference for IV." *American Economic Review*, 112(10): 3260–3290.

In single-IV models, the standard t-ratio test is subject to large-sample distortions when the first-stage F-statistic is not sufficiently large. Lee et al. introduce a tF critical value function that adjusts standard errors as a smooth function of the first-stage F-statistic.

This extension applies that correction to the paper's five main IV specifications (Table 2, columns 1–4; Table 3, column 7). The Kleibergen-Paap F-statistic across specifications is approximately 10, which implies adjustment factors of roughly 1.74–1.81 — meaning conventional standard errors understate uncertainty by about 75%. The tF-adjusted results are reported in `results/regs/table_tF_inference.*`.

**Key files for the extension:**

| File | Description |
|------|-------------|
| `_run_tF_inference.do` | Main wrapper — loads data and runs tF analysis |
| `code/analysis/regs/table_tF_inference.do` | Core implementation: interpolates Tables 3A/3B from Lee et al., computes adjusted SE and confidence intervals for all 5 specs |
| `_run_tF_official.do` | Alternative version using the official `tf.ado` package from Princeton |
| `ado/plus/t/tf.ado` | Official Stata package by Lee et al. (distributed from Princeton) |
| `results/regs/table_tF_inference.csv` | Numeric results: β, SE conventional, F, adjustment factor, SE tF, t-ratio tF, CI 95% and 99% |
| `results/regs/table_tF_inference.tex` | LaTeX table of tF results |


How to Run
----------------------------

### Replication of original paper (Stata)

1. Open Stata from `deter_proj.stpr` — this sets the working directory to the project root automatically.
2. Run `_MASTERFILE.do`. This will:
   - Load `data/projectSpecific/panel_forAnalysis.dta` (annual panel, provided)
   - Prepare the data for analysis via `code/projectSpecific/dataPrep_forAnalysis.do`
   - Run all regressions and produce all tables and figures from the paper
3. Outputs are saved to `results/{regs, graphics, stats, sims}/`.

### tF extension (Stata)

Run `_run_tF_inference.do` independently from the project root. It uses the same `panel_forAnalysis.dta` and produces `results/regs/table_tF_inference.*`.

### R figures and descriptive stats

Open RStudio from `deter_proj.Rproj` and run `_masterfile_analysis.R`. This produces the maps (Figure 2) and descriptive graphics (Figure A1).

### Full data pipeline (optional — 22 days)

If you want to rebuild the panel from raw data, open RStudio from `deter_proj.Rproj` and run `code/_MASTERFILE.R`. All raw data inputs are provided or documented with download instructions (see `data/raw2clean/**/documentation/_metadata.txt`). The provided `panel_forAnalysis.dta` makes this step unnecessary for replication purposes.


Description of File Structure
----------------------------

```
replication/
│
├── _MASTERFILE.do                  Main Stata entry point (full analysis)
├── _masterfile_analysis.R          Main R entry point (figures + descriptive stats)
├── _run_tF_inference.do            tF extension entry point
├── _run_tF_official.do             tF extension (official package version)
├── deter_proj.Rproj / .stpr        R and Stata project files (set working directory)
│
├── code/
│   ├── config_proj.do              Defines all directory globals for Stata
│   ├── _MASTERFILE.R               Full R data pipeline (raw to panel)
│   ├── _functions/                 Custom R helper functions
│   ├── raw2clean/                  R scripts: clean each raw data source
│   ├── built/                      R scripts: build municipality-level datasets
│   ├── projectSpecific/            R + Stata: construct analysis variables and panels
│   └── analysis/
│       ├── regs/                   Stata do-files: all regressions (tables + figures)
│       ├── graphics/               R + Stata: maps and descriptive figures
│       ├── stats/                  Stata + R: summary statistics
│       └── sims/                   Stata: counterfactual simulations
│
├── data/
│   ├── raw2clean/                  Raw inputs and documentation by source
│   └── projectSpecific/
│       ├── panel_forAnalysis.dta         Annual panel (521 municipalities, 2006–2016)
│       └── panel_forAnalysis_monthly.dta Monthly panel
│
├── ado/plus/                       Stata user-written packages (pinned versions)
│   └── t/tf.ado                    Lee et al. (2022) tF package
│
└── results/
    ├── regs/                       Regression output tables (tF results included)
    └── graphics/                   Figures (tF coefficient plot included)
```


List of Tables and Programs
----------------------------

### Original paper

| Output | Script |
|--------|--------|
| Table 1 (1st stage) | `code/analysis/regs/table1_stage1_cloudsEnforcement.do` |
| Table 2 (2nd stage, benchmark) | `code/analysis/regs/table2_stage2_enforcementDeforestation.do` |
| Table 3 (robustness) | `code/analysis/regs/table3_robustness.do` |
| Table 4 (placebo) | `code/analysis/regs/table4_placebo.do` |
| Figure 2 (DETER maps) | `code/analysis/graphics/figure2_map_clouds_alerts.R` |
| Figure 3 (monthly 1st stage) | `code/analysis/regs/figure3_stage1_cloudsEnforcement_monthly.do` |
| Figure 4 (placebo) | `code/analysis/regs/figure4_placebo_preDeterClouds.do` |
| Table A1 (summary stats) | `code/analysis/stats/tableA1_sumStats.do` |
| Table B2 (counterfactual) | `code/analysis/sims/tableB2_counterfactual.do` |
| Table C3 (alt. weather) | `code/analysis/regs/tableC3_robustness_altWeather.do` |

### Extension

| Output | Script |
|--------|--------|
| tF inference table (Tables 2 + 3) | `code/analysis/regs/table_tF_inference.do` |


Software Requirements
----------------------------

- **Stata** (version 14.2 or later)
  - All required packages are provided in `ado/plus/` (ivreg2, xtivreg2, estout, outreg2, coefplot, ranktest, mdesc, tf)
  - No SSC installation needed

- **R** (version 3.6.1 recommended)
  - Required packages are installed automatically via `checkpoint` when running `code/_functions/setup.R`

- **Python** (optional, for tF post-processing scripts in `code/analysis/regs/tF_*.py`)


Data Availability
----------------------------

All raw data sources are publicly available. The `data/projectSpecific/panel_forAnalysis.dta` provided in this repository is sufficient to reproduce all Stata results without running the full data pipeline.

Documentation and download instructions for each raw source are in `data/raw2clean/**/documentation/_metadata.txt`. For full details on data provenance, see the original README by Assunção, Gandour, and Rocha (openicpsr-132281), which is preserved below.


Original Authors' Replication Package
----------------------------

The original replication package by Assunção, Gandour, and Rocha is available at:

> Assunção, Juliano, Clarissa Gandour, and Romero Rocha. 2021. "Data and code for: DETERring Deforestation in the Amazon: Environmental Monitoring and Law Enforcement." *American Economic Association* [publisher], Inter-university Consortium for Political and Social Research [distributor]. http://doi.org/10.3886/E132281V1

The code in this repository builds directly on their pipeline. Scripts in `code/raw2clean/`, `code/built/`, `code/projectSpecific/`, and `code/analysis/` are adapted from the original package, with analysis scripts integrated from the authors' Code Ocean capsule (DOI: 10.24433/CO.5098352.v1).


License
----------------------------

Code is licensed under a Modified BSD License. Data is licensed under Creative Commons Attribution 4.0 International. See `LICENSE.txt` for details.
