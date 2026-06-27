"""
Genera tabla LaTeX (booktabs) y coefplot a partir de table_tF_inference.csv.

Outputs:
  - results/regs/table_tF_inference.tex
  - results/graphics/figure_tF_coefplot.pdf  (+ .png)
"""

import sys, io
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

import csv
import os
import matplotlib.pyplot as plt
from matplotlib.patches import Rectangle

ROOT     = r"C:\Users\gquij\projects\replication"
CSV_IN   = os.path.join(ROOT, "results", "regs", "table_tF_inference.csv")
TEX_OUT  = os.path.join(ROOT, "results", "regs", "table_tF_inference.tex")
TEX_CI   = os.path.join(ROOT, "results", "regs", "table_tF_inference_withCI.tex")
FIG_DIR  = os.path.join(ROOT, "results", "graphics")
PDF_OUT  = os.path.join(FIG_DIR, "figure_tF_coefplot.pdf")
PNG_OUT  = os.path.join(FIG_DIR, "figure_tF_coefplot.png")

os.makedirs(FIG_DIR, exist_ok=True)


# ---------- 1. CARGA ---------------------------------------------------------
rows = []
with open(CSV_IN, encoding='utf-8') as f:
    for r in csv.DictReader(f):
        rows.append({k: (float(v) if k != "spec" else v) for k, v in r.items()})

# Etiquetas cortas en español para tabla y figura
SHORT_LABELS = {
    "T2 col 1 - IHS(deforest), benchmark": r"T2 c1 — IHS (benchmark)",
    "T2 col 2 - ln(deforest+0.01)":        r"T2 c2 — ln(def + 0{,}01)",
    "T2 col 3 - deforest/muni_area":       r"T2 c3 — def / área muni",
    "T2 col 4 - deforest/mean_def":        r"T2 c4 — def / media",
    "T3 col 7 - cluster state-year":       r"T3 c7 — cluster estado-año",
}
PLOT_LABELS = {
    "T2 col 1 - IHS(deforest), benchmark": "T2 c1: IHS (benchmark)",
    "T2 col 2 - ln(deforest+0.01)":        "T2 c2: ln(def + 0,01)",
    "T2 col 3 - deforest/muni_area":       "T2 c3: def / área muni",
    "T2 col 4 - deforest/mean_def":        "T2 c4: def / media",
    "T3 col 7 - cluster state-year":       "T3 c7: cluster estado-año",
}


# ---------- 2. TABLA LaTeX (booktabs) ----------------------------------------
def stars(t):
    a = abs(t)
    if a > 2.576: return r"$^{***}$"
    if a > 1.960: return r"$^{**}$"
    if a > 1.645: return r"$^{*}$"
    return ""

