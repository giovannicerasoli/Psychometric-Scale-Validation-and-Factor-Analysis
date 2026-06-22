#pulisce workspace e attiva opzione per riportare i risultati al completo
rm(list = ls()) 
options(max.print=1000000)

#apri librerie necessarie
library(psych)
library(lavaan)
library(GPArotation)
library(semPlot)
library(qgraph)

#seleziona directory di lavoro
setwd("C:/Users/giova/Giogiò/Universita/Psicometria")

#importa dati
dds <- read.table("Cerasoli.csv", header=TRUE, sep=",")

#vediamo il dataset
head(dds)

mydescribe <- describe(dds)

library(summarytools)
view(dfSummary(dds))
dfs <- dfSummary(dds)
dfs[1] <- NULL
dfs[2] <- NULL
dfs[3] <- NULL
dfs[3] <- NULL
dfs[3] <- NULL
dfs[3] <- NULL

mydesc <- descr(dds,
      stats = c("mean", "sd", "min", "q1", "med", "q3", "max", "skewness", "kurtosis"),
      transpose = TRUE)

z <- stack(dds)
library(ggplot2)
ggplot(z, aes(values)) + facet_wrap(~ind, scales="free") + geom_bar () + theme_bw() +
  scale_x_continuous(breaks = c(0:5))



#uso la matrice di correlazione di Pearson perché la maggior parte dei valori di skewness e curtosi sono più o meno all'interno
#dell'intervallo [-1;+1] 


#Vediamo la matrice di correlazione per controllare che non vi siano 
#ridondanze (correlazioni >|.70|)
#salviamo la matrice di correlazione nell'oggetto mat
mat_corr <- cor(dds)
print(mat_corr) 

#inseriamo i coefficienti in un vettore e ordiniamolo in base alla dimensione delle correlazioni
vector_corr <- data.frame(row=rownames(mat_corr)[row(mat_corr)[upper.tri(mat_corr)]], 
                     col=colnames(mat_corr)[col(mat_corr)[upper.tri(mat_corr)]], 
                     corr=mat_corr[upper.tri(mat_corr)])
vector_corr <- vector_corr[order(-vector_corr$corr),] 
vector_corr

#calcoliamo descrittive di vector_corr per media, mediana, minimo e massimo di mat_corr
describe(vector_corr)
head(vector_corr)
tail(vector_corr)

#calcoliamo la correlazione multipla al quadrato per ogni item
#se alcuni item hanno valori prossimi allo zero, probabilmente
#non satureranno su nessun fattore, per cui si potrebbe pensare
#di eliminarli fin da subito
smc(mat_corr)
sort(smc(mat_corr))


#DECIDERE IL NUMERO DI FATTORI DA ESTRARRE IN UNA EFA

#esegue la parallel analysis usando r di Pearson per decidere il numero di fattori da estrarre
#NB: fornisce anche lo scree-plot
par(mar=c(5, 2, 4, 2), cex=0.75)
parallel.analysis <- fa.parallel(dds)
parallel.analysis

# il grafico ci permette di fare varie considerazioni
# a) Scree-plot: da dove si appiattisce la linea spezzata di PC?
# b) quanti valori di PC sono superiori alla linea di soglia rossa?
# c) quanti valori di FA sono superiori a 1 (e quindi alla linea intera orizzontale nera)?

#esegue altre analisi di dimensionalità, tra cui la MAP
dds.vss = VSS(dds)
dds.vss #qui ci interessa solo l'info di "The Velicer MAP achieves a minimum of"


#REALIZZARE EFA

#esegue l'analisi fattoriale usando la matrice di correlazione di Pearson
#estraendo tre fattori col metodo principal axis factoring
dds.paf.3 <- fa(dds, nfactors = 3, fm="pa", rotate="oblimin")
print.psych(dds.paf.3, sort=T)

#ci interessa valutare:
#dimensione delle saturazioni (sono tutte >|.30|?)
#proporzione di varianza spiegata: è maggiore del 40%?

#ordina la pattern matrix in base alle saturazioni e toglie saturazioni inferiori a |.30|
print.psych(dds.paf.3, sort=T,cut=.3)

