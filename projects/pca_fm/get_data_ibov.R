source("preamble.R")

ibov_tickers <- read_delim("data/ibov_tickers.csv", delim = ";", escape_double = FALSE, col_names = FALSE, trim_ws = TRUE, skip = 2) %>% 
  rename(code = 1,	stock = 2, type = 3) %>% 
  transmute(
    tickers = paste0(code, ".SA"),
    code, 
    stock, 
    type = substr(type, start = 1, stop = 2)
  ) %>% 
  filter(type == "ON", stock %in% c("AUTOMOB", "B3") == FALSE)
  
tickers = ibov_tickers$tickers
MDF = NULL

for (i in 1:length(tickers)){
  
  aux = getSymbols(tickers[i],from = '2005-01-01', to = today(), warnings = FALSE, auto.assign = F)[,6]
  colnames(aux) <- tickers[i]
      
  MDF <- cbind(MDF, aux)
}

log_r = diff(log(MDF))
log_r = log_r[-1]

