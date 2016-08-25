# descomente essa linha para mudar o diretorio de trabalho para o diretorio que contenha
# os arquivos waveform*. Mude o caminho para o diretorio desejado
setwd("~/Documents/pablo/estagio/venturian")

# carrega biblioteca do metodo 'knn'
if(!require(class)){
  install.packages('class')
}
library(class)

# le o arquivo de formas de onda com ruido
datanoised <- read.csv('waveform-+noise.data')
# nomeia colunas
names(datanoised) <- c(seq(1,40),'group')
# casting para tipo 'factor' dos grupos dos dados
# datanoised$group <- factor(datanoised$group)
# numero de amostras para utilizar como treinamento
num.lines.train <- 2000;

# separa porcao de treinamento  
training <- datanoised[1:num.lines.train,];

# da porcao de validacao do modelo
testing <- datanoised[num.lines.train:nrow(datanoised),];

# utiliza K-nearest-neighbors para classificar as ondas
knn1 <- knn(training,testing,cl=training$group,k=3)

# Compara a classificacao obtida pelo metodo knn com a classe real
table(predicted=knn1,actual=testing$group)

# agrupa, da base de treinamento, as ondas pelo tipo (label "group") e calcula a media
# dos agrupamentos
# A media foi calculada para reduzir o efeito do ruido, que eh branco (aleatorio), e, portanto,
# sem tendencia. Como a media dos ruidos é zero, essa operacao suavizar o efeito do ruido
aggregated<-aggregate(training,by=list(training$group),FUN=mean)[,2:42]

#aggregated2<-aggregate(testing,by=list(testing$group),FUN=mean)

# cria dataframe da base de validacao e considera a classificacao como a obtida pelo
# metodo KNN
classificacao.knn <- matrix(as.integer(knn1));
classified <- data.frame(cbind(testing[,1:40],classificacao.knn))

# atribui nomes da colunas: '1..40, class'
names(classified) <- c(sapply(seq(1:40),function(x){paste('X',x,sep="")}),'group')

# agrupa os dados classificados pelo seu grupo (label 'class') e tira a media dos grupos
toPlot <- aggregate(classified,by=list(classified$group),FUN=mean)[,2:42]


# busca a forma de onda de toda a base, utilizando agregacao por grupo e media dos grupos
geral <- aggregate(testing,by=list(testing$group),FUN=mean)[,2:42]

# busca a forma de onda de toda a base, utilizando agregacao por grupo e media dos grupos
# geral <- aggregate(datanoised,by=list(datanoised$group),FUN=mean)[,2:42]

# define a funcao de plotagem dos graficos
plotaGrafico <- function(nomeArquivo, serieReal, serieValidacao){
  # captura indice do numero da classe da onda a ser plotada
  idx <- regexpr("[[:digit:]]",nomeArquivo)
  
  pdf(file=nomeArquivo)
  plot(serieReal,t='o',lwd=2,col='red',ylab="amplitude",xlab="amostra")
  lines(serieValidacao,t='o',lwd=2,col='blue')
  legend("topright",legend=c("real","classificacao"),fill=c('red','blue'))
  title(main=paste("Media das curvas da classe ",substr(nomeArquivo,idx,idx)))
  dev.off()
}


# compara as curvas dos dados de treinamento com as classificacoes do metodo

# grava no arquivo 'train_class_group0.pdf' a comparacao da classificacao do grupo 0
plotaGrafico("wave_knn_group0.pdf",t(geral[1,1:40]),t(toPlot[1,1:40]))

# grava no arquivo 'train_class_group1.pdf' a comparacao da classificacao do grupo 1
plotaGrafico("wave_knn_group1.pdf",t(geral[2,1:40]),t(toPlot[2,1:40]))

# grava no arquivo 'train_class_group2.pdf' a comparacao da classificacao do grupo 2
plotaGrafico("wave_knn_group2.pdf",t(geral[3,1:40]),t(toPlot[3,1:40]))