with open(TEX_OUT, 'w', encoding='utf-8') as f:
    f.write(r"""% Tabla autogenerada por tF_make_outputs.py
% Replicación + extensión tF del paper Assunção, Gandour & Rocha (2023, AEJ Applied)
\begin{table}[!htbp]
  \centering
  \footnotesize
  \caption{Inferencia convencional vs.\ $tF$ (Lee et al., 2022) en las regresiones IV del paper DETER}
  \label{tab:tF_inference}
  \begin{tabular}{lcccccc}
    \toprule
                   &              & $F$ 1\textsuperscript{a} & \multicolumn{2}{c}{SE convencional} & \multicolumn{2}{c}{SE $tF_{5\%}$} \\
    \cmidrule(lr){4-5}\cmidrule(lr){6-7}
    Especificación & $\hat\beta$  & etapa                    & SE      & ($t$)            & SE      & ($t_{tF}$) \\
    \midrule
""")

    for r in rows:
        lbl   = SHORT_LABELS.get(r["spec"], r["spec"])
        b     = r["beta"]
        F     = r["F"]
        se    = r["se"]
        se_tf = r["se_tf05"]
        t_c   = b / se
        t_tf  = b / se_tf
        f.write(
            f"    {lbl} & "
            f"$-${abs(b):.4f}{stars(t_c)} & "
            f"{F:.2f} & "
            f"{se:.4f} & "
            f"($-${abs(t_c):.2f}) & "
            f"{se_tf:.4f} & "
            f"($-${abs(t_tf):.2f}) \\\\\n"
        )

    f.write(r"""    \bottomrule
  \end{tabular}
  \begin{minipage}{0.95\linewidth}
    \vspace{4pt}\scriptsize
    \textit{Notas:} Regresiones replicadas con \texttt{xtivreg2}, efectos fijos de
    municipio y año, controles completos (clima rezagado, visibilidad PRODES, precios
    agrícolas). T2 c1--c4 con cluster municipio + microrregión-año; T3 c7 con cluster
    municipio + estado-año. $F$ es el Kleibergen--Paap Wald rk (equivalente al $F$
    clásico en \textit{single-instrument}, Lee et al.\ 2022, p.~3262 nota 10). Factor de
    ajuste $tF$ al 5\% interpolado linealmente de la Tabla~3A de Lee et al.\ (2022); en el
    rango $F \in [9{,}40;\ 10{,}11]$ los SE crecen entre 1{,}74$\times$ y 1{,}81$\times$.
    Significancia con SE convencionales: $^*$ p$<$0{,}10; $^{**}$ p$<$0{,}05; $^{***}$ p$<$0{,}01.
    \textbf{Ninguna} especificación es significativa al 5\% bajo inferencia $tF$.
  \end{minipage}
\end{table}
""")
print(f"OK  Tabla LaTeX -> {TEX_OUT}")


# ---------- 2b. TABLA LaTeX con IC 95% ---------------------------------------
Z95 = 1.959964
with open(TEX_CI, 'w', encoding='utf-8') as f:
    f.write(r"""% Tabla autogenerada por tF_make_outputs.py — version con IC 95%
% Replicación + extensión tF del paper Assunção, Gandour & Rocha (2023, AEJ Applied)
\begin{table}[!htbp]
  \centering
  \footnotesize
  \setlength{\tabcolsep}{4pt}
  \caption{Intervalos de confianza al 95\%: convencional vs.\ $tF$ (Lee et al., 2022)}
  \label{tab:tF_inference_CI}
  \begin{tabular}{lcccccc}
    \toprule
                   &              & $F$ 1\textsuperscript{a} & \multicolumn{2}{c}{SE convencional} & \multicolumn{2}{c}{SE $tF_{5\%}$} \\
    \cmidrule(lr){4-5}\cmidrule(lr){6-7}
    Especificación & $\hat\beta$  & etapa                    & SE      & IC 95\%                & SE      & IC 95\% \\
    \midrule
""")

    for r in rows:
        lbl       = SHORT_LABELS.get(r["spec"], r["spec"])
        b         = r["beta"]
        F         = r["F"]
        se        = r["se"]
        se_tf     = r["se_tf05"]
        t_c       = b / se
        ci_c_lo   = b - Z95 * se
        ci_c_hi   = b + Z95 * se
        ci_tf_lo  = r["ci95_lo"]
        ci_tf_hi  = r["ci95_hi"]

        def fmt_ci(lo, hi):
            def s(x):
                if x < 0:  return f"$-${abs(x):.3f}"
                if x == 0: return r"$\phantom{-}0.000$"
                return     f"$+${x:.3f}"
            return f"[{s(lo)};\\,{s(hi)}]"

        # Negrita en el extremo positivo del IC tF si cruza cero (lado interesante)
        cross = (ci_tf_lo < 0 and ci_tf_hi > 0)
        ci_tf_str = fmt_ci(ci_tf_lo, ci_tf_hi)
        if cross:
            ci_tf_str = r"\textbf{" + ci_tf_str + "}"

        f.write(
            f"    {lbl} & "
            f"$-${abs(b):.4f}{stars(t_c)} & "
            f"{F:.2f} & "
            f"{se:.4f} & "
            f"{fmt_ci(ci_c_lo, ci_c_hi)} & "
            f"{se_tf:.4f} & "
            f"{ci_tf_str} \\\\\n"
        )

    f.write(r"""    \bottomrule
  \end{tabular}
  \begin{minipage}{0.95\linewidth}
    \vspace{4pt}\scriptsize
    \textit{Notas:} IC 95\% calculados como $\hat\beta \pm 1{,}96 \cdot \text{SE}$, donde
    SE es la convencional con cluster two-way (columnas 4--5) o la $tF$-ajustada al 5\%
    (columnas 6--7). Los SE $tF$ se obtienen multiplicando los SE convencionales por el
    factor de ajuste interpolado de la Tabla~3A de Lee et al.\ (2022). Regresiones
    replicadas con \texttt{xtivreg2}, efectos fijos de municipio y año, controles
    completos. T2 c1--c4: cluster municipio + microrregión-año; T3 c7: cluster municipio
    + estado-año. \textbf{Los IC en negrita cruzan el cero}: todas las especificaciones
    pierden significancia al 5\% bajo inferencia $tF$. Significancia con SE convencionales:
    $^*$ p$<$0{,}10; $^{**}$ p$<$0{,}05.
  \end{minipage}
\end{table}
""")
print(f"OK  Tabla LaTeX (IC) -> {TEX_CI}")