#EFA NO RIDONDNAZE
#elimino i03 ed i05 perché hanno correlazione multipla al quadrato < i01 ed i02 rispettivamente
no_ridondanze <- subset(dds, select = -c(3, 5))

par(mar=c(5, 2, 4, 2), cex=0.75)
parallel.analysis <- fa.parallel(no_ridondanze)
parallel.analysis

no_ridondanze.vss = VSS(no_ridondanze)
no_ridondanze.vss 

no.rid.paf.3 <- fa(no_ridondanze, nfactors = 3, fm="pa", rotate="oblimin")
print.psych(no.rid.paf.3, sort=T)

print.psych(no.rid.paf.3, sort=T,cut=.3)

#ANALISI DEGLI ITEM PER SCALA

controllo <- dds[,c(6, 7, 8, 9, 10)]
describe(controllo)

an.it.controllo <- psych::alpha(controllo, check.keys=F)
an.it.controllo
#i dati che ci interessano sono in particolare:
#raw_alpha -> alpha di Cronbach basato sulle covarianze
#average_r -> correlazione media inter-item
#r.drop -> correlazione item-totale corretta
#Reliability if an item is dropped@raw_alpha -> alpha senza l'item
#Questa funzione non fornisce le correlazioni multiple al quadrato, che possono
#essere ottenute con la funzione smc
cormul.controllo <- smc(controllo)

#realizziamo una tabella riassuntiva
#prendiamo dai vari oggetti i dati che ci servono
r.it.tot.cor.controllo <- an.it.controllo$item.stats$r.drop
alpha.wo.controllo <- an.it.controllo$alpha.drop$raw_alpha
#e usiamo la funzione round per avere solo due decimali
tabella.alpha.controllo <- round(cbind(r.it.tot.cor.controllo,cormul.controllo,alpha.wo.controllo),2)
tabella.alpha.controllo


#ANALISI FATTORIALE CONFERMATIVA

library(lavaan)

# il simbolo =~ significa "misurato con"
cfa.dds <- ' suicidio =~ i01+i02+i03+i04+i05
             controllo =~ i06+i07+i08+i09+i10
             colpa =~ i11+i12+i13+i14+i15 '

#Testa il modello con MLR -> se dati hanno distribuzione accettabilmente normale,
#ossia con skewness e curtosi comprese fra [-1;+1]
fit.dds <- cfa(cfa.dds, data=dds, estimator="mlr")
summary(fit.dds,fit.measures=TRUE,standardized=T)

modindices(fit.dds)

library(dplyr)
modifica <- modindices(fit.dds) %>% arrange(mi)
modifica$mi <- round(modifica$mi,3)
modifica$epc <- round(modifica$epc,3)
modifica$sepc.lv <- round(modifica$sepc.lv,3)
modifica$sepc.all <- round(modifica$sepc.all,3)
modifica$sepc.nox <- round(modifica$sepc.nox,3)
print(modifica)

#grafico della CFA
library(semPlot)
semPaths(fit.dds)

#grafico con proprietà degli oggetti (tipo tree)
semPaths(fit.dds,
         whatLabels="std",
         #layout
         layout="tree",
         #dimensione caratteri
         edge.label.cex = 0.6,
         #colore frecce
         edge.color="black",
         #spessore bordi
         esize=2,
         #dimensione frecce
         asize=3,
         #dimensione indicatori
         sizeMan=4,
         #dimensione latenti
         sizeLat=6,
         #spessore ovali e rettangoli
         sizeInt=2,
         curvePivot = T)

#grafico con proprietà degli oggetti (tipo circle)
semPaths(fit.dds,
         whatLabels="std",
         #layout
         layout="circle",
         #dimensione caratteri
         edge.label.cex = 0.6,
         #colore frecce
         edge.color="black",
         #spessore bordi
         esize=2,
         #dimensione frecce
         asize=3,
         #dimensione indicatori
         sizeMan=4,
         #dimensione latenti
         sizeLat=6,
         #spessore ovali e rettangoli
         sizeInt=2,
         curvePivot = TRUE)
