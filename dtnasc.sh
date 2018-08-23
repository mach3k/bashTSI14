#!/bin/bash
# Exercício do André

_COLUMNS=$(tput cols)     # identifica a quantidade de colunas disponíveis no terminal
_LINES=$(tput lines)      # identifica a quantidade de linhas disponíveis no terminal
anoSistema=$(date +"%Y")  # identifica a data no sistema, extraindo apenas o ano da mesma
mesSistema=$(date +"%m")  # extrai o mês
diaSistema=$(date +"%d")  # extrai o dia - estas 'constantes' serão usadas em diversos pontos do programa
testaNumero='^[0-9]+$'    # string para verificar se um valor é numérico
# chamei de constantes porque seus valores não serão mudados, mas são variáveis comuns
# outro detalhe importante sobre variáveis é que o escopo delas será sempre o mesmo...
# ...independente se foram declaradas dentro ou fora de funções, sempre serão globais.

function escreveCentro() { # declara a função escreveCentro, que será utilizada nas mensagens
  msg=$1                                    # recebe o parâmetro 1 na variável 'msg'
  linha=$2                                  # recebe o parâmetro 2 na variável 'linha'
  _MESSAGE="${1:-$msg}"                     # não faço ideia do que essa m@#$% faz, quem souber, me avisa
  x=$(( ( $_COLUMNS - ${#_MESSAGE} ) / 2 )) # calcula a coluna inicial
  y=$linha                                  # define a linha que será escrito o texto
  tput cup $y $x                            # posiciona o prompt no terminal, na coordenada especificada
  echo "${_MESSAGE}"                        # escreve a mensagem no ponto selecionado
}                                           # fecha o bloco de comandos da função escreveCentro
# detalhe importante sobre funções: elas são chamadas da mesma forma que comandos...
# ...com parâmetros separados por espaço. (Tenha cuidado ao passar strings com espaço como parâmetros)
# eles são recebidos em sequência. Ex.: nomeFuncao $1 $2 $3 ...

function leVariavel() {       # define a função leVariavel, que será usada para ler valores
  msg=$1                      # mensagem dizendo qual informação está sendo solicitada
  tamVar=$2                   # recebe o tamanho da variável que será lida, para calcular o posicionamento
  linha=$3                    # parâmetro que define a linha onde será solicitado a informação
  variavel=$4                 # nome da variável que receberá a informação digitada
  _MESSAGE="${1:-$msg}"       # de novo essa substituição do capeta. Tentei excluir, mas não funciona sem...
  x=$(( ( $_COLUMNS - ${#_MESSAGE} - $tamVar ) / 2 )) # calcula a posição para centralizar a bagaça
  y=$linha                    # linha onde será escrita. Perfumaria, não precisa mudar a variável...
  tput cup $y $x              # posiciona o cursor no ponto calculado
  read -p "$msg" $variavel    # solicita ao usuário a informação
}                             # fecha o bloco de comandos da função

function zeroFill() {   # função para preencher com zeros à esquerda
  valor=$1              # valor a ser alterado
  casasZero=$2          # quantidade de caracteres que o número deve ter
  if [[ ${#valor} -gt $casasZero ]]; then # se o valor tiver mais casas que o solicitado...
    valor="${valor:0:casasZero}"          # ... trunca o número, cortando o excesso
  fi                                      # fim do bloco 'if'
  if [[ ${#valor} -lt $casasZero ]]; then # se for menor...
    vezes=$(( $casasZero - ${#valor} ))   # calcula quanto falta preencher
    varTemp=$valor                        # guarda o valor em uma temporária
    for ((i=1;i<=$vezes;i++)); do         # laço para preencher de zeros
      varTemp="0$varTemp"                 # concatenando o zero..
    done                                  # fim do bloco 'for'
  else                  # se for do mesmo tamanho do solicitado...
    varTemp=$valor      # ...só passa o valor para a temporária
  fi                    # fim do bloco 'if'
}                       # fim do bloco de comandos da função
# detalhes:
# ${ } identifica operações com strings
# ${# } é o mesmo que a função 'len' ou 'length' de outras linguagens, calcula o tamanho da string
# $(( )) identifica operações matemáticas
# o retorno de funções de shell será sempre inteiro, por isso a varTemp será o retorno...
# ...lendo ela após usar a função, já que as variáveis são globais mesmo.

function montaBorda() {  # define a função que faz o quadrado na tela
  altura=$1              # recebe o parâmetro de altura
  largura=$2             # recebe o parâmetro de largura do quadrado
  xIni=$(( ( $_COLUMNS - $largura ) / 2 )) # calcula onde começam as linhas horizontais do quadrado
  xFim=$(( $xIni + $largura ))             # e onde elas terminam
  yIni=$(( ( $_LINES - $altura ) / 2 ))    # calula onde começam as linhas verticais do quadrado
  yFim=$(( $yIni + $altura ))              # e onde elas terminam
  clear                  # limpa a tela (comando básico do bash)
  for ((i=$xIni;i<=$xFim;i++)); do         # repete a escrita do asterisco
    tput cup $yIni $i                      # para as linhas horizontais
    echo -n '*'
    tput cup $yFim $i                      # escreve a linha de baixo
    echo -n '*'
  done
  for ((i=$yIni;i<=$yFim;i++)); do         # escreve as verticais
    tput cup $i $xIni
    echo -n '*'
    tput cup $i $xFim
    echo -n '*'
  done
  tput cup 0 0           # retorna o cursor ao ponto zero (padrão)
}

function testaBissexto() {   # define a função que calcula se o ano é bissexto (relativo a fevereiro)
  ano=$1                     # recebe o parâmetro do ano
  resto4=$(( $ano % 4 ))     # calcula o resto da divisão por quatro
  resto100=$(( $ano % 100 )) # módulo de 100
  resto400=$(( $ano % 400 )) # verifica se é divisível por 400
  if ([ $resto4 = 0 ] && [ $resto100 != 0 ]) || [ $resto400 = 0 ]; then # lógica que define se é bissexto
    return 0 # retorna zero, padrão para funções OK
  else
    return 1 # retorna 1, no caso de não ser bissexto
  fi
}
# não tive paciência para testar se os demais meses são 30 ou 31...

function montaTela() { # função que monta a tela básica
  informe=$1           # parâmetro que define a necessidade de pedir as informações do usuário
  clear                # limpa a tela
  montaBorda 20 80     # utiliza a função previamente definida para escrever o quadrado
  escreveCentro 'Este programa compara a data do sistema com o seu aniversário' $(($yIni+2))
  if ! [ $informe ]; then
    escreveCentro 'Informe nos campos abaixo a data que você nasceu' $(($yIni+3))
  fi
}
# detalhes da função anterior:
# utilizou a função escreveCentro para mostrar mensagens contralizadas na tela
# 0 parâmetro $(($yIni+'n')) posiciona a mensagem 'n' linhas abaixo da borda superior do quadrado

montaTela # chama a função para montar a tela básica

cont=0 # contador temporário de tentativas do usuário
while [ ! $anoOk ] && [ $cont -lt 3 ]; do # enquanto ano não estiver Ok e tentativas forem menores que 3...
  leVariavel 'Ano de nascimento: ' 4 $(($yIni+5)) DT_ANO # lê o ano em que o usuário nasceu
  if [[ $DT_ANO -le $((anoSistema)) ]] && [[ $DT_ANO -gt $((anoSistema-140)) ]] && [[ $DT_ANO =~ $testaNumero ]]; then
    anoOk='true' # Ok: se for menor que ano do sistema, se o cara não tiver mais de 140 anos e for numérico
  else
    if [[ $cont -lt 2 ]]; then # tentativas menor que 2
      if ! [[ $DT_ANO =~ $testaNumero ]]; then  # se não for numérico
        escreveCentro 'Ano inválido! Informe um número de 4 dígitos.' $(($yIni+7))
      else
        if [[ $DT_ANO -gt anoSistema ]]; then  # se maior que ano do sistema
          escreveCentro 'Ano inválido! Parece que você nem nasceu ainda...' $(($yIni+8))
        else  # se o cara tiver mais que 140 anos
          if [ $DT_ANO -lt $((anoSistema-140)) ]; then escreveCentro 'Ano inválido! Ou então voce é velho bagarái...' $(($yIni+8)); fi
        fi
      fi
      escreveCentro "Tentativas restantes: $((2-$cont))" $(($yIni+10)) # informa as tentativas restantes
    else # ou informa que o cidadão não tem capacidade de informar o ano que nasceu...
      escreveCentro 'Uma tarefa tão simples...' $(($yIni+10))
    fi
    sleep 3 # espera 3 segundos antes de continuar
  fi
  let cont++  # incrementa o contador (+1)
  montaTela   # remonta a tela
done

if [ $anoOk ]; then     # se o ano estiver Ok
  testaBissexto $DT_ANO # testa se o ano é bissexto
  bissexto=$?           # recebe o retorno da função ($? é padrão para isso)
  if [ $bissexto -eq 0 ]; then escreveCentro "*O ano de $DT_ANO é bissexto" 20; else escreveCentro "*O ano de $DT_ANO não é bissexto"  $(($yIni+12)); fi
else
  clear
fi

cont=0
while [ ! $mesOk ] && [ $cont -lt 3 ] && [ $anoOk ]; do
  leVariavel 'Mês de nascimento: ' 2  $(($yIni+5)) DT_MES
  zeroFill $DT_MES 2 # preenche de zeros, se tiver menos de 2 caracteres (ou trunca, se for maior)
  DT_MES=$varTemp    # recebe o valor da variável láááá da função
  dataPosterior=0    # variável temporária de controle
  if [[ $DT_MES -gt mesSistema ]] && [[ $DT_ANO -eq anoSistema ]]; then
    dataPosterior=1
    escreveCentro 'O mês informado ainda não chegou...' $(($yIni+7))
    escreveCentro 'Você já nasceu? Você é um vírus? Ou uma entidade não corpórea?' $(($yIni+8))
    sleep 3
  fi
  if [[ $DT_MES -gt 12 ]] || [[ $DT_MES -lt 1 ]] || ! [[ $DT_MES =~ $testaNumero ]] || [[ $dataPosterior -eq 1 ]]; then
    if [ $cont -lt 2 ]; then
      escreveCentro 'Mês inválido! Tente novamente, informando um número de 1 a 12.' $(($yIni+7))
      escreveCentro "Tentativas restantes: $((2-$cont))" $(($yIni+10))
    else escreveCentro 'Putz, mas você é uma anta...' $(($yIni+10)); fi
    sleep 3
  else
    mesOk="true"
  fi
  let cont++
  montaTela
done

if [ $mesOk ]; then # se o mês foi informado com sucesso, escrve na tela a data informada
  escreveCentro 'Data informada (até o momento): '$DT_MES'/'$DT_ANO $(($yIni+12))
  dataSist="$anoSistema$mesSistema$diaSistema" # monta a data do sistema de forma invertida, para comparação
else
  clear
fi

cont=0
while [ ! $diaOk ] && [ $cont -lt 3 ] && [ $mesOk ] && [ $anoOk ]; do
  leVariavel 'Dia de nascimento: ' 2 $(($yIni+5)) DT_DIA
  zeroFill $DT_DIA 2
  DT_DIA=$varTemp
  if [[ $DT_DIA -gt 31 ]] || [[ $DT_DIA -lt 1 ]] || ! [[ $DT_DIA =~ $testaNumero ]]; then
    if [ $cont -lt 2 ]; then
      escreveCentro 'Dia inválido! Tente novamente, informando um número de 1 a 31.' $(($yIni+7))
      escreveCentro "Tentativas restantes: $((2-$cont))" $(($yIni+9))
    else escreveCentro 'Putz, mas você é muito burro mesmo...' $(($yIni+9)); fi
    sleep 3
  else
    dataTeste="$DT_ANO$DT_MES$DT_DIA"
    if [[ $dataTeste -gt $dataSist ]]; then
      escreveCentro "Esse dia ainda não chegou..." $(($yIni+7))
      escreveCentro "Tentativas restantes: $((2-$cont))" $(($yIni+9))
      sleep 3
    elif [[ $dataTeste -eq $dataSist ]]; then
      escreveCentro "Que prodígio! Você acabou de nascer e já sabe usar um computador..." $(($yIni+7))
      escreveCentro "Mas não tem chupisco, essa data não vale." $(($yIni+8))
      escreveCentro "Tentativas restantes: $((2-$cont))" $(($yIni+9))
      sleep 5
    elif [[ $DT_MES -eq 2 ]] && (([[ $DT_DIA -gt 28 ]] && [[ $bissexto -ne 0 ]]) || ([[ $DT_DIA -gt 29 ]] && [[ $bissexto -eq 0 ]])); then
      escreveCentro "Data inválida! Este dia não existe em fevereiro." $(($yIni+7))
      escreveCentro "Tentativas restantes: $((2-$cont))" $(($yIni+9))
      sleep 3
    else
      diaOk='true'
    fi
  fi
  let cont++
  montaTela
done
# não vou explicar tudo de novo...

if [ $diaOk ] && [ $mesOk ] && [ $anoOk ]; then
  montaTela 0 # por estar toda informação ok, não escreve a mensagem pedindo os dados

  escreveCentro "Data do sistema: $diaSistema/$mesSistema/$anoSistema" $(($yIni+5))
  escreveCentro "Data de nascimento informada: $DT_DIA/$DT_MES/$DT_ANO" $(($yIni+7))

  if [ $bissexto -eq 0 ]; then
    escreveCentro "$DT_ANO foi um ano bissexto" $(($yIni+9))
  else
    escreveCentro "$DT_ANO não foi ano bissexto" $(($yIni+9))
  fi

  dataInformada="$DT_MES$DT_DIA"       # temporárias, para comparação
  dataSistema="$mesSistema$diaSistema" #

  if [ $dataSistema -gt $dataInformada ]; then
    escreveCentro "Seu aniversário já passou este ano" $(($yIni+11))
    idade=$(( $anoSistema - $DT_ANO ))
  elif [ $dataSistema -eq $dataInformada ]; then
    escreveCentro "Feliz Aniversario!" $(($yIni+11))
    escreveCentro "Onde vai ser a festa?" $(($yIni+12))
    idade=$(( $anoSistema - $DT_ANO ))
  else
    escreveCentro "Você ainda não fez aniversário este ano." $(($yIni+11))
    escreveCentro "Lembre-se de me convidar para a festa!" $(($yIni+12))
    idade=$(( ($anoSistema - $DT_ANO) - 1 ))
  fi
  if [ $idade -lt 0 ]; then idade=0;fi
  if [ $idade -ne 0 ]; then
    escreveCentro "Você tem $idade anos de idade" $(($yIni+14))
  else
    escreveCentro "Obs.: Verifique sua fralda, talvez esteja suja." $(($yIni+14))
    escreveCentro "Pois você ainda não completou um ano de idade..." $(($yIni+15))
  fi
else
  clear
fi

tput cup 0 0
# e era isso...
