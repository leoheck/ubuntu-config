
# Configuração das máquinas do GAPH

> Estes scripts foram feitos para o Ubuntu 14.04, contudo, é bem provavel que ele funcione para as outras versões. **No GAPH usar obrigatoriamente o Ubuntu 14.04.x** que pode ser baixado [aqui](http://www.ubuntu.com/download/desktop/). Instruções de como criar uma pendrive botável podem ser encontradas [aqui](http://www.ubuntu.com/download/desktop/create-a-usb-stick-on-ubuntu)

## Instalação do Ubuntu

Siga as opções padrão de instalação.

Selecione **Inglês** como idioma.

Particione os discos (se ouver mais de 1) conforme o esquema:

![Partition scheme](https://rawgit.com/leoheck/gaph-os-scripts/master/doc/figs/partitions.svg)

*Obs.: Se tiverem mais discos, crie um ponto de montagem de 1TB para o /sim*

Por fim, coloque suas credenciais de usuário. Lembre-se de criar o usuário com um nome diferente do seu usuário de rede. 

Pergunte o **hostname** para algum dos administradores (Amory, Matheus, LHeck)

_Não criptografe o disco!_

## Configuração do GAPH

Para configurar a máquina como um _host_ do GAPH é preciso executar os seguintes comandos no terminal:

```bash
wget https://github.com/leoheck/gaph-os-scripts/archive/master.zip
unzip master.zip
cd gaph-os-scripts-master
sudo ./config-gaph-host.sh
```

## Para instalar o grid SGE 

Para instalar a máquina no grid, primeiro tens que instalar ela na servidora KRITI.
Depois seguir os seguintes passos:

```bash
TODO
```
