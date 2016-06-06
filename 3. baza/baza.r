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
      dbSendQuery(conn, build_sql('DROP TABLE IF EXISTS portfolio3'))
      dbSendQuery(conn, build_sql('DROP TABLE IF EXISTS portfolio1'))
      dbSendQuery(conn, build_sql('DROP TABLE IF EXISTS portfolio7'))
      # dbSendQuery(conn, build_sql('DROP TABLE IF EXISTS wfc'))
      # dbSendQuery(conn, build_sql('DROP TABLE IF EXISTS aapl'))
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
                                    index TIMESTAMP,
                                    open REAL,
                                    high REAL,
                                    low REAL,
                                    close REAL,
                                    volume REAL, 
                                    adjusted REAL,
                                    change REAL,
                                    date DATE)"
))

# #Ustvarimo tabelo wfc
# wfc<- dbSendQuery(conn, build_sql("CREATE TABLE wfc (
#     id INTEGER PRIMARY KEY,
#     open REAL,
#     high REAL,
#     low REAL,
#     close REAL,
#     volume REAL, 
#     adjusted REAL)"
# ))
# #Ustvarimo tabelo aapl
# aapl<- dbSendQuery(conn, build_sql("CREATE TABLE aapl (
#     id INTEGER PRIMARY KEY,
#     open REAL,
#     high REAL,
#     low REAL,
#     close REAL,
#     volume REAL, 
#     adjusted REAL)"
# ))

Portfolio3<- dbSendQuery(conn, build_sql("CREATE TABLE portfolio3 (
                                    id INTEGER PRIMARY KEY,
                                    date2 DATE,
                                    sel_tickers TEXT NOT NULL,
                                    am REAL
                                    )"
))

Portfolio1<- dbSendQuery(conn, build_sql("CREATE TABLE portfolio1 (
                                    id INTEGER PRIMARY KEY,
                                    date2 DATE,
                                    sel_tickers TEXT NOT NULL,
                                    am REAL
                                    )"
))

Portfolio7<- dbSendQuery(conn, build_sql("CREATE TABLE portfolio7 (
                                    id INTEGER PRIMARY KEY,
                                    date2 DATE,
                                    sel_tickers TEXT NOT NULL,
                                    am REAL
                                    )"
))

}, finally = {
  # Prekinemo povezavo
  dbDisconnect(conn)
  
})}
  
  
#Uvoz podatkov
#1. Company
Company<-read.csv("2. podatki/Company.csv",fileEncoding = "Windows-1250")

#2. Stock
Stock<-read.csv("2. podatki/Stock.csv",fileEncoding = "Windows-1250")

#3. Portfolio
Portfolio3<-read.csv("2. podatki/Portfolio3.csv",fileEncoding = "Windows-1250")

#4. Portfolio1
Portfolio1<-read.csv("2. podatki/Portfolio1.csv",fileEncoding = "Windows-1250")

#5. Portfolio7
Portfolio7<-read.csv("2. podatki/Portfolio7.csv",fileEncoding = "Windows-1250")
  
#3. wfc
#wfc<-read.csv("2. Podatki/WFC.csv",fileEncoding = "Windows-1250")

#4. aapl
#aapl<-read.csv("2. Podatki/AAPL.csv",fileEncoding = "Windows-1250")

#Funcija, ki vstavi podatke
insert_data <- function(){
  tryCatch({
    conn <- dbConnect(drv, dbname = db, host = host,
                      user = user, password = password)
    dbWriteTable(conn, name="company",Company %>% select(-X), append=T, row.names=FALSE)
    dbWriteTable(conn, name="stock",Stock, append=T, row.names=FALSE)
    dbWriteTable(conn, name="portfolio3",Portfolio3, append=T, row.names=FALSE)
    dbWriteTable(conn, name="portfolio1",Portfolio1, append=T, row.names=FALSE)
    dbWriteTable(conn, name="portfolio7",Portfolio7, append=T, row.names=FALSE)
#    dbWriteTable(conn, name="wfc",WFC, append=T, row.names=FALSE)
#    dbWriteTable(conn, name="aapl",AAPL, append=T, row.names=FALSE)
    
  }, finally = {
    dbDisconnect(conn) 
    
  })
}
# Funkcija za grant
# Dovoljenja za vids in rokv
grant_table <- function(){
  # Funkcija tryCatch prekine povezavo v primeru napake
  tryCatch({
    # Vzpostavimo povezavo
    conn <- dbConnect(drv, dbname = db, host = host,
                      user = user, password = password)
    dbSendQuery(conn, build_sql('GRANT ALL ON company,stock TO vids,rokv,matevzn'))
  }, finally = {
    dbDisconnect(conn)
  })
}


delete_table()
create_table()
insert_data()
grant_table()