# brclimate
Scrape Brazilian climate data

This package includes a set of tools for scraping climate data from INPE: http://sinda.crn2.inpe.br/PCD/SITE/novo/site/index.php

## Installation:
```coffee
install.packages("devtools")
devtools::install_github("gustavobio/brclimate")
```

## Usage:

List all climate stations:
```coffee
get_pcds()
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

Get the coordinates of a given station:
```coffee
get_coordinates(station_id = 32392)
    lat    long 
-11.018 -68.740 
```

Find the nearest station:
```coffee
find_nearest_pcds(lat = -22.41, long = -42.01)
 ID state               locality     lat    long      start        end            diff  distance
705 31956    RJ   Santa Maria Madalena -21.953 -42.005 2001-09-17 2016-03-19 756.71429 weeks  50.81869
708 31954    RJ            Teresopolis -22.407 -42.793 2001-09-17 2016-03-19 756.71429 weeks  80.49186
707 32655    RJ            Sao Fidelis -21.650 -41.750 2004-01-01 2008-05-15 228.00000 weeks  88.65575
706 32656    RJ Santo Antonio de Padua -21.533 -42.183 2004-01-01 2011-03-18 376.14286 weeks  99.13623
433 32510    MG             Leopoldina -21.468 -42.723 1998-05-06 2016-01-18 923.71429 weeks 127.98307
695 69151    RJ      Baia de Guanabara -22.891 -43.145 2016-01-01 2016-04-07  13.85714 weeks 128.16467
...
```

Find the span of the dataset (station specific):
```coffee
get_date_range(station_id = 31973)
       start          end 
"2003-06-10" "2016-03-19" 
```

Get the data:
```coffee
get_climate(station_id = 31973, start_date = "2005/01/01", end_date  = "2007/02/02")
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

![Locations of all stations](http://i.imgur.com/1SFHCO7.png)
