#!/bin/bash
#function montatela(){
#  echo "Informe seu nome: "
#}
#montatela

_COLUMNS=$(tput cols)
_LINES=$(tput lines)

_MESSAGE="${1:-PET - Programa de Educação Tutorial}"

x=$(( $_LINES / 2 ))
y=$(( ( $_COLUMNS - ${#_MESSAGE} ) / 2 ))

tput clear

tput cup $x $y

tput rev

echo "${_MESSAGE}"

sleep 2

clear
