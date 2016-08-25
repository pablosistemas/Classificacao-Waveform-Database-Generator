---
title: "Classificação do dataset 'Waveform Database Generator'"
author: "Pablo Goulart Silva"
output: html_document
---

## Waveform Database Generator

Problema teste de classificação de sinais utilizando a base de dados disponível no repositório <http://archive.ics.uci.edu/ml/datasets/Waveform+Database+Generator+(Version+2)>. A base de dados é formada pela soma de dois sinais na presença de ruído.

Foram utilizados os métodos de classificação KNN e Redes Neurais para classificar 3 classes de sinais disponíveis no base de dados.
Dentre as 5000 amostras disponíveis no arquivo, utilizamos uma quantidade para treinamento do modelo, enquanto o restante da base foi utilizada para validação do mesmo.

Os métodos apresentados foram utilizados para fins de entendimento, podendo ser melhor calibrados para obtenção de resultados mais acurados.