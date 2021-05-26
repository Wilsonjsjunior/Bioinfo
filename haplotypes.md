# Análise de rede de haplótipos

## Como reconstruir uma rede de haplótipos, baseados em sequências de DNA usando o [PopART](http://popart.otago.ac.nz/index.shtml)

### Fasta para nexus

Após obtenção da sequências e montagem do *dataset* (`arquivo.fasta`) devemos alinhar as sequências e converter no formato `nexus`. Para converter para esse formato podemos usar alguns programas como o [Mega](https://www.megasoftware.net/dload_mac_beta), [Sequence Matrix](http://www.ggvaidya.com/taxondna/)

Com o arquivo **.nexus** pronto devemos checar algumas métricas importantes que ficam no `header`

```txt
#nexus

begin data;
 dimensions ntax = 1447 nchar = 29928;
 format datatype = DNA gap = - missing = ?;

 matrix

id-sequence1 ATCGATCGTACTAGCTACGATCGATCGATCGATCGATCGATCGATCGTAGCTAGCTAGCTAGTCGATCGTAGCTA
id-sequence2 ATCGATCGTACTAGCTACGATCGATCGATCGATCGATCGATCGATCGTAGCTAGCTAGCTAGTCGATCGTAGCTA
.
.
.
.
;
end;
```

Observação:

* Alguns programas poder modificar esse header, o que impede de alguns programas rodarem como o MrBayes por exemplo, então sugiro que você observe campos como `datatype`, e modifique os campos de `missing` **?** para **N**
* Outros pontos importantes como o `ntax` e `nchar` sempre são importantes a serem checados
* Mais um detalhe é que alguns softwares colocam aspas simples no nome da sequência no exemple acima seria `'id-sequence1'`

> Se lembra de mais algum adiciono depois

### Editar nexus para rodar o PopART

Com o nexus editado "caso precise" é só seguir as recomendações do [PopART](http://popart.otago.ac.nz/doc/popart.pdf) que pode ser baixado [aqui](http://popart.otago.ac.nz/downloads.shtml)

Para nosso caso vamos adaptar o nexus para rodar a contrução da rede de haplótipos usando os `estados` de cada sequência, sendo assim vamos fazer alguns modificações no código:
> Existem outros modelos de correlacionar as sequências inclusive coordenadas geográficas

* Configurar as flags `NTRAITS`, `missing`, `separator` e `TraitLabels`
* Adicionar os comandos abaixo no final do seu arquivo nexus
* É sempre bom renomear o arquivo aós editado para criar histórico na sua análise

```txt
BEGIN TRAITS;
Dimensions NTRAITS=20;
Format labels=yes missing=? separator=spaces;
TraitLabels PE SP RJ ES MG PR RN RS PB AM PA RR AC MA BA SC RO SE AL DF
;
Matrix

id-sequence1 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
id-sequence2 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
.
.
.
;
end;
```
> Como podemos observar acima a sequência 1 é oriunda de SP e a 2 de PE

Com o nexus finalemnte pronto vamos importar o arquivo para o PopART

## Considerações finais

Este documento, ainda que não atualizado, foi desenvolvido para auxiliar pesquisadores e estudantes nas análise haplotípicas. Para dúvidas, sugestões ou comentários entrar em contato Wilson Junior (wilson_jsjunior@hotmail.com)
