# brclimate
Scrape Brazilian climate data from INPE and INMET.

This R package includes a set of tools for scraping climate data from INPE http://sinda.crn2.inpe.br/PCD/SITE/novo/site/index.php and INMET http://www.inmet.gov.br/portal/.

## Installation (you will need R >= 3.2.4 and possibly Rtools if you are on Windows):
```coffee
install.packages("devtools")
devtools::install_github("gustavobio/brclimate")
```

## Usage:

List all INPE climate stations:
```coffee
inpe_stations()
     ID state             locality
1 32105    AC         Assis Brasil
2 32392    AC            Brasileia
3 32383    AC      Cruzeiro do Sul
4 32076    AC      Cruzeiro do Sul
5 32106    AC Fazenda Santo Afonso
6 32083    AC                Feijo
...
        ID state                 locality
997  30870    TO        Rio Santo Antonio
998  30873    TO         Rio Sao Martinho
999  30869    TO                Rio Urubu
1000 32307    TO           Tocantinopolis
1001 32549    TO UHE Isamu Ikeda Montante
1002 32619    TO                  Xambioa
```

```coffee
inmet_stations(username, password)
    ID      locality state    lat   long
1 82294        ACARAU    CE  -2.88 -40.13
2 82989   AGUA BRANCA    AL  -9.28 -37.90
3 83595       AIMORES    MG -19.49 -41.07
4 83249    ALAGOINHAS    BA -12.28 -38.54
5 82353      ALTAMIRA    PA  -3.21 -52.21
6 82970 ALTO PARNAIBA    MA  -9.10 -45.93
...
        ID                            locality state    lat   long
260 82870 VALE DO GURGUEIA (CRISTIANO CASTRO)    PI  -8.41 -43.71
261 83642                              VICOSA    MG -20.75 -42.85
262 83648                             VITORIA    ES -20.31 -40.31
263 83344                VITORIA DA CONQUISTA    BA -14.88 -40.79
264 83623                         VOTUPORANGA    SP -20.41 -49.98
265 82376                             ZE DOCA    MA  -3.26 -45.65
```

Get the coordinates of a given station (INPE only so far):
```coffee
inpe_station_coordinates(station_id = 31973)
    lat    long 
-22.169 -47.893 
```

Order stations by their distances to a given coordinate:
```coffee
nearest_stations(lat = -22.41, long = -42.01, source = "both")
       ID state               locality     lat    long source  distance
705  31956    RJ   Santa Maria Madalena -21.953 -42.005   inpe  50.81869
1209 83718    RJ              CORDEIRO  -22.010 -42.350  inmet  56.59830
708  31954    RJ            Teresopolis -22.407 -42.793   inpe  80.49186
707  32655    RJ            Sao Fidelis -21.650 -41.750   inpe  88.65575
706  32656    RJ Santo Antonio de Padua -21.533 -42.183   inpe  99.13623
1208 83698    RJ                CAMPOS  -21.750 -41.330  inmet 101.46529
...

nearest_stations(lat = -22.41, long = -42.01, source = "inpe")
       ID state               locality     lat    long source  distance
705 31956    RJ   Santa Maria Madalena -21.953 -42.005   inpe  50.81869
708 31954    RJ            Teresopolis -22.407 -42.793   inpe  80.49186
707 32655    RJ            Sao Fidelis -21.650 -41.750   inpe  88.65575
706 32656    RJ Santo Antonio de Padua -21.533 -42.183   inpe  99.13623
433 32510    MG             Leopoldina -21.468 -42.723   inpe 127.98307
695 69151    RJ      Baia de Guanabara -22.891 -43.145   inpe 128.16467

nearest_stations(lat = -22.41, long = -42.01, source = "inmet")
        ID state                locality    lat   long source distance
1209 83718    RJ               CORDEIRO  -22.01 -42.35  inmet  56.5983
1208 83698    RJ                 CAMPOS  -21.75 -41.33  inmet 101.4653
1212 83743    RJ         RIO DE JANEIRO  -22.88 -43.18  inmet 130.9486
1210 83695    RJ              ITAPERUNA  -21.20 -41.90  inmet 135.0242
1207 83049    RJ  AVELAR (P.DO ALFERES)  -22.35 -43.41  inmet 144.1015
1121 83692    MG           JUIZ DE FORA  -21.76 -43.35  inmet 155.8410
```

Get the data:
```coffee
inpe_station_data(station_id = 31973, start_date = "2005/01/01", end_date  = "2007/02/02")
      Data     Hora Bateria ContAguaSolo100 ContAguaSolo200 ContAguaSolo400 CorrPSol DirVelVentoMax
252 2005-01-01 00:00:00    12.5            0.45            0.48            0.48        0            150
251 2005-01-01 03:00:00    12.5            0.45            0.48            0.48        0            150
250 2005-01-01 06:00:00    12.5            0.45            0.48            0.48        0            150
249 2005-01-01 09:00:00                                       0                                        
248 2005-01-01 12:00:00    12.5            0.45            0.48            0.48        0            150
247 2005-01-01 15:00:00    12.5            0.45            0.48            0.48        0            150
    DirVento Pluvio PressaoAtm RadSolAcum TempAr TempMax TempMin TempSolo100 TempSolo200 TempSolo400
252      140      0        929          0   16.5    33.5    10.5          22          23          23
251      170      0        928          0     16    33.5    10.5          22          23          23
250      140      0        929          0   16.5    33.5    10.5          22          23          23
249      140      0        929          0   16.5                                                   0
248      140      0        929          0   16.5    33.5    10.5          22          23          23
247      140      0        929          0   16.5    33.5    10.5          22          23          23
    UmidInt UmidRel VelVento10m VelVentoMax
252       0      76         1.6         6.2
251       0      84         2.9         6.2
250       0      76         1.6         6.2
249              76         1.6            
248       0      76         1.6         6.2
247       0      76         1.6         6.2
```

```coffee
inmet_station_data(station_id = 83726, username = username, password = password)
  Estacao       Data Hora NebulosidadeMedia NumDiasPrecipitacao PrecipitacaoTotal PressaoMedia TempMaximaMedia TempCompensadaMedia TempMinimaMedia UmidadeRelativaMedia
1   83726 31/01/1961 0000          6.586957                  19             186.7     915.3217        26.86129            22.05742        17.93548             86.25000
2   83726 28/02/1961 0000          6.571429                  25             284.6     917.2940        26.65357            21.81071        17.80357             81.77679
3   83726 31/03/1961 0000          5.408602                  14             177.0     918.1570        27.63871            22.20000        17.32258             74.69355
4   83726 30/04/1961 0000          4.866667                   8              53.1     918.5633        26.77000            21.37133        16.36333             72.09167
5   83726 31/05/1961 0000          4.010753                   6              78.0     920.5935        24.67097            18.95613        13.53871             70.51613
6   83726 30/06/1961 0000          4.133333                   3               5.0     922.1756        23.59000            18.08667        13.01333             66.82500
```
