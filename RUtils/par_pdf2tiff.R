## description: convert PDF to TIFF, then convert TIFF back to PDF.
## prerequisites in your linux system:
# 1. tiff2pdf: sudo apt install libtiff-tools
# 2. pdftoppm: sudo apt install poppler-utils

# load libraries
library(dplyr)
library(future.apply)


# set parameters
in_root_dir <- "/home/yangrui/ssd/minkwd/human_sc/res"
out_root_dir <- "/home/yangrui/ssd/temp"
concurrent_workers <- 15
tiff_resolution <- 300
tiff_to_pdf <- T
del_tiff <- T
in_pdf_pattern <- ".+\\.pdf$"
recursive <- T


# search PDF files (recursively) in `in_root_dir`
data.frame(in_pdf = list.files(in_root_dir, pattern = in_pdf_pattern, full.names = T, recursive = recursive)) %>% 
  mutate(out_dir = gsub(paste0("^", in_root_dir), out_root_dir, dirname(in_pdf))) %>% 
  mutate(out_tif_prefix = file.path(out_dir, gsub("\\.pdf$", "", basename(in_pdf)))) %>% 
  mutate(pdf_to_tif_cmd = paste("pdftoppm -tiff -tiffcompression deflate -r", tiff_resolution, in_pdf, out_tif_prefix, sep = " ")) -> pdf_to_tif_df

# create all output directories
sapply(unique(pdf_to_tif_df$out_dir), function(x) {dir.create(x, showWarnings = T, recursive = T, mode = "0777")})

# convert PDF files to TIFF files
plan(multisession, workers = concurrent_workers)
pdf_to_tif_rc <- future_sapply(unique(pdf_to_tif_df$pdf_to_tif_cmd), function(x) {system(x, wait = T, intern = F)})
table(pdf_to_tif_rc)

# convert TIFF files to PDF files
if (tiff_to_pdf) {
  data.frame(in_tif = list.files(out_root_dir, pattern = ".+\\.tif$", full.names = T, recursive = recursive)) %>% 
    mutate(out_pdf = gsub("\\.tif$", ".pdf", in_tif)) %>% 
    mutate(tif_to_pdf_cmd = paste("tiff2pdf -z -o", out_pdf, in_tif, sep = " ")) -> tif_to_pdf_df
  
  pdf_to_tif_rc <- future_sapply(unique(tif_to_pdf_df$tif_to_pdf_cmd), function(x) {system(x, wait = T, intern = F)})
  print(table(pdf_to_tif_rc))
}

# delete TIFF files
if (del_tiff) {
  file.remove(unique(tif_to_pdf_df$in_tif))
}
