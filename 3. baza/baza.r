# Neposredno klicanje SQL ukazov v R
library(dplyr)
library(RPostgreSQL)

source("3. baza/auth.R",encoding='UTF-8')

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
      # Če tabela obstaja, jo zbrišemo s funkcijo DROP table. 
      # paziti poramo na vrstni red, saj moramo najprej zbrisati tiste, ki se navezujejo na druge
      dbSendQuery(conn, build_sql('DROP TABLE IF EXISTS stock'))
      dbSendQuery(conn, build_sql('DROP TABLE IF EXISTS company'))
      dbSendQuery(conn, build_sql('DROP TABLE IF EXISTS wfc'))
      dbSendQuery(conn, build_sql('DROP TABLE IF EXISTS aapl'))
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

#Ustvarimo tabelo Company
Company<- dbSendQuery(conn, build_sql("CREATE TABLE company (
    ticker TEXT PRIMARY KEY,
    full_name TEXT NOT NULL,
    ipo INTEGER,
    ceo TEXT NOT NULL,
    market_cap REAL,
    type TEXT NOT NULL,
    industry TEXT NOT NULL)"
 ))

#Ustvarimo tabelo Stock
Stock<- dbSendQuery(conn, build_sql("CREATE TABLE stock (
                                    id_number SERIAL PRIMARY KEY,
                                    ticker TEXT REFERENCES company(ticker),
                                    index REAL,
                                    open REAL,
                                    high REAL,
                                    low REAL,
                                    close REAL,
                                    volume REAL, 
                                    adjusted REAL)"
))

#Ustvarimo tabelo wfc
wfc<- dbSendQuery(conn, build_sql("CREATE TABLE wfc (
    id INTEGER PRIMARY KEY,
    open REAL,
    high REAL,
    low REAL,
    close REAL,
    volume REAL, 
    adjusted REAL)"
))
#Ustvarimo tabelo aapl
aapl<- dbSendQuery(conn, build_sql("CREATE TABLE aapl (
    id INTEGER PRIMARY KEY,
    open REAL,
    high REAL,
    low REAL,
    close REAL,
    volume REAL, 
    adjusted REAL)"
))

  # na koncu grant da bosta videla oba: ..... manjka.....dbSendQuery(conn, build_sql("GRANT ALL to all tables neki "
  
}, finally = {
  # Prekinemo povezavo
  dbDisconnect(conn)
  
})}
  
  
#Uvoz podatkov
#1. Company
Company<-read.csv("2. podatki/Company.csv",fileEncoding = "Windows-1250")

#2. Stock
Stock<-read.csv("2. podatki/Stock.csv",fileEncoding = "Windows-1250")
  
#3. wfc
wfc<-read.csv("2. Podatki/WFC.csv",fileEncoding = "Windows-1250")

#4. aapl
aapl<-read.csv("2. Podatki/AAPL.csv",fileEncoding = "Windows-1250")

#Funcija, ki vstavi podatke
insert_data <- function(){
  tryCatch({
    conn <- dbConnect(drv, dbname = db, host = host,
                      user = user, password = password)
    dbWriteTable(conn, name="company",Company %>% select(-X), append=T, row.names=FALSE)
    dbWriteTable(conn, name="stock",Stock, append=T, row.names=FALSE)
    dbWriteTable(conn, name="wfc",WFC, append=T, row.names=FALSE)
    dbWriteTable(conn, name="aapl",AAPL, append=T, row.names=FALSE)
    
  }, finally = {
    dbDisconnect(conn) 
    
  })
}

delete_table()
create_table()
insert_data()