# ---------- 3. COEFPLOT de t-statistics --------------------------------------
fig, ax = plt.subplots(figsize=(9.0, 4.2))

n = len(rows)
y_pos = list(range(n, 0, -1))
labels = [PLOT_LABELS.get(r["spec"], r["spec"]) for r in rows]

t_conv = [r["beta"] / r["se"]      for r in rows]
t_tf   = [r["beta"] / r["se_tf05"] for r in rows]

DY = 0.18

# Convencionales: puntos llenos azul oscuro
ax.scatter(t_conv, [y + DY for y in y_pos],
           s=70, color="#1f4e79", marker="o", zorder=3,
           label="t-stat con SE convencional")

# tF-ajustados: puntos llenos rojo
ax.scatter(t_tf, [y - DY for y in y_pos],
           s=70, color="#c00000", marker="s", zorder=3,
           label=r"t-stat con SE $tF$ al 5%")

# Líneas finas conectando los pares (sólo entre los dos puntos del mismo spec)
for y, tc, tt in zip(y_pos, t_conv, t_tf):
    ax.plot([tc, tt], [y + DY, y - DY], color="grey", lw=0.5, alpha=0.5, zorder=2)

# Umbrales 1.96 y -1.96 (95%)
ax.axvline(-1.96, color="black", ls="--", lw=0.8, alpha=0.7)
ax.axvline( 1.96, color="black", ls="--", lw=0.8, alpha=0.7)
ax.axvline(0,     color="black", ls="-",  lw=0.5, alpha=0.6)

# Sombra zona "no significativa al 5%"
ax.axvspan(-1.96, 1.96, color="grey", alpha=0.08, zorder=0)

ax.set_yticks(y_pos)
ax.set_yticklabels(labels, fontsize=9)
ax.set_xlabel("t-statistic", fontsize=10)
ax.set_xlim(-2.8, 1.4)
ax.set_ylim(0.4, n + 0.6)
ax.grid(axis="x", alpha=0.25, lw=0.5)

# Anotacion del umbral
ax.text(-1.96, n + 0.45, "  $|t| = 1{,}96$", fontsize=8,
        color="black", ha="left", va="bottom")

# Etiqueta con F al lado de cada punto tF
for y, tt, r in zip(y_pos, t_tf, rows):
    ax.text(tt + 0.06, y - DY, f"$F={r['F']:.2f}$",
            fontsize=8, va="center", ha="left", color="#666666")

ax.legend(loc="upper right", frameon=True, fontsize=9, framealpha=0.95)

ax.set_title("Inferencia 2SLS: t-statistics con SE convencional vs $tF$-ajustadas\n"
             "Paper DETER (Assunção et al. 2023) — Tabla 2 cols. 1–4 y Tabla 3 col. 7",
             fontsize=10, pad=10)

plt.tight_layout()
plt.savefig(PDF_OUT, dpi=300, bbox_inches='tight')
plt.savefig(PNG_OUT, dpi=200, bbox_inches='tight')
print(f"OK  Figura PDF -> {PDF_OUT}")
print(f"OK  Figura PNG -> {PNG_OUT}")
