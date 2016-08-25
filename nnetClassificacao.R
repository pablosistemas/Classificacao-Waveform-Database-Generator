# descomente essa linha para mudar o diretorio de trabalho para o diretorio que contenha
# os arquivos waveform*. Mude o caminho para o diretorio desejado
setwd("~/Documents/pablo/estagio/venturian")

# carrega biblioteca do metodo 'nnet'
if(!require(nnet)){
  install.packages('nnet')
}
library(nnet)

# le o arquivo de formas de onda com ruido
datanoised <- as.data.frame(read.csv('waveform-+noise.data'))

# nomeia colunas: 'X1',...,'X40','group'
names(datanoised) <- c(sapply(seq(1:40),function(x){paste('X',x,sep="")}),'group')

# transforma coluna de grupo em tipo 'factor'
datanoised$group <- factor(datanoised$group)

# define numero de amostras para treinamento
num.samples.train <- 2000;

# embaralha amostras
sam <- sample(nrow(datanoised),num.samples.train)

# cria base para treinamento
wave.training <- datanoised[sam,] 

# cria modelo de rede neural para predicao
wave.nnet <- nnet(group~.,data=wave.training,size=10,decay=5e-3)

# Apresenta os resultados em forma de tabela verdade
# Compara os resultados preditos com o esperado
# Os valores preditos calculados pelo metodo 'predict' sao atribuidos para predicted, de 'table'.
# Esse metodo utiliza a rede neural criada em nnet, 'wave.nnet'.
# datanoised[-sam] seleciona todos os indices de datanoised nao definidos na variavel 'sam' 
wave.validation <- datanoised[-sam,]
resultado <- predict(wave.nnet,wave.validation,type="class")
table(wave.validation$group,predicted=resultado)

# converte coluna 'group' para tipo numerico por requisito do metodo aggregate
wave.validation$group <- as.numeric(wave.validation$group)

# busca a forma de onda de toda a base, utilizando agregacao por grupo e media dos grupos
# A media foi calculada para reduzir o efeito do ruido, que eh branco (aleatorio), e, portanto,
# sem tendencia. Como a media dos ruidos é zero, essa operacao suavizar o efeito do ruido
esperado <- aggregate(wave.validation,by=list(wave.validation$group),FUN=mean)[,2:42]
predito <- aggregate(data.frame(cbind(wave.validation[,1:40],matrix(as.integer(resultado)))),by=list(matrix(as.integer(resultado))),FUN=mean)[,2:42]
#predito <- aggregate(data.frame(cbind(wave.validation[,1:40],matrix(as.integer(resultado))),by=list(matrix(as.integer(resultado))),FUN=mean)[,2:42]

# define a funcao de plotagem dos graficos
plotaGrafico <- function(nomeArquivo, serieEsperada, serieValidacao){
  # captura indice do numero da classe da onda a ser plotada
  idx <-regexpr("[[:digit:]]",nomeArquivo)
  
  # abre dispositivo externo para escrita em arquivo
  pdf(file=nomeArquivo)
  plot(serieEsperada,t='o',lwd=2,col='red',ylab="amplitude",xlab="amostra")
  lines(serieValidacao,t='o',lwd=2,col='blue')
  legend("topright",legend=c("real","classificacao"),fill=c('red','blue'))
  title(main=paste("Media das curvas da classe ",substr(nomeArquivo,idx,idx)))
  dev.off()
}

# compara as curvas dos dados de treinamento com as classificacoes do metodo

# grava no arquivo 'wave_nnet_group0.pdf' a comparacao da classificacao do grupo 0
plotaGrafico("wave_nnet_group0.pdf",t(esperado[1,1:40]),t(predito[1,1:40]))

# grava no arquivo 'wave_nnet_group1.pdf' a comparacao da classificacao do grupo 1
plotaGrafico("wave_nnet_group1.pdf",t(esperado[2,1:40]),t(predito[2,1:40]))

# grava no arquivo 'wave_nnet_group2.pdf' a comparacao da classificacao do grupo 2
plotaGrafico("wave_nnet_group2.pdf",t(esperado[3,1:40]),t(predito[3,1:40]))
