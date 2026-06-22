# Psychometric Scale Validation and Factor Analysis

Elaborato realizzato per il corso di **Statistica Applicata 2 – Modelli di Misurazione in Psicometria**.

## Obiettivo

Il progetto analizza una scala composta da **15 item** su risposta Likert a cinque livelli.

L’obiettivo è valutare:

* distribuzione e qualità degli item;
* presenza di ridondanze;
* struttura fattoriale della scala;
* affidabilità interna di una sottoscala;
* adattamento di un modello fattoriale confermativo.

## Analisi descrittiva degli item

L’analisi preliminare evidenzia l’assenza di valori mancanti e la presenza di tutte le modalità di risposta per ciascun item.

Gli item:

```r id="d1lwpp"
i01
i02
i03
i04
i05
```

presentano una distribuzione fortemente asimmetrica verso il valore `1`.

Per questi item, il valore `1` viene selezionato almeno dal 68% dei rispondenti, con frequenze superiori all’80% per `i01` e `i03`.

Le distribuzioni estreme sono confermate da:

* coincidenza tra minimo e mediana;
* valori elevati di skewness e kurtosis;
* concentrazione delle risposte nella categoria più bassa.

Gli item dal `i06` al `i15` mostrano invece distribuzioni più vicine alla normalità, con medie e mediane comprese prevalentemente tra 2 e 4.

Per l’analisi fattoriale esplorativa è stata utilizzata la matrice di correlazione di Pearson.

## Ridondanza tra item

Dalla matrice di correlazione emergono due coppie di item con correlazione superiore a `|0.70|`:

```r id="9o8b3n"
cor(i01, i03) = 0.838
cor(i02, i05) = 0.818
```

Queste coppie mostrano evidenza di ridondanza, suggerendo che gli item possano misurare contenuti molto simili.

Le correlazioni multiple al quadrato risultano comunque tutte superiori a `0.10`, indicando una quota di varianza condivisa accettabile per ciascun item.

## Analisi fattoriale esplorativa

Il numero ottimale di fattori è stato identificato attraverso:

* parallel analysis;
* scree plot;
* criterio di Velicer MAP.

Entrambi gli approcci suggeriscono l’estrazione di:

```r id="vsqpj3"
3 fattori
```

La struttura fattoriale ottenuta raggruppa gli item in modo coerente:

```r id="wy2pzp"
PA1 -> i01, i02, i03, i04, i05
PA2 -> i06, i07, i08, i09, i10
PA3 -> i11, i12, i13, i14, i15
```

Le correlazioni tra fattori risultano basse o moderate:

```r id="4lgs6e"
cor(PA1, PA3) = 0.31
cor(PA1, PA2) = 0.07
cor(PA2, PA3) = -0.05
```

## Interpretazione dei fattori

I tre fattori sono stati interpretati come:

```r id="3yo7l2"
PA1 -> Tendenze al suicidio e all’autolesionismo
PA2 -> Tendenze di controllo e correzione
PA3 -> Tendenze alla colpa e all’autocritica
```

È stato inoltre valutato un modello alternativo rimuovendo gli item ridondanti `i03` e `i05`.

La struttura a tre fattori rimane sostanzialmente invariata, suggerendo una buona stabilità dell’impianto fattoriale.

## Affidabilità interna

È stata valutata la sottoscala composta dagli item:

```r id="phz0kp"
i06
i07
i08
i09
i10
```

I principali indici di affidabilità risultano:

```r id="icynrf"
Cronbach's alpha = 0.65
Mean inter-item correlation = 0.27
```

L’alpha indica una coerenza interna moderata, mentre la correlazione media tra item suggerisce una discreta omogeneità della scala.

Le correlazioni item-totale corrette sono tutte superiori a `0.30`, indicando che ciascun item contribuisce in modo adeguato al costrutto comune.

La rimozione di ogni singolo item riduce il valore dell’alpha, confermando che tutti gli item della sottoscala apportano informazioni utili.

## Analisi fattoriale confermativa

È stato stimato un modello fattoriale confermativo a tre fattori, assumendo la seguente struttura:

```r id="bjrqxz"
Fattore 1 -> i01-i05
Fattore 2 -> i06-i10
Fattore 3 -> i11-i15
```

Gli indici di adattamento principali sono:

```r id="qcz35k"
CFI   = 0.853
TLI   = 0.822
RMSEA = 0.098
```

Il modello mostra quindi un adattamento moderato, ma non ottimale.

Gli indici di modifica evidenziano possibili fonti di mancato fit, in particolare:

* correlazioni residue tra alcuni item del primo fattore;
* correlazione residua tra `i12` e `i13`;
* possibili saturazioni incrociate di `i12` e `i08`.

Le principali criticità riguardano anche le coppie `i01-i03` e `i02-i05`, già individuate come ridondanti nell’analisi esplorativa.

## Conclusioni

L’analisi evidenzia una struttura a tre fattori coerente e interpretabile, supportata dalla parallel analysis e dal criterio di Velicer MAP.

Tuttavia, alcuni item presentano distribuzioni molto estreme e ridondanze elevate. Il modello fattoriale confermativo mostra un adattamento solo moderato, suggerendo che la scala potrebbe essere migliorata attraverso la revisione o la rimozione di alcuni item altamente sovrapposti.

Il progetto integra quindi analisi descrittiva, analisi fattoriale esplorativa, affidabilità interna e analisi fattoriale confermativa per valutare in modo completo le proprietà psicometriche della scala.

