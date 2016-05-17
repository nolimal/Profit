  setwd("U:/Profit/")
# Neposredno klicanje SQL ukazov v R
library(dplyr)
library(RPostgreSQL)

source("baza/auth.R",encoding='UTF-8')

# Povežemo se z gonilnikom za PostgreSQL
drv <- dbDriver("PostgreSQL")

# Funkcija za brisanje tabel
  # Izbris tabele, če obstaja
  delete_table <- function(){
    # Funkcija tryCatch prekine povezavo v primeru napake
    tryCatch({
      # Vzpostavimo povezavo
      conn <- dbConnect(drv, dbname = db, host = host,
                        user = user, password = password)
      # Če tabela obstaja, jo zbrišemo, ter najprej zbrišemo tiste, 
      # ki se navezujejo na druge
      dbSendQuery(conn, build_sql('DROP TABLE IF EXISTS stock'))
      dbSendQuery(conn, build_sql('DROP TABLE IF EXISTS sector'))
      dbSendQuery(conn, build_sql('DROP TABLE IF EXISTS company'))
    }, finally = {
      dbDisconnect(conn)
    })
  }
  
# Funkcija za ustvarjanje tabel
  create_table <- function(){
    # Funkcija tryCatch prekine povezavo v primeru napake
    tryCatch({
      # Vzpostavimo povezavo
      conn <- dbConnect(drv, dbname = db, host = host, user = user, password = password)
  
company<- dbSendQuery(conn, build_sql("CREATE TABLE company (
    ticker TEXT PRIMARY KEY,
    full_name TEXT NOT NULL,
    ipo INTEGER,
    ceo TEXT NOT NULL,
    market_cap INTEGER)"
 ))
  
  stock<- dbSendQuery(conn, build_sql("CREATE TABLE stock (
    id_number SERIAL PRIMARY KEY,
    ticker TEXT REFERENCES company(ticker),
    date DATE,
    open INTEGER,
    high INTEGER,
    low INTEGER,
    close INTEGER,
    volume INTEGER, 
    adjusted INTEGER)"
  ))
  sector<- dbSendQuery(conn, build_sql("CREATE TABLE sector (
    type TEXT PRIMARY KEY,
    ticker TEXT REFERENCES company(ticker),
    industry TEXT NOT NULL)"
  ))
  # na koncu grant da bosta videla oba: ..... manjka.....dbSendQuery(conn, build_sql("GRANT ALL to all tables neki "
  
}, finally = {
  # Na koncu nujno prekinemo povezavo z bazo,
  # saj preveč odprtih povezav ne smemo imeti
  dbDisconnect(conn)
  # Koda v finally bloku se izvede, preden program konča z napako
})}
  
  
#   # Funkcija za uvoz podatkov v tabele
#   insert_data <- function(){
#  # Funkcija tryCatch prekine povezavo v primeru napake
#     tryCatch({
#       # Vzpostavimo povezavo z bazo
#       conn <- dbConnect(drv, dbname = db, host = host, user = user, password = password)
#       
#         dbWriteTable(conn, name="company",value="2. podatki/Energy5.csv", overwrite=T, row.names=TRUE)
#       
#       
#     }, finally = {
#       dbDisconnect(conn)
#     })
#   }
  